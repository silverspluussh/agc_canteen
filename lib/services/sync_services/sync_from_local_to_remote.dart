import 'dart:convert';
import 'package:agc_canteen/core/network/api_exceptions_util.dart';
import 'package:agc_canteen/models/sync.model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';
import '../auth/admin_auth_service.dart';
import '../../core/di/injection_container.dart';
import '../../core/network/network_api_dio.dart';

class LocalToRemoteSyncService {
  final AppDatabase _db;
  final NetworkAPI _networkAPI;
  final Connectivity _connectivity;
  final Logger _logger;

  static const _lastSyncKey = 'last_sync_timestamp';

  LocalToRemoteSyncService({
    required AppDatabase db,
    required NetworkAPI networkAPI,
    Connectivity? connectivity,
    Logger? logger,
  }) : _db = db,
       _networkAPI = networkAPI,
       _connectivity = connectivity ?? Connectivity(),
       _logger = logger ?? Logger();

  Future<DateTime?> get lastSync async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getString(_lastSyncKey);
    return timestamp != null ? DateTime.tryParse(timestamp) : null;
  }

  Future<void> _saveLastSync() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
  }

  Future<bool> get isOnline async {
    final results = await _connectivity.checkConnectivity();
    return results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.ethernet);
  }

  /// Runs all local-to-remote sync functions.
  Future<SyncResult> syncAll() async {
    final pushed = <String, int>{};
    final errors = <String>[];

    if (!await isOnline) {
      return SyncResult(
        pushed: pushed,
        pulled: {},
        errors: ['No internet connection'],
      );
    }

    try {
      final orderResult = await syncSingleOrders();
      pushed.addAll(orderResult.pushed);
      errors.addAll(orderResult.errors);

      final bioResult = await syncBioData();
      pushed.addAll(bioResult.pushed);
      errors.addAll(bioResult.errors);

      await _saveLastSync();
    } catch (e) {
      errors.add(e.toString());
    }

    return SyncResult(pushed: pushed, pulled: {}, errors: errors);
  }

  Future<SyncResult> syncSingleOrders() async {
    final pushed = <String, int>{};
    final pulled = <String, int>{};
    final errors = <String>[];

    if (!await isOnline) {
      return SyncResult(
        pushed: pushed,
        pulled: pulled,
        errors: ['No internet connection'],
      );
    }

    try {
      final orders = await _db.getUnsyncedOrders();
      if (orders.isEmpty) {
        return SyncResult(pushed: pushed, pulled: pulled, errors: errors);
      }

      final List<Map<String, dynamic>> payloads = [];
      for (final order in orders) {
        if (order.total <= 0) {
          _logger.w('Skipping order ${order.orderCode}: total is ${order.total}');
          continue;
        }
        payloads.add(await _buildSingleOrderPayload(order));
      }
      try {
        await _networkAPI.postData(
          '/pos/order/create-bulk',
          data: {'orders': payloads},
          builder: (data) {
            return data;
          },
        );
        for (final order in orders) {
          await _db.markOrderSynced(order.id);
        }
        pushed['orders'] = orders.length;
      } on APIException catch (e) {
        _logger.w('Failed to push bulk orders: ${e.message}');
        for (final order in orders) {
          errors.add('Order ${order.orderCode}: ${e.message}');
          await _db.markOrderFailed(order.id);
        }
      } catch (e) {
        _logger.w('Failed to push bulk orders: $e');
        for (final order in orders) {
          errors.add('Order ${order.orderCode}: $e');
          await _db.markOrderFailed(order.id);
        }
      }
      await _saveLastSync();
    } catch (e) {
      errors.add(e.toString());
    }
    return SyncResult(pushed: pushed, pulled: pulled, errors: errors);
  }

  // ─── BioData Sync ──────────────────────────────────────────

  Future<SyncResult> syncBioData() async {
    final pushed = <String, int>{};
    final errors = <String>[];

    if (!await isOnline) {
      return SyncResult(
        pushed: pushed,
        pulled: {},
        errors: ['No internet connection'],
      );
    }

    try {
      final unsynced = await _db.getUnsyncedBioData();
      if (unsynced.isEmpty) {
        return SyncResult(pushed: pushed, pulled: {}, errors: errors);
      }

      // Group by entity type + entity ID
      final byStaff = <int, List<BioDataEntry>>{};
      final byDependant = <int, List<BioDataEntry>>{};
      final byContractorStaff = <int, List<BioDataEntry>>{};
      final byVisitor = <int, List<BioDataEntry>>{};

      for (final entry in unsynced) {
        if (entry.staffId != null) {
          byStaff.putIfAbsent(entry.staffId!, () => []).add(entry);
        } else if (entry.dependantId != null) {
          byDependant.putIfAbsent(entry.dependantId!, () => []).add(entry);
        } else if (entry.contractorStaffId != null) {
          byContractorStaff
              .putIfAbsent(entry.contractorStaffId!, () => [])
              .add(entry);
        } else if (entry.visitorId != null) {
          byVisitor.putIfAbsent(entry.visitorId!, () => []).add(entry);
        }
      }

      Future<void> pushGroup({
        required Map<int, List<BioDataEntry>> groups,
        required String employeeType,
      }) async {
        for (final referenceId in groups.keys) {
          final entries = groups[referenceId]!;
          final payload = {
            'uuid': const Uuid().v4(),
            'referenceId': referenceId,
            'employeeType': employeeType,
            'bioDatas': entries
                .map((e) => {'finger': e.finger, 'data': e.dataBase64})
                .toList(),
          };

          try {
            await _networkAPI.postData(
              '/hr/bio-data/create-bulk',
              data: payload,
              builder: (data) => data,
            );
            for (final entry in entries) {
              await _db.markBioDataSynced(entry.id);
            }
            pushed['bio_data'] = (pushed['bio_data'] ?? 0) + entries.length;
          } catch (e) {
            _logger.w(
              'Failed to push bio-data for $employeeType $referenceId: $e',
            );
            errors.add('BioData $employeeType $referenceId: $e');
            for (final entry in entries) {
              await _db.markBioDataFailed(entry.id);
            }
          }
        }
      }

      // Push staff bio-data — look up each staff's actual employeeType
      for (final staffId in byStaff.keys) {
        final entries = byStaff[staffId]!;
        final staff = await _db.getStaff(staffId);
        final employeeType = staff?.employeeType ?? 'permanent';
        final payload = {
          'uuid': const Uuid().v4(),
          'referenceId': staffId,
          'employeeType': employeeType,
          'bioDatas': entries
              .map((e) => {'finger': e.finger, 'data': e.dataBase64})
              .toList(),
        };

        try {
          await _networkAPI.postData(
            '/hr/bio-data/create-bulk',
            data: payload,
            builder: (data) => data,
          );
          for (final entry in entries) {
            await _db.markBioDataSynced(entry.id);
          }
          pushed['bio_data'] = (pushed['bio_data'] ?? 0) + entries.length;
        } catch (e) {
          _logger.w('Failed to push bio-data for staff $staffId: $e');
          errors.add('BioData staff $staffId: $e');
          for (final entry in entries) {
            await _db.markBioDataFailed(entry.id);
          }
        }
      }

      await pushGroup(groups: byDependant, employeeType: 'dependent');
      await pushGroup(groups: byContractorStaff, employeeType: 'contractor');
      await pushGroup(groups: byVisitor, employeeType: 'visitor');

      await _saveLastSync();
    } catch (e) {
      errors.add(e.toString());
    }

    return SyncResult(pushed: pushed, pulled: {}, errors: errors);
  }

  Future<int> _resolveOrderedBy() async {
    try {
      final cachedEmail = await getIt<AdminAuthService>().getCachedEmail();
      if (cachedEmail != null) {
        final allUsers = await _db.getAllUsers();
        final match = allUsers.where(
          (u) => (u.email?.toLowerCase() ?? '') == cachedEmail.toLowerCase(),
        );
        if (match.isNotEmpty) {
          return match.first.id;
        }
      }
    } catch (_) {}
    return 0;
  }

  Future<Map<String, dynamic>> _buildSingleOrderPayload(Order order) async {
    final posId = await _db.getAllPosDevices().then(
      (pos) => pos.firstOrNull?.id,
    );
    final kitchenid = await _db.getAllPosDevices().then(
      (pos) => pos.firstOrNull?.kitchenId,
    );

    final allTypes = await _db.getAllMealTypes();
    final mealTypeId = allTypes
        .where((t) => t.name.toLowerCase() == order.mealType.toLowerCase())
        .firstOrNull
        ?.id;

    String employeeType = 'permanent';
    final staff = await _db.getStaff(order.orderedById);
    if (staff != null) {
      employeeType = staff.employeeType;
    } else if (await _db.getDependant(order.orderedById) != null) {
      employeeType = 'dependent';
    } else if (await _db.getContractorStaff(order.orderedById) != null) {
      employeeType = 'contractor';
    } else if (await _db.getVisitor(order.orderedById) != null) {
      employeeType = 'visitor';
    }

    return {
      'orderCode': order.orderCode,
      'uuid': order.uuid,
      'employeeType': employeeType,
      'orderType': order.orderType,
      'mealTypeId': mealTypeId ?? 0,
      'total': order.total,
      'orderedBy': order.orderedById,
      'description': order.description ?? '',
      'isAlaCarte': false,
      'posProfileId': posId ?? 0,
      'kitchenId': kitchenid,
      'quantity': 1,
      'createdAt': '',
    };
  }

  Map<String, dynamic> _rowToMap(dynamic row) {
    final encoded = const JsonEncoder().convert(row.toJson());
    return const JsonDecoder().convert(encoded) as Map<String, dynamic>;
  }

  Map<String, dynamic> _toJsonMap(Map<String, dynamic> record) {
    final copy = Map<String, dynamic>.from(record);
    copy.remove('sync_status');
    copy.remove('sync_updated_at');
    return copy;
  }
}
