import 'dart:convert';

import 'package:agc_canteen/services/database/app_database.dart';
import 'package:agc_canteen/services/export/file_export_service.dart';

/// Snapshots every locally-stored voucher (regular + event/function) to a JSON
/// file in the device's Downloads folder, so a terminal that has been offline /
/// unsynced for a long time can be reconciled by hand from a durable file.
class VouchersBackupService {
  final AppDatabase db;
  final FileExportService fileExport;

  VouchersBackupService({required this.db, required this.fileExport});

  Future<String> downloadAll() async {
    final orders = await db.getAllOrders();
    final functionOrders = await db.getAllFunctionOrders();

    final staff = await db.getAllStaff();
    final visitors = await db.getAllVisitors();
    final dependents = await db.getAllDependents();
    final contractors = await db.getAllContractorStaff();

    final staffNames = {
      for (final s in staff) s.id: '${s.firstName} ${s.lastName}'.trim(),
    };
    final visitorNames = {for (final v in visitors) v.id: v.name};
    final dependentNames = {for (final d in dependents) d.id: d.fullname};
    final contractorNames = {for (final c in contractors) c.id: c.name};

    String? resolve(String? employeeType, int? id) {
      if (id == null) return null;
      return switch (employeeType) {
        'visitor' => visitorNames[id],
        'dependent' => dependentNames[id],
        'contractor' => contractorNames[id],
        _ => staffNames[id],
      };
    }

    final unsynced =
        orders.where((o) => o.syncStatus != 2).length +
        functionOrders.where((f) => f.syncStatus != 2).length;

    final map = <String, dynamic>{
      'schema': 'agc_canteen.vouchers.backup',
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'counts': {
        'orders': orders.length,
        'functionOrders': functionOrders.length,
        'unsynced': unsynced,
      },
      'orders': [
        for (final o in orders)
          {...o.toJson(), 'personName': resolve(o.employeeType, o.orderedById)},
      ],
      'functionOrders': [for (final f in functionOrders) f.toJson()],
    };

    final json = const JsonEncoder.withIndent('  ').convert(map);
    final bytes = utf8.encode(json);

    final now = DateTime.now();
    String pad(int n) => n.toString().padLeft(2, '0');
    final stamp =
        '${now.year}${pad(now.month)}${pad(now.day)}_'
        '${pad(now.hour)}${pad(now.minute)}${pad(now.second)}';

    return fileExport.saveToDownloads(
      fileName: 'vouchers_backup_$stamp.json',
      bytes: bytes,
    );
  }
}
