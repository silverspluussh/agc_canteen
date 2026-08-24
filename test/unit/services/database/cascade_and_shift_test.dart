import 'package:agc_canteen/core/enums/employee_type.enum.dart';
import 'package:agc_canteen/services/database/app_database.dart';
import 'package:agc_canteen/services/database/tables.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = createTestDatabase();
  });

  tearDown(() async {
    await db.close();
  });

  group('insertShift meal-type replace', () {
    test('empty mealTypeIds on replace clears previous restrictions', () async {
      await db.insertShift(
        ShiftsCompanion.insert(id: const Value(1), name: 'Day', hours: 8),
        mealTypeIds: const [10, 20],
        mode: InsertMode.insertOrReplace,
      );
      expect(await db.getShiftMealTypeIds(1), [10, 20]);

      await db.insertShift(
        ShiftsCompanion.insert(id: const Value(1), name: 'Day', hours: 8),
        mealTypeIds: const [],
        mode: InsertMode.insertOrReplace,
      );
      expect(await db.getShiftMealTypeIds(1), isEmpty);
    });
  });

  group('entity delete cascades NFC cards', () {
    test('deleteVisitor removes visitor cards but not staff cards with same id',
        () async {
      await seedVisitor(db, id: 5, name: 'Vis');
      await seedStaff(db, id: 5, firstName: 'Staff', lastName: 'SameId');
      await seedNfcCard(
        db,
        id: 1,
        tagId: 'V5',
        assignedToId: 5,
        assignedToType: 'visitor',
      );
      await seedNfcCard(
        db,
        id: 2,
        tagId: 'S5',
        assignedToId: 5,
        assignedToType: 'permanent',
      );

      await db.deleteVisitor(5);

      expect(await db.getVisitor(5), isNull);
      expect(await db.getCardByTagId('V5'), isNull);
      expect(await db.getCardByTagId('S5'), isNotNull);
    });

    test('deleteContractorStaff removes contractor cards', () async {
      await seedContractorStaff(db, id: 8, name: 'C');
      await seedNfcCard(
        db,
        id: 1,
        tagId: 'C8',
        assignedToId: 8,
        assignedToType: 'contractorstaff',
      );

      await db.deleteContractorStaff(8);

      expect(await db.getContractorStaff(8), isNull);
      expect(await db.getCardByTagId('C8'), isNull);
    });

    test('deleteDependent removes dependent cards and bio', () async {
      await seedStaff(db, id: 1, firstName: 'Parent', lastName: 'Staff');
      await seedDependent(db, id: 3, fullname: 'Dep', staffId: 1);
      await seedNfcCard(
        db,
        id: 1,
        tagId: 'D3',
        assignedToId: 3,
        assignedToType: 'dependent',
      );
      await db.insertBioData(
        BioDataEntriesCompanion.insert(
          id: const Value(99),
          finger: 'thumb',
          dataBase64: 'tmpl',
          isActive: const Value(true),
          dependentId: const Value(3),
          createdAt: DateTime.now().toIso8601String(),
          updatedAt: DateTime.now().toIso8601String(),
        ),
      );

      await db.deleteDependent(3);

      expect(await db.getDependent(3), isNull);
      expect(await db.getCardByTagId('D3'), isNull);
      expect(await db.getBioData(99), isNull);
    });
  });

  group('deleteStaff dependent cascade', () {
    test('removes dependent rows, cards, and bio (not bare delete)', () async {
      await seedStaff(db, id: 1, firstName: 'Parent', lastName: 'Staff');
      await seedDependent(db, id: 10, fullname: 'Kid', staffId: 1);
      await seedNfcCard(
        db,
        id: 1,
        tagId: 'KID',
        assignedToId: 10,
        assignedToType: 'dependent',
      );
      await db.insertBioData(
        BioDataEntriesCompanion.insert(
          id: const Value(50),
          finger: 'index',
          dataBase64: 'kid-tmpl',
          isActive: const Value(true),
          dependentId: const Value(10),
          createdAt: DateTime.now().toIso8601String(),
          updatedAt: DateTime.now().toIso8601String(),
        ),
      );

      await db.deleteStaff(1);

      expect(await db.getStaff(1), isNull);
      expect(await db.getDependent(10), isNull);
      expect(await db.getCardByTagId('KID'), isNull);
      expect(await db.getBioData(50), isNull);
    });
  });

  group('deleteCardsForEntity', () {
    test('only deletes cards matching the entity type', () async {
      await seedNfcCard(
        db,
        id: 1,
        tagId: 'A',
        assignedToId: 1,
        assignedToType: 'visitor',
      );
      await seedNfcCard(
        db,
        id: 2,
        tagId: 'B',
        assignedToId: 1,
        assignedToType: 'dependent',
      );

      await db.deleteCardsForEntity(1, EmployeeType.visitor);

      expect(await db.getCardByTagId('A'), isNull);
      expect(await db.getCardByTagId('B'), isNotNull);
    });
  });
}
