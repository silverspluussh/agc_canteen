import 'dart:async';

import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../pos/pos_fingerprint_service.dart';

export '../pos/pos_fingerprint_service.dart' show FingerprintResult;

// ─── Mock staff & fingerprint data ──────────────────────────────────────────

class MockStaffEntry {
  final String id;
  final String firstName;
  final String lastName;
  final String fpId;

  const MockStaffEntry({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.fpId,
  });

  String get displayName => '$firstName $lastName';
}

const List<MockStaffEntry> kMockStaff = [
  MockStaffEntry(id: 'staff_mock_001', firstName: 'Kwame', lastName: 'Asante', fpId: 'fp_mock_001'),
  MockStaffEntry(id: 'staff_mock_002', firstName: 'Ama', lastName: 'Mensah', fpId: 'fp_mock_002'),
  MockStaffEntry(id: 'staff_mock_003', firstName: 'Yaw', lastName: 'Boateng', fpId: 'fp_mock_003'),
  MockStaffEntry(id: 'staff_mock_004', firstName: 'Akosua', lastName: 'Darko', fpId: 'fp_mock_004'),
  MockStaffEntry(id: 'staff_mock_005', firstName: 'Kofi', lastName: 'Agyeman', fpId: 'fp_mock_005'),
];

// ─── Mock fingerprint device ────────────────────────────────────────────────

/// Drop-in replacement for [PosFingerprintService] that simulates a
/// fingerprint scanner using pre-defined mock data.
///
/// On each [capture] call the mock cycles through available mock staff
/// members so different staff can sign in across attempts.
class MockPosFingerprintService extends PosFingerprintService {
  int _currentIndex = 0;
  String? _capturedFpId;

  final StreamController<FingerprintResult> _captureController =
      StreamController<FingerprintResult>.broadcast();

  @override
  Stream<FingerprintResult> get captureStream => _captureController.stream;

  MockStaffEntry get currentStaff => kMockStaff[_currentIndex];

  List<MockStaffEntry> get allMockStaff => kMockStaff;

  /// Choose which mock staff member to simulate on the **next** [capture] call.
  void selectStaff(int index) {
    if (index >= 0 && index < kMockStaff.length) {
      _currentIndex = index;
    }
  }

  /// Choose by staff-id.
  void selectStaffById(String staffId) {
    final idx = kMockStaff.indexWhere((s) => s.id == staffId);
    if (idx >= 0) _currentIndex = idx;
  }

  /// Returns the id of the fingerprint that was "scanned" during the last
  /// [capture] call, or `null` if no capture has happened yet.
  String? get lastCapturedFpId => _capturedFpId;

  // ─── Core device methods ───────────────────────────────────────────────

  @override
  Future<bool> init() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  Future<FingerprintResult?> capture({int templateIndex = 0}) async {
    // Simulate real scanner delay
    await Future.delayed(const Duration(milliseconds: 600));

    final staff = kMockStaff[_currentIndex];
    _capturedFpId = staff.fpId;

    final result = FingerprintResult(
      success: true,
      templateBase64: _capturedFpId,
      data: Uint8List.fromList(_capturedFpId!.codeUnits),
    );

    _captureController.add(result);

    // Rotate to the next staff for the next capture attempt
    _currentIndex = (_currentIndex + 1) % kMockStaff.length;

    return result;
  }

  @override
  Future<int?> verify(String templateBase64, {int templateIndex = 0}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (_capturedFpId != null && _capturedFpId == templateBase64) {
      return 100;
    }
    return 0;
  }

  @override
  Future<FingerprintResult?> enroll({int templateIndex = 0}) async {
    return capture(templateIndex: templateIndex);
  }

  @override
  Future<void> cancel() async {
    _capturedFpId = null;
  }

  @override
  Future<bool> isAvailable() async {
    return true;
  }

  void dispose() {
    _captureController.close();
  }
}

// ─── DB seeder ──────────────────────────────────────────────────────────────

/// Seeds the local SQLite database with mock staff and fingerprint records.
/// Safe to call multiple times — uses [InsertMode.insertOrIgnore].
class MockDataSeeder {
  final AppDatabase _db;

  MockDataSeeder(this._db);

  Future<void> seed() async {
    final now = DateTime.now().toIso8601String();

    await _db.transaction(() async {
      for (final s in kMockStaff) {
        await _db.insertStaff(
          StaffCompanion(
            id: Value(s.id),
            firstName: Value(s.firstName),
            lastName: Value(s.lastName),
            phone: const Value.absent(),
            email: const Value.absent(),
            syncStatus: const Value(0),
            syncUpdatedAt: Value(now),
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }

      for (final s in kMockStaff) {
        await _db.insertFingerprint(
          FingerprintsCompanion(
            id: Value(s.fpId),
            staffId: Value(s.id),
            // Store the fp-id as the template so verify() can match it
            dataBase64: Value(s.fpId),
            isActive: const Value(true),
            createdAt: Value(now),
            updatedAt: Value(now),
            syncStatus: const Value(0),
            syncUpdatedAt: Value(now),
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }
    });
  }
}

// ─── Convenience initializer ────────────────────────────────────────────────

/// Seeds the database with mock staff and fingerprint records.
///
/// Call this once during app initialisation (e.g. in `main()` before
/// `runApp`), then add [mockFingerprintOverrides] to your [ProviderScope].
///
/// ```dart
/// final database = DatabaseService.instance.db;
/// await seedMockData(database);
/// ```
Future<void> seedMockData(AppDatabase database) async {
  final seeder = MockDataSeeder(database);
  await seeder.seed();
}
