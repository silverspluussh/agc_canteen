enum EmployeeType {
  permanent,
  graduateTrainee,
  nationalService,
  intern,
  contractor,
  visitor,
  dependent;

  bool get isStaffType => switch (this) {
    permanent || graduateTrainee || nationalService || intern => true,
    _ => false,
  };

  String get entityName => switch (this) {
    permanent => 'Staff',
    graduateTrainee => 'Graduate Trainee',
    nationalService => 'National Service',
    intern => 'Intern',
    contractor => 'Contractor',
    visitor => 'Visitor',
    dependent => 'Dependent',
  };

  /// POS / bio-data API entity class (`staff|contractorstaff|visitor|dependent`).
  ///
  /// Distinct from HR staff subtypes stored locally (`permanent`,
  /// `graduateTrainee`, …) and from display labels.
  String get posApiEmployeeType => switch (this) {
    permanent || graduateTrainee || nationalService || intern => 'staff',
    contractor => 'contractorstaff',
    visitor => 'visitor',
    dependent => 'dependent',
  };

  /// Maps a locally stored employee-type string to the POS/bio-data API value.
  ///
  /// Accepts HR subtypes, enum names, display labels, and already-correct API
  /// values. Unknown inputs fall back to `staff` so uploads never send an
  /// unrecognized HR subtype like `permanent`.
  static String toPosApiEmployeeType(String? raw) {
    final parsed = tryParse(raw);
    if (parsed != null) return parsed.posApiEmployeeType;

    final normalized = raw?.trim().toLowerCase() ?? '';
    return switch (normalized) {
      'staff' || 'contractorstaff' || 'visitor' || 'dependent' => normalized,
      _ => 'staff',
    };
  }

  /// Parses API/DB strings such as `permanent`, `graduateTrainee`,
  /// `Graduate Trainee`, `Staff`, etc.
  static EmployeeType? tryParse(String? raw) {
    if (raw == null) return null;
    final normalized = raw.trim().toLowerCase().replaceAll(
      RegExp(r'[\s_-]+'),
      '',
    );
    if (normalized.isEmpty) return null;

    for (final type in EmployeeType.values) {
      if (type.name.toLowerCase() == normalized) return type;
      if (type.employee.toLowerCase().replaceAll(RegExp(r'[\s_-]+'), '') ==
          normalized) {
        return type;
      }
      if (type.entityName.toLowerCase().replaceAll(RegExp(r'[\s_-]+'), '') ==
          normalized) {
        return type;
      }
    }

    // Common aliases from API / cards
    return switch (normalized) {
      'staff' || 'permanentstaff' => EmployeeType.permanent,
      'gt' || 'graduatetrainee' => EmployeeType.graduateTrainee,
      'ns' || 'nationalservice' => EmployeeType.nationalService,
      'contractorstaff' => EmployeeType.contractor,
      _ => null,
    };
  }
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
