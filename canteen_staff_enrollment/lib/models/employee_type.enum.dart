enum EmployeeType {
  permanent, graduateTrainee, nationalService, intern, contractor, visitor, dependent;

  bool get isStaffType => switch (this) {
        permanent || graduateTrainee || nationalService || intern => true,
        _ => false,
      };

  String get entityName => switch (this) {
        permanent => 'Permanent',
        graduateTrainee => 'Graduate Trainee',
        nationalService => 'National Service',
        intern => 'Intern',
        contractor => 'Contractor',
        visitor => 'Visitor',
        dependent => 'Dependent',
      };
}

extension EmployeeTypeExtension on EmployeeType {
  String get employee {
    switch (this) {
      case EmployeeType.permanent:
        return 'Permanent';
      case EmployeeType.graduateTrainee:
        return 'Graduate Trainee';
      case EmployeeType.nationalService:
        return 'National Service';
      case EmployeeType.intern:
        return 'Intern';
      case EmployeeType.contractor:
        return 'Contractor';
      case EmployeeType.visitor:
        return 'Visitor';
      case EmployeeType.dependent:
        return 'Dependent';
    }
  }
}
