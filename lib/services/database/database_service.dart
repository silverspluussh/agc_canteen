import 'dart:io';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'app_database.dart';

class DatabaseService {
  DatabaseService._();

  static final DatabaseService _instance = DatabaseService._();
  static DatabaseService get instance => _instance;

  late final AppDatabase db;

  AppDatabase get database => db;

  Future<void> init() async {
    final dbPath = p.join(
      (await getApplicationDocumentsDirectory()).path,
      'agc_canteen.db',
    );
    db = AppDatabase(NativeDatabase(File(dbPath)));
  }

  Future<void> clearAll() => db.clearAll();
 // Future<Map<String, int>> getSyncStats() => db.getSyncStats();
  Future<void> close() => db.close();
}
