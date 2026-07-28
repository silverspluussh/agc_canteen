import 'package:agc_canteen/core/enums/employee_type.enum.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EmployeeType.tryParse', () {
    test('parses exact enum names case-insensitively', () {
      expect(EmployeeType.tryParse('permanent'), EmployeeType.permanent);
      expect(EmployeeType.tryParse('Permanent'), EmployeeType.permanent);
      expect(EmployeeType.tryParse('DEPENDENT'), EmployeeType.dependent);
      expect(EmployeeType.tryParse('contractor'), EmployeeType.contractor);
      expect(EmployeeType.tryParse('visitor'), EmployeeType.visitor);
    });

    test('parses display/entity names with spaces and punctuation', () {
      expect(
        EmployeeType.tryParse('Graduate Trainee'),
        EmployeeType.graduateTrainee,
      );
      expect(
        EmployeeType.tryParse('graduate-trainee'),
        EmployeeType.graduateTrainee,
      );
      expect(
        EmployeeType.tryParse('National Service'),
        EmployeeType.nationalService,
      );
      expect(EmployeeType.tryParse('Staff'), EmployeeType.permanent);
    });

    test('parses common API/card aliases', () {
      expect(EmployeeType.tryParse('staff'), EmployeeType.permanent);
      expect(EmployeeType.tryParse('permanentstaff'), EmployeeType.permanent);
      expect(EmployeeType.tryParse('gt'), EmployeeType.graduateTrainee);
      expect(
        EmployeeType.tryParse('graduatetrainee'),
        EmployeeType.graduateTrainee,
      );
      expect(EmployeeType.tryParse('ns'), EmployeeType.nationalService);
      expect(
        EmployeeType.tryParse('nationalservice'),
        EmployeeType.nationalService,
      );
      expect(
        EmployeeType.tryParse('contractorstaff'),
        EmployeeType.contractor,
      );
    });

    test('returns null for null, empty, whitespace-only, and unknown values', () {
      expect(EmployeeType.tryParse(null), isNull);
      expect(EmployeeType.tryParse(''), isNull);
      expect(EmployeeType.tryParse('   '), isNull);
      expect(EmployeeType.tryParse('alien'), isNull);
      expect(EmployeeType.tryParse('unknown_type_123'), isNull);
    });

    test('trims surrounding whitespace before matching', () {
      expect(EmployeeType.tryParse('  dependent  '), EmployeeType.dependent);
    });
  });

  group('EmployeeType.isStaffType', () {
    test('true for permanent, graduateTrainee, nationalService, intern', () {
      expect(EmployeeType.permanent.isStaffType, isTrue);
      expect(EmployeeType.graduateTrainee.isStaffType, isTrue);
      expect(EmployeeType.nationalService.isStaffType, isTrue);
      expect(EmployeeType.intern.isStaffType, isTrue);
    });

    test('false for contractor, visitor, dependent', () {
      expect(EmployeeType.contractor.isStaffType, isFalse);
      expect(EmployeeType.visitor.isStaffType, isFalse);
      expect(EmployeeType.dependent.isStaffType, isFalse);
    });
  });

  group('EmployeeType.entityName', () {
    test('maps each type to its expected display label', () {
      expect(EmployeeType.permanent.entityName, 'Staff');
      expect(EmployeeType.graduateTrainee.entityName, 'Graduate Trainee');
      expect(EmployeeType.nationalService.entityName, 'National Service');
      expect(EmployeeType.intern.entityName, 'Intern');
      expect(EmployeeType.contractor.entityName, 'Contractor');
      expect(EmployeeType.visitor.entityName, 'Visitor');
      expect(EmployeeType.dependent.entityName, 'Dependent');
    });
  });
}
