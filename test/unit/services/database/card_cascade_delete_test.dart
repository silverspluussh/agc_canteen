import 'package:agc_canteen/core/enums/employee_type.enum.dart';
import 'package:agc_canteen/services/database/app_database.dart';
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

  test(
    'deleteStaff does not delete NFC cards belonging to other entity types '
    'that share the same assignedToId',
    () async {
      await seedStaff(db, id: 5, firstName: 'Staff', lastName: 'Five');
      await seedVisitor(db, id: 5, name: 'Visitor Five');
      await seedNfcCard(
        db,
        id: 1,
        tagId: 'STAFF-TAG',
        assignedToId: 5,
        assignedToType: 'staff',
      );
      await seedNfcCard(
        db,
        id: 2,
        tagId: 'VISITOR-TAG',
        assignedToId: 5,
        assignedToType: 'visitor',
      );

      await db.deleteStaff(5);

      expect(await db.getCardByTagId('STAFF-TAG'), isNull);
      final visitorCard = await db.getCardByTagId('VISITOR-TAG');
      expect(visitorCard, isNotNull);
      expect(visitorCard!.assignedToType, 'visitor');
      expect(await db.getVisitor(5), isNotNull);
    },
  );

  test(
    'deleteCardsByAssignedTo only removes cards matching the entity type',
    () async {
      await seedNfcCard(
        db,
        id: 10,
        tagId: 'DEP',
        assignedToId: 9,
        assignedToType: 'dependent',
      );
      await seedNfcCard(
        db,
        id: 11,
        tagId: 'CON',
        assignedToId: 9,
        assignedToType: 'contractor',
      );

      await db.deleteCardsByAssignedTo(9, entityType: EmployeeType.dependent);

      expect(await db.getCardByTagId('DEP'), isNull);
      expect(await db.getCardByTagId('CON'), isNotNull);
    },
  );
}
