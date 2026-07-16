// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SitesTable extends Sites with TableInfo<$SitesTable, Site> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SitesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noOfEmployeesMeta = const VerificationMeta(
    'noOfEmployees',
  );
  @override
  late final GeneratedColumn<int> noOfEmployees = GeneratedColumn<int>(
    'no_of_employees',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<String> startDate = GeneratedColumn<String>(
    'start_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<String> endDate = GeneratedColumn<String>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncUpdatedAtMeta = const VerificationMeta(
    'syncUpdatedAt',
  );
  @override
  late final GeneratedColumn<String> syncUpdatedAt = GeneratedColumn<String>(
    'sync_updated_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    location,
    noOfEmployees,
    isActive,
    startDate,
    endDate,
    syncStatus,
    syncUpdatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sites';
  @override
  VerificationContext validateIntegrity(
    Insertable<Site> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('no_of_employees')) {
      context.handle(
        _noOfEmployeesMeta,
        noOfEmployees.isAcceptableOrUnknown(
          data['no_of_employees']!,
          _noOfEmployeesMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('sync_updated_at')) {
      context.handle(
        _syncUpdatedAtMeta,
        syncUpdatedAt.isAcceptableOrUnknown(
          data['sync_updated_at']!,
          _syncUpdatedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Site map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Site(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      noOfEmployees: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}no_of_employees'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_date'],
      ),
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_date'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
      syncUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_updated_at'],
      ),
    );
  }

  @override
  $SitesTable createAlias(String alias) {
    return $SitesTable(attachedDatabase, alias);
  }
}

class Site extends DataClass implements Insertable<Site> {
  final int id;
  final String name;
  final String? location;
  final int noOfEmployees;
  final bool isActive;
  final String? startDate;
  final String? endDate;
  final int syncStatus;
  final String? syncUpdatedAt;
  const Site({
    required this.id,
    required this.name,
    this.location,
    required this.noOfEmployees,
    required this.isActive,
    this.startDate,
    this.endDate,
    required this.syncStatus,
    this.syncUpdatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    map['no_of_employees'] = Variable<int>(noOfEmployees);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<String>(startDate);
    }
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<String>(endDate);
    }
    map['sync_status'] = Variable<int>(syncStatus);
    if (!nullToAbsent || syncUpdatedAt != null) {
      map['sync_updated_at'] = Variable<String>(syncUpdatedAt);
    }
    return map;
  }

  SitesCompanion toCompanion(bool nullToAbsent) {
    return SitesCompanion(
      id: Value(id),
      name: Value(name),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      noOfEmployees: Value(noOfEmployees),
      isActive: Value(isActive),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      syncStatus: Value(syncStatus),
      syncUpdatedAt: syncUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdatedAt),
    );
  }

  factory Site.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Site(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      location: serializer.fromJson<String?>(json['location']),
      noOfEmployees: serializer.fromJson<int>(json['noOfEmployees']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      startDate: serializer.fromJson<String?>(json['startDate']),
      endDate: serializer.fromJson<String?>(json['endDate']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      syncUpdatedAt: serializer.fromJson<String?>(json['syncUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'location': serializer.toJson<String?>(location),
      'noOfEmployees': serializer.toJson<int>(noOfEmployees),
      'isActive': serializer.toJson<bool>(isActive),
      'startDate': serializer.toJson<String?>(startDate),
      'endDate': serializer.toJson<String?>(endDate),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'syncUpdatedAt': serializer.toJson<String?>(syncUpdatedAt),
    };
  }

  Site copyWith({
    int? id,
    String? name,
    Value<String?> location = const Value.absent(),
    int? noOfEmployees,
    bool? isActive,
    Value<String?> startDate = const Value.absent(),
    Value<String?> endDate = const Value.absent(),
    int? syncStatus,
    Value<String?> syncUpdatedAt = const Value.absent(),
  }) => Site(
    id: id ?? this.id,
    name: name ?? this.name,
    location: location.present ? location.value : this.location,
    noOfEmployees: noOfEmployees ?? this.noOfEmployees,
    isActive: isActive ?? this.isActive,
    startDate: startDate.present ? startDate.value : this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    syncStatus: syncStatus ?? this.syncStatus,
    syncUpdatedAt: syncUpdatedAt.present
        ? syncUpdatedAt.value
        : this.syncUpdatedAt,
  );
  Site copyWithCompanion(SitesCompanion data) {
    return Site(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      location: data.location.present ? data.location.value : this.location,
      noOfEmployees: data.noOfEmployees.present
          ? data.noOfEmployees.value
          : this.noOfEmployees,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncUpdatedAt: data.syncUpdatedAt.present
          ? data.syncUpdatedAt.value
          : this.syncUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Site(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('location: $location, ')
          ..write('noOfEmployees: $noOfEmployees, ')
          ..write('isActive: $isActive, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    location,
    noOfEmployees,
    isActive,
    startDate,
    endDate,
    syncStatus,
    syncUpdatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Site &&
          other.id == this.id &&
          other.name == this.name &&
          other.location == this.location &&
          other.noOfEmployees == this.noOfEmployees &&
          other.isActive == this.isActive &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.syncStatus == this.syncStatus &&
          other.syncUpdatedAt == this.syncUpdatedAt);
}

class SitesCompanion extends UpdateCompanion<Site> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> location;
  final Value<int> noOfEmployees;
  final Value<bool> isActive;
  final Value<String?> startDate;
  final Value<String?> endDate;
  final Value<int> syncStatus;
  final Value<String?> syncUpdatedAt;
  const SitesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.location = const Value.absent(),
    this.noOfEmployees = const Value.absent(),
    this.isActive = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
  });
  SitesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.location = const Value.absent(),
    this.noOfEmployees = const Value.absent(),
    this.isActive = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Site> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? location,
    Expression<int>? noOfEmployees,
    Expression<bool>? isActive,
    Expression<String>? startDate,
    Expression<String>? endDate,
    Expression<int>? syncStatus,
    Expression<String>? syncUpdatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (location != null) 'location': location,
      if (noOfEmployees != null) 'no_of_employees': noOfEmployees,
      if (isActive != null) 'is_active': isActive,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncUpdatedAt != null) 'sync_updated_at': syncUpdatedAt,
    });
  }

  SitesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? location,
    Value<int>? noOfEmployees,
    Value<bool>? isActive,
    Value<String?>? startDate,
    Value<String?>? endDate,
    Value<int>? syncStatus,
    Value<String?>? syncUpdatedAt,
  }) {
    return SitesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      noOfEmployees: noOfEmployees ?? this.noOfEmployees,
      isActive: isActive ?? this.isActive,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      syncStatus: syncStatus ?? this.syncStatus,
      syncUpdatedAt: syncUpdatedAt ?? this.syncUpdatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (noOfEmployees.present) {
      map['no_of_employees'] = Variable<int>(noOfEmployees.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<String>(endDate.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (syncUpdatedAt.present) {
      map['sync_updated_at'] = Variable<String>(syncUpdatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SitesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('location: $location, ')
          ..write('noOfEmployees: $noOfEmployees, ')
          ..write('isActive: $isActive, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt')
          ..write(')'))
        .toString();
  }
}

class $DepartmentsTable extends Departments
    with TableInfo<$DepartmentsTable, Department> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DepartmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _companyIdMeta = const VerificationMeta(
    'companyId',
  );
  @override
  late final GeneratedColumn<int> companyId = GeneratedColumn<int>(
    'company_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sites (id)',
    ),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncUpdatedAtMeta = const VerificationMeta(
    'syncUpdatedAt',
  );
  @override
  late final GeneratedColumn<String> syncUpdatedAt = GeneratedColumn<String>(
    'sync_updated_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    companyId,
    syncStatus,
    syncUpdatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'departments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Department> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('company_id')) {
      context.handle(
        _companyIdMeta,
        companyId.isAcceptableOrUnknown(data['company_id']!, _companyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_companyIdMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('sync_updated_at')) {
      context.handle(
        _syncUpdatedAtMeta,
        syncUpdatedAt.isAcceptableOrUnknown(
          data['sync_updated_at']!,
          _syncUpdatedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Department map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Department(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      companyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}company_id'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
      syncUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_updated_at'],
      ),
    );
  }

  @override
  $DepartmentsTable createAlias(String alias) {
    return $DepartmentsTable(attachedDatabase, alias);
  }
}

class Department extends DataClass implements Insertable<Department> {
  final int id;
  final String name;
  final int companyId;
  final int syncStatus;
  final String? syncUpdatedAt;
  const Department({
    required this.id,
    required this.name,
    required this.companyId,
    required this.syncStatus,
    this.syncUpdatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['company_id'] = Variable<int>(companyId);
    map['sync_status'] = Variable<int>(syncStatus);
    if (!nullToAbsent || syncUpdatedAt != null) {
      map['sync_updated_at'] = Variable<String>(syncUpdatedAt);
    }
    return map;
  }

  DepartmentsCompanion toCompanion(bool nullToAbsent) {
    return DepartmentsCompanion(
      id: Value(id),
      name: Value(name),
      companyId: Value(companyId),
      syncStatus: Value(syncStatus),
      syncUpdatedAt: syncUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdatedAt),
    );
  }

  factory Department.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Department(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      companyId: serializer.fromJson<int>(json['companyId']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      syncUpdatedAt: serializer.fromJson<String?>(json['syncUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'companyId': serializer.toJson<int>(companyId),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'syncUpdatedAt': serializer.toJson<String?>(syncUpdatedAt),
    };
  }

  Department copyWith({
    int? id,
    String? name,
    int? companyId,
    int? syncStatus,
    Value<String?> syncUpdatedAt = const Value.absent(),
  }) => Department(
    id: id ?? this.id,
    name: name ?? this.name,
    companyId: companyId ?? this.companyId,
    syncStatus: syncStatus ?? this.syncStatus,
    syncUpdatedAt: syncUpdatedAt.present
        ? syncUpdatedAt.value
        : this.syncUpdatedAt,
  );
  Department copyWithCompanion(DepartmentsCompanion data) {
    return Department(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      companyId: data.companyId.present ? data.companyId.value : this.companyId,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncUpdatedAt: data.syncUpdatedAt.present
          ? data.syncUpdatedAt.value
          : this.syncUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Department(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('companyId: $companyId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, companyId, syncStatus, syncUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Department &&
          other.id == this.id &&
          other.name == this.name &&
          other.companyId == this.companyId &&
          other.syncStatus == this.syncStatus &&
          other.syncUpdatedAt == this.syncUpdatedAt);
}

class DepartmentsCompanion extends UpdateCompanion<Department> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> companyId;
  final Value<int> syncStatus;
  final Value<String?> syncUpdatedAt;
  const DepartmentsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.companyId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
  });
  DepartmentsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int companyId,
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
  }) : name = Value(name),
       companyId = Value(companyId);
  static Insertable<Department> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? companyId,
    Expression<int>? syncStatus,
    Expression<String>? syncUpdatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (companyId != null) 'company_id': companyId,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncUpdatedAt != null) 'sync_updated_at': syncUpdatedAt,
    });
  }

  DepartmentsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? companyId,
    Value<int>? syncStatus,
    Value<String?>? syncUpdatedAt,
  }) {
    return DepartmentsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      companyId: companyId ?? this.companyId,
      syncStatus: syncStatus ?? this.syncStatus,
      syncUpdatedAt: syncUpdatedAt ?? this.syncUpdatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (companyId.present) {
      map['company_id'] = Variable<int>(companyId.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (syncUpdatedAt.present) {
      map['sync_updated_at'] = Variable<String>(syncUpdatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DepartmentsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('companyId: $companyId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt')
          ..write(')'))
        .toString();
  }
}

class $ShiftsTable extends Shifts with TableInfo<$ShiftsTable, Shift> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShiftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hoursMeta = const VerificationMeta('hours');
  @override
  late final GeneratedColumn<int> hours = GeneratedColumn<int>(
    'hours',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _companyIdMeta = const VerificationMeta(
    'companyId',
  );
  @override
  late final GeneratedColumn<int> companyId = GeneratedColumn<int>(
    'company_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncUpdatedAtMeta = const VerificationMeta(
    'syncUpdatedAt',
  );
  @override
  late final GeneratedColumn<String> syncUpdatedAt = GeneratedColumn<String>(
    'sync_updated_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    hours,
    companyId,
    syncStatus,
    syncUpdatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shifts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Shift> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('hours')) {
      context.handle(
        _hoursMeta,
        hours.isAcceptableOrUnknown(data['hours']!, _hoursMeta),
      );
    } else if (isInserting) {
      context.missing(_hoursMeta);
    }
    if (data.containsKey('company_id')) {
      context.handle(
        _companyIdMeta,
        companyId.isAcceptableOrUnknown(data['company_id']!, _companyIdMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('sync_updated_at')) {
      context.handle(
        _syncUpdatedAtMeta,
        syncUpdatedAt.isAcceptableOrUnknown(
          data['sync_updated_at']!,
          _syncUpdatedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Shift map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Shift(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      hours: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hours'],
      )!,
      companyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}company_id'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
      syncUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_updated_at'],
      ),
    );
  }

  @override
  $ShiftsTable createAlias(String alias) {
    return $ShiftsTable(attachedDatabase, alias);
  }
}

class Shift extends DataClass implements Insertable<Shift> {
  final int id;
  final String name;
  final int hours;
  final int? companyId;
  final int syncStatus;
  final String? syncUpdatedAt;
  const Shift({
    required this.id,
    required this.name,
    required this.hours,
    this.companyId,
    required this.syncStatus,
    this.syncUpdatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['hours'] = Variable<int>(hours);
    if (!nullToAbsent || companyId != null) {
      map['company_id'] = Variable<int>(companyId);
    }
    map['sync_status'] = Variable<int>(syncStatus);
    if (!nullToAbsent || syncUpdatedAt != null) {
      map['sync_updated_at'] = Variable<String>(syncUpdatedAt);
    }
    return map;
  }

  ShiftsCompanion toCompanion(bool nullToAbsent) {
    return ShiftsCompanion(
      id: Value(id),
      name: Value(name),
      hours: Value(hours),
      companyId: companyId == null && nullToAbsent
          ? const Value.absent()
          : Value(companyId),
      syncStatus: Value(syncStatus),
      syncUpdatedAt: syncUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdatedAt),
    );
  }

  factory Shift.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Shift(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      hours: serializer.fromJson<int>(json['hours']),
      companyId: serializer.fromJson<int?>(json['companyId']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      syncUpdatedAt: serializer.fromJson<String?>(json['syncUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'hours': serializer.toJson<int>(hours),
      'companyId': serializer.toJson<int?>(companyId),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'syncUpdatedAt': serializer.toJson<String?>(syncUpdatedAt),
    };
  }

  Shift copyWith({
    int? id,
    String? name,
    int? hours,
    Value<int?> companyId = const Value.absent(),
    int? syncStatus,
    Value<String?> syncUpdatedAt = const Value.absent(),
  }) => Shift(
    id: id ?? this.id,
    name: name ?? this.name,
    hours: hours ?? this.hours,
    companyId: companyId.present ? companyId.value : this.companyId,
    syncStatus: syncStatus ?? this.syncStatus,
    syncUpdatedAt: syncUpdatedAt.present
        ? syncUpdatedAt.value
        : this.syncUpdatedAt,
  );
  Shift copyWithCompanion(ShiftsCompanion data) {
    return Shift(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      hours: data.hours.present ? data.hours.value : this.hours,
      companyId: data.companyId.present ? data.companyId.value : this.companyId,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncUpdatedAt: data.syncUpdatedAt.present
          ? data.syncUpdatedAt.value
          : this.syncUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Shift(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('hours: $hours, ')
          ..write('companyId: $companyId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, hours, companyId, syncStatus, syncUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Shift &&
          other.id == this.id &&
          other.name == this.name &&
          other.hours == this.hours &&
          other.companyId == this.companyId &&
          other.syncStatus == this.syncStatus &&
          other.syncUpdatedAt == this.syncUpdatedAt);
}

class ShiftsCompanion extends UpdateCompanion<Shift> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> hours;
  final Value<int?> companyId;
  final Value<int> syncStatus;
  final Value<String?> syncUpdatedAt;
  const ShiftsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.hours = const Value.absent(),
    this.companyId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
  });
  ShiftsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int hours,
    this.companyId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
  }) : name = Value(name),
       hours = Value(hours);
  static Insertable<Shift> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? hours,
    Expression<int>? companyId,
    Expression<int>? syncStatus,
    Expression<String>? syncUpdatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (hours != null) 'hours': hours,
      if (companyId != null) 'company_id': companyId,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncUpdatedAt != null) 'sync_updated_at': syncUpdatedAt,
    });
  }

  ShiftsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? hours,
    Value<int?>? companyId,
    Value<int>? syncStatus,
    Value<String?>? syncUpdatedAt,
  }) {
    return ShiftsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      hours: hours ?? this.hours,
      companyId: companyId ?? this.companyId,
      syncStatus: syncStatus ?? this.syncStatus,
      syncUpdatedAt: syncUpdatedAt ?? this.syncUpdatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (hours.present) {
      map['hours'] = Variable<int>(hours.value);
    }
    if (companyId.present) {
      map['company_id'] = Variable<int>(companyId.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (syncUpdatedAt.present) {
      map['sync_updated_at'] = Variable<String>(syncUpdatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShiftsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('hours: $hours, ')
          ..write('companyId: $companyId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt')
          ..write(')'))
        .toString();
  }
}

class $ShiftMealTypesTable extends ShiftMealTypes
    with TableInfo<$ShiftMealTypesTable, ShiftMealType> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShiftMealTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _shiftIdMeta = const VerificationMeta(
    'shiftId',
  );
  @override
  late final GeneratedColumn<int> shiftId = GeneratedColumn<int>(
    'shift_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mealTypeIdMeta = const VerificationMeta(
    'mealTypeId',
  );
  @override
  late final GeneratedColumn<int> mealTypeId = GeneratedColumn<int>(
    'meal_type_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [shiftId, mealTypeId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shift_meal_types';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShiftMealType> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('shift_id')) {
      context.handle(
        _shiftIdMeta,
        shiftId.isAcceptableOrUnknown(data['shift_id']!, _shiftIdMeta),
      );
    } else if (isInserting) {
      context.missing(_shiftIdMeta);
    }
    if (data.containsKey('meal_type_id')) {
      context.handle(
        _mealTypeIdMeta,
        mealTypeId.isAcceptableOrUnknown(
          data['meal_type_id']!,
          _mealTypeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_mealTypeIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {shiftId, mealTypeId};
  @override
  ShiftMealType map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShiftMealType(
      shiftId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shift_id'],
      )!,
      mealTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}meal_type_id'],
      )!,
    );
  }

  @override
  $ShiftMealTypesTable createAlias(String alias) {
    return $ShiftMealTypesTable(attachedDatabase, alias);
  }
}

class ShiftMealType extends DataClass implements Insertable<ShiftMealType> {
  final int shiftId;
  final int mealTypeId;
  const ShiftMealType({required this.shiftId, required this.mealTypeId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['shift_id'] = Variable<int>(shiftId);
    map['meal_type_id'] = Variable<int>(mealTypeId);
    return map;
  }

  ShiftMealTypesCompanion toCompanion(bool nullToAbsent) {
    return ShiftMealTypesCompanion(
      shiftId: Value(shiftId),
      mealTypeId: Value(mealTypeId),
    );
  }

  factory ShiftMealType.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShiftMealType(
      shiftId: serializer.fromJson<int>(json['shiftId']),
      mealTypeId: serializer.fromJson<int>(json['mealTypeId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'shiftId': serializer.toJson<int>(shiftId),
      'mealTypeId': serializer.toJson<int>(mealTypeId),
    };
  }

  ShiftMealType copyWith({int? shiftId, int? mealTypeId}) => ShiftMealType(
    shiftId: shiftId ?? this.shiftId,
    mealTypeId: mealTypeId ?? this.mealTypeId,
  );
  ShiftMealType copyWithCompanion(ShiftMealTypesCompanion data) {
    return ShiftMealType(
      shiftId: data.shiftId.present ? data.shiftId.value : this.shiftId,
      mealTypeId: data.mealTypeId.present
          ? data.mealTypeId.value
          : this.mealTypeId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShiftMealType(')
          ..write('shiftId: $shiftId, ')
          ..write('mealTypeId: $mealTypeId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(shiftId, mealTypeId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShiftMealType &&
          other.shiftId == this.shiftId &&
          other.mealTypeId == this.mealTypeId);
}

class ShiftMealTypesCompanion extends UpdateCompanion<ShiftMealType> {
  final Value<int> shiftId;
  final Value<int> mealTypeId;
  final Value<int> rowid;
  const ShiftMealTypesCompanion({
    this.shiftId = const Value.absent(),
    this.mealTypeId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShiftMealTypesCompanion.insert({
    required int shiftId,
    required int mealTypeId,
    this.rowid = const Value.absent(),
  }) : shiftId = Value(shiftId),
       mealTypeId = Value(mealTypeId);
  static Insertable<ShiftMealType> custom({
    Expression<int>? shiftId,
    Expression<int>? mealTypeId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (shiftId != null) 'shift_id': shiftId,
      if (mealTypeId != null) 'meal_type_id': mealTypeId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShiftMealTypesCompanion copyWith({
    Value<int>? shiftId,
    Value<int>? mealTypeId,
    Value<int>? rowid,
  }) {
    return ShiftMealTypesCompanion(
      shiftId: shiftId ?? this.shiftId,
      mealTypeId: mealTypeId ?? this.mealTypeId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (shiftId.present) {
      map['shift_id'] = Variable<int>(shiftId.value);
    }
    if (mealTypeId.present) {
      map['meal_type_id'] = Variable<int>(mealTypeId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShiftMealTypesCompanion(')
          ..write('shiftId: $shiftId, ')
          ..write('mealTypeId: $mealTypeId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $KitchensTable extends Kitchens with TableInfo<$KitchensTable, Kitchen> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KitchensTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minTierRequiredMeta = const VerificationMeta(
    'minTierRequired',
  );
  @override
  late final GeneratedColumn<int> minTierRequired = GeneratedColumn<int>(
    'min_tier_required',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _companyIdMeta = const VerificationMeta(
    'companyId',
  );
  @override
  late final GeneratedColumn<int> companyId = GeneratedColumn<int>(
    'company_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sites (id)',
    ),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncUpdatedAtMeta = const VerificationMeta(
    'syncUpdatedAt',
  );
  @override
  late final GeneratedColumn<String> syncUpdatedAt = GeneratedColumn<String>(
    'sync_updated_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    minTierRequired,
    status,
    companyId,
    syncStatus,
    syncUpdatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kitchens';
  @override
  VerificationContext validateIntegrity(
    Insertable<Kitchen> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('min_tier_required')) {
      context.handle(
        _minTierRequiredMeta,
        minTierRequired.isAcceptableOrUnknown(
          data['min_tier_required']!,
          _minTierRequiredMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_minTierRequiredMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('company_id')) {
      context.handle(
        _companyIdMeta,
        companyId.isAcceptableOrUnknown(data['company_id']!, _companyIdMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('sync_updated_at')) {
      context.handle(
        _syncUpdatedAtMeta,
        syncUpdatedAt.isAcceptableOrUnknown(
          data['sync_updated_at']!,
          _syncUpdatedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Kitchen map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Kitchen(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      minTierRequired: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_tier_required'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      companyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}company_id'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
      syncUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_updated_at'],
      ),
    );
  }

  @override
  $KitchensTable createAlias(String alias) {
    return $KitchensTable(attachedDatabase, alias);
  }
}

class Kitchen extends DataClass implements Insertable<Kitchen> {
  final int id;
  final String name;
  final int minTierRequired;
  final String status;
  final int? companyId;
  final int syncStatus;
  final String? syncUpdatedAt;
  const Kitchen({
    required this.id,
    required this.name,
    required this.minTierRequired,
    required this.status,
    this.companyId,
    required this.syncStatus,
    this.syncUpdatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['min_tier_required'] = Variable<int>(minTierRequired);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || companyId != null) {
      map['company_id'] = Variable<int>(companyId);
    }
    map['sync_status'] = Variable<int>(syncStatus);
    if (!nullToAbsent || syncUpdatedAt != null) {
      map['sync_updated_at'] = Variable<String>(syncUpdatedAt);
    }
    return map;
  }

  KitchensCompanion toCompanion(bool nullToAbsent) {
    return KitchensCompanion(
      id: Value(id),
      name: Value(name),
      minTierRequired: Value(minTierRequired),
      status: Value(status),
      companyId: companyId == null && nullToAbsent
          ? const Value.absent()
          : Value(companyId),
      syncStatus: Value(syncStatus),
      syncUpdatedAt: syncUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdatedAt),
    );
  }

  factory Kitchen.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Kitchen(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      minTierRequired: serializer.fromJson<int>(json['minTierRequired']),
      status: serializer.fromJson<String>(json['status']),
      companyId: serializer.fromJson<int?>(json['companyId']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      syncUpdatedAt: serializer.fromJson<String?>(json['syncUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'minTierRequired': serializer.toJson<int>(minTierRequired),
      'status': serializer.toJson<String>(status),
      'companyId': serializer.toJson<int?>(companyId),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'syncUpdatedAt': serializer.toJson<String?>(syncUpdatedAt),
    };
  }

  Kitchen copyWith({
    int? id,
    String? name,
    int? minTierRequired,
    String? status,
    Value<int?> companyId = const Value.absent(),
    int? syncStatus,
    Value<String?> syncUpdatedAt = const Value.absent(),
  }) => Kitchen(
    id: id ?? this.id,
    name: name ?? this.name,
    minTierRequired: minTierRequired ?? this.minTierRequired,
    status: status ?? this.status,
    companyId: companyId.present ? companyId.value : this.companyId,
    syncStatus: syncStatus ?? this.syncStatus,
    syncUpdatedAt: syncUpdatedAt.present
        ? syncUpdatedAt.value
        : this.syncUpdatedAt,
  );
  Kitchen copyWithCompanion(KitchensCompanion data) {
    return Kitchen(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      minTierRequired: data.minTierRequired.present
          ? data.minTierRequired.value
          : this.minTierRequired,
      status: data.status.present ? data.status.value : this.status,
      companyId: data.companyId.present ? data.companyId.value : this.companyId,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncUpdatedAt: data.syncUpdatedAt.present
          ? data.syncUpdatedAt.value
          : this.syncUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Kitchen(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('minTierRequired: $minTierRequired, ')
          ..write('status: $status, ')
          ..write('companyId: $companyId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    minTierRequired,
    status,
    companyId,
    syncStatus,
    syncUpdatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Kitchen &&
          other.id == this.id &&
          other.name == this.name &&
          other.minTierRequired == this.minTierRequired &&
          other.status == this.status &&
          other.companyId == this.companyId &&
          other.syncStatus == this.syncStatus &&
          other.syncUpdatedAt == this.syncUpdatedAt);
}

class KitchensCompanion extends UpdateCompanion<Kitchen> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> minTierRequired;
  final Value<String> status;
  final Value<int?> companyId;
  final Value<int> syncStatus;
  final Value<String?> syncUpdatedAt;
  const KitchensCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.minTierRequired = const Value.absent(),
    this.status = const Value.absent(),
    this.companyId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
  });
  KitchensCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int minTierRequired,
    required String status,
    this.companyId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
  }) : name = Value(name),
       minTierRequired = Value(minTierRequired),
       status = Value(status);
  static Insertable<Kitchen> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? minTierRequired,
    Expression<String>? status,
    Expression<int>? companyId,
    Expression<int>? syncStatus,
    Expression<String>? syncUpdatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (minTierRequired != null) 'min_tier_required': minTierRequired,
      if (status != null) 'status': status,
      if (companyId != null) 'company_id': companyId,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncUpdatedAt != null) 'sync_updated_at': syncUpdatedAt,
    });
  }

  KitchensCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? minTierRequired,
    Value<String>? status,
    Value<int?>? companyId,
    Value<int>? syncStatus,
    Value<String?>? syncUpdatedAt,
  }) {
    return KitchensCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      minTierRequired: minTierRequired ?? this.minTierRequired,
      status: status ?? this.status,
      companyId: companyId ?? this.companyId,
      syncStatus: syncStatus ?? this.syncStatus,
      syncUpdatedAt: syncUpdatedAt ?? this.syncUpdatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (minTierRequired.present) {
      map['min_tier_required'] = Variable<int>(minTierRequired.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (companyId.present) {
      map['company_id'] = Variable<int>(companyId.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (syncUpdatedAt.present) {
      map['sync_updated_at'] = Variable<String>(syncUpdatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KitchensCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('minTierRequired: $minTierRequired, ')
          ..write('status: $status, ')
          ..write('companyId: $companyId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt')
          ..write(')'))
        .toString();
  }
}

class $MenuTypesTable extends MenuTypes
    with TableInfo<$MenuTypesTable, MenuType> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MenuTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remarksMeta = const VerificationMeta(
    'remarks',
  );
  @override
  late final GeneratedColumn<String> remarks = GeneratedColumn<String>(
    'remarks',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncUpdatedAtMeta = const VerificationMeta(
    'syncUpdatedAt',
  );
  @override
  late final GeneratedColumn<String> syncUpdatedAt = GeneratedColumn<String>(
    'sync_updated_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    remarks,
    status,
    createdAt,
    updatedAt,
    syncStatus,
    syncUpdatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'menu_types';
  @override
  VerificationContext validateIntegrity(
    Insertable<MenuType> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('remarks')) {
      context.handle(
        _remarksMeta,
        remarks.isAcceptableOrUnknown(data['remarks']!, _remarksMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('sync_updated_at')) {
      context.handle(
        _syncUpdatedAtMeta,
        syncUpdatedAt.isAcceptableOrUnknown(
          data['sync_updated_at']!,
          _syncUpdatedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MenuType map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MenuType(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      remarks: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remarks'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
      syncUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_updated_at'],
      ),
    );
  }

  @override
  $MenuTypesTable createAlias(String alias) {
    return $MenuTypesTable(attachedDatabase, alias);
  }
}

class MenuType extends DataClass implements Insertable<MenuType> {
  final int id;
  final String name;
  final String? remarks;
  final String status;
  final String createdAt;
  final String updatedAt;
  final int syncStatus;
  final String? syncUpdatedAt;
  const MenuType({
    required this.id,
    required this.name,
    this.remarks,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    this.syncUpdatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || remarks != null) {
      map['remarks'] = Variable<String>(remarks);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    map['sync_status'] = Variable<int>(syncStatus);
    if (!nullToAbsent || syncUpdatedAt != null) {
      map['sync_updated_at'] = Variable<String>(syncUpdatedAt);
    }
    return map;
  }

  MenuTypesCompanion toCompanion(bool nullToAbsent) {
    return MenuTypesCompanion(
      id: Value(id),
      name: Value(name),
      remarks: remarks == null && nullToAbsent
          ? const Value.absent()
          : Value(remarks),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      syncUpdatedAt: syncUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdatedAt),
    );
  }

  factory MenuType.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MenuType(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      remarks: serializer.fromJson<String?>(json['remarks']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      syncUpdatedAt: serializer.fromJson<String?>(json['syncUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'remarks': serializer.toJson<String?>(remarks),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'syncUpdatedAt': serializer.toJson<String?>(syncUpdatedAt),
    };
  }

  MenuType copyWith({
    int? id,
    String? name,
    Value<String?> remarks = const Value.absent(),
    String? status,
    String? createdAt,
    String? updatedAt,
    int? syncStatus,
    Value<String?> syncUpdatedAt = const Value.absent(),
  }) => MenuType(
    id: id ?? this.id,
    name: name ?? this.name,
    remarks: remarks.present ? remarks.value : this.remarks,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    syncUpdatedAt: syncUpdatedAt.present
        ? syncUpdatedAt.value
        : this.syncUpdatedAt,
  );
  MenuType copyWithCompanion(MenuTypesCompanion data) {
    return MenuType(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      remarks: data.remarks.present ? data.remarks.value : this.remarks,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncUpdatedAt: data.syncUpdatedAt.present
          ? data.syncUpdatedAt.value
          : this.syncUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MenuType(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('remarks: $remarks, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    remarks,
    status,
    createdAt,
    updatedAt,
    syncStatus,
    syncUpdatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MenuType &&
          other.id == this.id &&
          other.name == this.name &&
          other.remarks == this.remarks &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.syncUpdatedAt == this.syncUpdatedAt);
}

class MenuTypesCompanion extends UpdateCompanion<MenuType> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> remarks;
  final Value<String> status;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> syncStatus;
  final Value<String?> syncUpdatedAt;
  const MenuTypesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.remarks = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
  });
  MenuTypesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.remarks = const Value.absent(),
    required String status,
    required String createdAt,
    required String updatedAt,
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
  }) : name = Value(name),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<MenuType> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? remarks,
    Expression<String>? status,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? syncStatus,
    Expression<String>? syncUpdatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (remarks != null) 'remarks': remarks,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncUpdatedAt != null) 'sync_updated_at': syncUpdatedAt,
    });
  }

  MenuTypesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? remarks,
    Value<String>? status,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? syncStatus,
    Value<String?>? syncUpdatedAt,
  }) {
    return MenuTypesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      remarks: remarks ?? this.remarks,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncUpdatedAt: syncUpdatedAt ?? this.syncUpdatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (remarks.present) {
      map['remarks'] = Variable<String>(remarks.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (syncUpdatedAt.present) {
      map['sync_updated_at'] = Variable<String>(syncUpdatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MenuTypesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('remarks: $remarks, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt')
          ..write(')'))
        .toString();
  }
}

class $MealTypesTable extends MealTypes
    with TableInfo<$MealTypesTable, MealType> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _beginTimeMeta = const VerificationMeta(
    'beginTime',
  );
  @override
  late final GeneratedColumn<String> beginTime = GeneratedColumn<String>(
    'begin_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<String> endTime = GeneratedColumn<String>(
    'end_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _remarksMeta = const VerificationMeta(
    'remarks',
  );
  @override
  late final GeneratedColumn<String> remarks = GeneratedColumn<String>(
    'remarks',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncUpdatedAtMeta = const VerificationMeta(
    'syncUpdatedAt',
  );
  @override
  late final GeneratedColumn<String> syncUpdatedAt = GeneratedColumn<String>(
    'sync_updated_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    status,
    beginTime,
    endTime,
    price,
    remarks,
    createdAt,
    updatedAt,
    syncStatus,
    syncUpdatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_types';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealType> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('begin_time')) {
      context.handle(
        _beginTimeMeta,
        beginTime.isAcceptableOrUnknown(data['begin_time']!, _beginTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_beginTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    }
    if (data.containsKey('remarks')) {
      context.handle(
        _remarksMeta,
        remarks.isAcceptableOrUnknown(data['remarks']!, _remarksMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('sync_updated_at')) {
      context.handle(
        _syncUpdatedAtMeta,
        syncUpdatedAt.isAcceptableOrUnknown(
          data['sync_updated_at']!,
          _syncUpdatedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealType map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealType(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      beginTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}begin_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_time'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      remarks: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remarks'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
      syncUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_updated_at'],
      ),
    );
  }

  @override
  $MealTypesTable createAlias(String alias) {
    return $MealTypesTable(attachedDatabase, alias);
  }
}

class MealType extends DataClass implements Insertable<MealType> {
  final int id;
  final String name;
  final String status;
  final String beginTime;
  final String endTime;
  final double price;
  final String? remarks;
  final String createdAt;
  final String updatedAt;
  final int syncStatus;
  final String? syncUpdatedAt;
  const MealType({
    required this.id,
    required this.name,
    required this.status,
    required this.beginTime,
    required this.endTime,
    required this.price,
    this.remarks,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    this.syncUpdatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['status'] = Variable<String>(status);
    map['begin_time'] = Variable<String>(beginTime);
    map['end_time'] = Variable<String>(endTime);
    map['price'] = Variable<double>(price);
    if (!nullToAbsent || remarks != null) {
      map['remarks'] = Variable<String>(remarks);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    map['sync_status'] = Variable<int>(syncStatus);
    if (!nullToAbsent || syncUpdatedAt != null) {
      map['sync_updated_at'] = Variable<String>(syncUpdatedAt);
    }
    return map;
  }

  MealTypesCompanion toCompanion(bool nullToAbsent) {
    return MealTypesCompanion(
      id: Value(id),
      name: Value(name),
      status: Value(status),
      beginTime: Value(beginTime),
      endTime: Value(endTime),
      price: Value(price),
      remarks: remarks == null && nullToAbsent
          ? const Value.absent()
          : Value(remarks),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      syncUpdatedAt: syncUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdatedAt),
    );
  }

  factory MealType.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealType(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      status: serializer.fromJson<String>(json['status']),
      beginTime: serializer.fromJson<String>(json['beginTime']),
      endTime: serializer.fromJson<String>(json['endTime']),
      price: serializer.fromJson<double>(json['price']),
      remarks: serializer.fromJson<String?>(json['remarks']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      syncUpdatedAt: serializer.fromJson<String?>(json['syncUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'status': serializer.toJson<String>(status),
      'beginTime': serializer.toJson<String>(beginTime),
      'endTime': serializer.toJson<String>(endTime),
      'price': serializer.toJson<double>(price),
      'remarks': serializer.toJson<String?>(remarks),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'syncUpdatedAt': serializer.toJson<String?>(syncUpdatedAt),
    };
  }

  MealType copyWith({
    int? id,
    String? name,
    String? status,
    String? beginTime,
    String? endTime,
    double? price,
    Value<String?> remarks = const Value.absent(),
    String? createdAt,
    String? updatedAt,
    int? syncStatus,
    Value<String?> syncUpdatedAt = const Value.absent(),
  }) => MealType(
    id: id ?? this.id,
    name: name ?? this.name,
    status: status ?? this.status,
    beginTime: beginTime ?? this.beginTime,
    endTime: endTime ?? this.endTime,
    price: price ?? this.price,
    remarks: remarks.present ? remarks.value : this.remarks,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    syncUpdatedAt: syncUpdatedAt.present
        ? syncUpdatedAt.value
        : this.syncUpdatedAt,
  );
  MealType copyWithCompanion(MealTypesCompanion data) {
    return MealType(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      status: data.status.present ? data.status.value : this.status,
      beginTime: data.beginTime.present ? data.beginTime.value : this.beginTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      price: data.price.present ? data.price.value : this.price,
      remarks: data.remarks.present ? data.remarks.value : this.remarks,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncUpdatedAt: data.syncUpdatedAt.present
          ? data.syncUpdatedAt.value
          : this.syncUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealType(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('status: $status, ')
          ..write('beginTime: $beginTime, ')
          ..write('endTime: $endTime, ')
          ..write('price: $price, ')
          ..write('remarks: $remarks, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    status,
    beginTime,
    endTime,
    price,
    remarks,
    createdAt,
    updatedAt,
    syncStatus,
    syncUpdatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealType &&
          other.id == this.id &&
          other.name == this.name &&
          other.status == this.status &&
          other.beginTime == this.beginTime &&
          other.endTime == this.endTime &&
          other.price == this.price &&
          other.remarks == this.remarks &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.syncUpdatedAt == this.syncUpdatedAt);
}

class MealTypesCompanion extends UpdateCompanion<MealType> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> status;
  final Value<String> beginTime;
  final Value<String> endTime;
  final Value<double> price;
  final Value<String?> remarks;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> syncStatus;
  final Value<String?> syncUpdatedAt;
  const MealTypesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.status = const Value.absent(),
    this.beginTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.price = const Value.absent(),
    this.remarks = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
  });
  MealTypesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String status,
    required String beginTime,
    required String endTime,
    this.price = const Value.absent(),
    this.remarks = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
  }) : name = Value(name),
       status = Value(status),
       beginTime = Value(beginTime),
       endTime = Value(endTime),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<MealType> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? status,
    Expression<String>? beginTime,
    Expression<String>? endTime,
    Expression<double>? price,
    Expression<String>? remarks,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? syncStatus,
    Expression<String>? syncUpdatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (status != null) 'status': status,
      if (beginTime != null) 'begin_time': beginTime,
      if (endTime != null) 'end_time': endTime,
      if (price != null) 'price': price,
      if (remarks != null) 'remarks': remarks,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncUpdatedAt != null) 'sync_updated_at': syncUpdatedAt,
    });
  }

  MealTypesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? status,
    Value<String>? beginTime,
    Value<String>? endTime,
    Value<double>? price,
    Value<String?>? remarks,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? syncStatus,
    Value<String?>? syncUpdatedAt,
  }) {
    return MealTypesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      beginTime: beginTime ?? this.beginTime,
      endTime: endTime ?? this.endTime,
      price: price ?? this.price,
      remarks: remarks ?? this.remarks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncUpdatedAt: syncUpdatedAt ?? this.syncUpdatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (beginTime.present) {
      map['begin_time'] = Variable<String>(beginTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<String>(endTime.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (remarks.present) {
      map['remarks'] = Variable<String>(remarks.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (syncUpdatedAt.present) {
      map['sync_updated_at'] = Variable<String>(syncUpdatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealTypesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('status: $status, ')
          ..write('beginTime: $beginTime, ')
          ..write('endTime: $endTime, ')
          ..write('price: $price, ')
          ..write('remarks: $remarks, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt')
          ..write(')'))
        .toString();
  }
}

class $StaffTable extends Staff with TableInfo<$StaffTable, StaffData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StaffTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _empIdMeta = const VerificationMeta('empId');
  @override
  late final GeneratedColumn<String> empId = GeneratedColumn<String>(
    'emp_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _companyIdMeta = const VerificationMeta(
    'companyId',
  );
  @override
  late final GeneratedColumn<int> companyId = GeneratedColumn<int>(
    'company_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _jobTitleMeta = const VerificationMeta(
    'jobTitle',
  );
  @override
  late final GeneratedColumn<String> jobTitle = GeneratedColumn<String>(
    'job_title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _empStatusMeta = const VerificationMeta(
    'empStatus',
  );
  @override
  late final GeneratedColumn<String> empStatus = GeneratedColumn<String>(
    'emp_status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _employeeTypeMeta = const VerificationMeta(
    'employeeType',
  );
  @override
  late final GeneratedColumn<String> employeeType = GeneratedColumn<String>(
    'employee_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<String> startDate = GeneratedColumn<String>(
    'start_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<String> endDate = GeneratedColumn<String>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _allowGroupOrderMeta = const VerificationMeta(
    'allowGroupOrder',
  );
  @override
  late final GeneratedColumn<bool> allowGroupOrder = GeneratedColumn<bool>(
    'allow_group_order',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("allow_group_order" IN (0, 1))',
    ),
  );
  static const VerificationMeta _maxOrderCountMeta = const VerificationMeta(
    'maxOrderCount',
  );
  @override
  late final GeneratedColumn<int> maxOrderCount = GeneratedColumn<int>(
    'max_order_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _shiftIdMeta = const VerificationMeta(
    'shiftId',
  );
  @override
  late final GeneratedColumn<int> shiftId = GeneratedColumn<int>(
    'shift_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalDependentMeta = const VerificationMeta(
    'totalDependent',
  );
  @override
  late final GeneratedColumn<int> totalDependent = GeneratedColumn<int>(
    'total_dependent',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noOfDependentAssignedMeta =
      const VerificationMeta('noOfDependentAssigned');
  @override
  late final GeneratedColumn<int> noOfDependentAssigned = GeneratedColumn<int>(
    'no_of_dependent_assigned',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _departmentIdMeta = const VerificationMeta(
    'departmentId',
  );
  @override
  late final GeneratedColumn<int> departmentId = GeneratedColumn<int>(
    'department_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncUpdatedAtMeta = const VerificationMeta(
    'syncUpdatedAt',
  );
  @override
  late final GeneratedColumn<String> syncUpdatedAt = GeneratedColumn<String>(
    'sync_updated_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    empId,
    firstName,
    lastName,
    companyId,
    jobTitle,
    empStatus,
    employeeType,
    startDate,
    endDate,
    allowGroupOrder,
    maxOrderCount,
    shiftId,
    totalDependent,
    noOfDependentAssigned,
    departmentId,
    syncStatus,
    syncUpdatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'staff';
  @override
  VerificationContext validateIntegrity(
    Insertable<StaffData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('emp_id')) {
      context.handle(
        _empIdMeta,
        empId.isAcceptableOrUnknown(data['emp_id']!, _empIdMeta),
      );
    } else if (isInserting) {
      context.missing(_empIdMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('company_id')) {
      context.handle(
        _companyIdMeta,
        companyId.isAcceptableOrUnknown(data['company_id']!, _companyIdMeta),
      );
    }
    if (data.containsKey('job_title')) {
      context.handle(
        _jobTitleMeta,
        jobTitle.isAcceptableOrUnknown(data['job_title']!, _jobTitleMeta),
      );
    }
    if (data.containsKey('emp_status')) {
      context.handle(
        _empStatusMeta,
        empStatus.isAcceptableOrUnknown(data['emp_status']!, _empStatusMeta),
      );
    }
    if (data.containsKey('employee_type')) {
      context.handle(
        _employeeTypeMeta,
        employeeType.isAcceptableOrUnknown(
          data['employee_type']!,
          _employeeTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_employeeTypeMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('allow_group_order')) {
      context.handle(
        _allowGroupOrderMeta,
        allowGroupOrder.isAcceptableOrUnknown(
          data['allow_group_order']!,
          _allowGroupOrderMeta,
        ),
      );
    }
    if (data.containsKey('max_order_count')) {
      context.handle(
        _maxOrderCountMeta,
        maxOrderCount.isAcceptableOrUnknown(
          data['max_order_count']!,
          _maxOrderCountMeta,
        ),
      );
    }
    if (data.containsKey('shift_id')) {
      context.handle(
        _shiftIdMeta,
        shiftId.isAcceptableOrUnknown(data['shift_id']!, _shiftIdMeta),
      );
    }
    if (data.containsKey('total_dependent')) {
      context.handle(
        _totalDependentMeta,
        totalDependent.isAcceptableOrUnknown(
          data['total_dependent']!,
          _totalDependentMeta,
        ),
      );
    }
    if (data.containsKey('no_of_dependent_assigned')) {
      context.handle(
        _noOfDependentAssignedMeta,
        noOfDependentAssigned.isAcceptableOrUnknown(
          data['no_of_dependent_assigned']!,
          _noOfDependentAssignedMeta,
        ),
      );
    }
    if (data.containsKey('department_id')) {
      context.handle(
        _departmentIdMeta,
        departmentId.isAcceptableOrUnknown(
          data['department_id']!,
          _departmentIdMeta,
        ),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('sync_updated_at')) {
      context.handle(
        _syncUpdatedAtMeta,
        syncUpdatedAt.isAcceptableOrUnknown(
          data['sync_updated_at']!,
          _syncUpdatedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StaffData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StaffData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      empId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emp_id'],
      )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      )!,
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      )!,
      companyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}company_id'],
      ),
      jobTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}job_title'],
      ),
      empStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emp_status'],
      ),
      employeeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}employee_type'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_date'],
      ),
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_date'],
      ),
      allowGroupOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}allow_group_order'],
      ),
      maxOrderCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_order_count'],
      ),
      shiftId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shift_id'],
      ),
      totalDependent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_dependent'],
      ),
      noOfDependentAssigned: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}no_of_dependent_assigned'],
      ),
      departmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}department_id'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
      syncUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_updated_at'],
      ),
    );
  }

  @override
  $StaffTable createAlias(String alias) {
    return $StaffTable(attachedDatabase, alias);
  }
}

class StaffData extends DataClass implements Insertable<StaffData> {
  final int id;
  final String empId;
  final String firstName;
  final String lastName;
  final int? companyId;
  final String? jobTitle;
  final String? empStatus;
  final String employeeType;
  final String? startDate;
  final String? endDate;
  final bool? allowGroupOrder;
  final int? maxOrderCount;
  final int? shiftId;
  final int? totalDependent;
  final int? noOfDependentAssigned;
  final int? departmentId;
  final int syncStatus;
  final String? syncUpdatedAt;
  const StaffData({
    required this.id,
    required this.empId,
    required this.firstName,
    required this.lastName,
    this.companyId,
    this.jobTitle,
    this.empStatus,
    required this.employeeType,
    this.startDate,
    this.endDate,
    this.allowGroupOrder,
    this.maxOrderCount,
    this.shiftId,
    this.totalDependent,
    this.noOfDependentAssigned,
    this.departmentId,
    required this.syncStatus,
    this.syncUpdatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['emp_id'] = Variable<String>(empId);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    if (!nullToAbsent || companyId != null) {
      map['company_id'] = Variable<int>(companyId);
    }
    if (!nullToAbsent || jobTitle != null) {
      map['job_title'] = Variable<String>(jobTitle);
    }
    if (!nullToAbsent || empStatus != null) {
      map['emp_status'] = Variable<String>(empStatus);
    }
    map['employee_type'] = Variable<String>(employeeType);
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<String>(startDate);
    }
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<String>(endDate);
    }
    if (!nullToAbsent || allowGroupOrder != null) {
      map['allow_group_order'] = Variable<bool>(allowGroupOrder);
    }
    if (!nullToAbsent || maxOrderCount != null) {
      map['max_order_count'] = Variable<int>(maxOrderCount);
    }
    if (!nullToAbsent || shiftId != null) {
      map['shift_id'] = Variable<int>(shiftId);
    }
    if (!nullToAbsent || totalDependent != null) {
      map['total_dependent'] = Variable<int>(totalDependent);
    }
    if (!nullToAbsent || noOfDependentAssigned != null) {
      map['no_of_dependent_assigned'] = Variable<int>(noOfDependentAssigned);
    }
    if (!nullToAbsent || departmentId != null) {
      map['department_id'] = Variable<int>(departmentId);
    }
    map['sync_status'] = Variable<int>(syncStatus);
    if (!nullToAbsent || syncUpdatedAt != null) {
      map['sync_updated_at'] = Variable<String>(syncUpdatedAt);
    }
    return map;
  }

  StaffCompanion toCompanion(bool nullToAbsent) {
    return StaffCompanion(
      id: Value(id),
      empId: Value(empId),
      firstName: Value(firstName),
      lastName: Value(lastName),
      companyId: companyId == null && nullToAbsent
          ? const Value.absent()
          : Value(companyId),
      jobTitle: jobTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(jobTitle),
      empStatus: empStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(empStatus),
      employeeType: Value(employeeType),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      allowGroupOrder: allowGroupOrder == null && nullToAbsent
          ? const Value.absent()
          : Value(allowGroupOrder),
      maxOrderCount: maxOrderCount == null && nullToAbsent
          ? const Value.absent()
          : Value(maxOrderCount),
      shiftId: shiftId == null && nullToAbsent
          ? const Value.absent()
          : Value(shiftId),
      totalDependent: totalDependent == null && nullToAbsent
          ? const Value.absent()
          : Value(totalDependent),
      noOfDependentAssigned: noOfDependentAssigned == null && nullToAbsent
          ? const Value.absent()
          : Value(noOfDependentAssigned),
      departmentId: departmentId == null && nullToAbsent
          ? const Value.absent()
          : Value(departmentId),
      syncStatus: Value(syncStatus),
      syncUpdatedAt: syncUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdatedAt),
    );
  }

  factory StaffData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StaffData(
      id: serializer.fromJson<int>(json['id']),
      empId: serializer.fromJson<String>(json['empId']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      companyId: serializer.fromJson<int?>(json['companyId']),
      jobTitle: serializer.fromJson<String?>(json['jobTitle']),
      empStatus: serializer.fromJson<String?>(json['empStatus']),
      employeeType: serializer.fromJson<String>(json['employeeType']),
      startDate: serializer.fromJson<String?>(json['startDate']),
      endDate: serializer.fromJson<String?>(json['endDate']),
      allowGroupOrder: serializer.fromJson<bool?>(json['allowGroupOrder']),
      maxOrderCount: serializer.fromJson<int?>(json['maxOrderCount']),
      shiftId: serializer.fromJson<int?>(json['shiftId']),
      totalDependent: serializer.fromJson<int?>(json['totalDependent']),
      noOfDependentAssigned: serializer.fromJson<int?>(
        json['noOfDependentAssigned'],
      ),
      departmentId: serializer.fromJson<int?>(json['departmentId']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      syncUpdatedAt: serializer.fromJson<String?>(json['syncUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'empId': serializer.toJson<String>(empId),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'companyId': serializer.toJson<int?>(companyId),
      'jobTitle': serializer.toJson<String?>(jobTitle),
      'empStatus': serializer.toJson<String?>(empStatus),
      'employeeType': serializer.toJson<String>(employeeType),
      'startDate': serializer.toJson<String?>(startDate),
      'endDate': serializer.toJson<String?>(endDate),
      'allowGroupOrder': serializer.toJson<bool?>(allowGroupOrder),
      'maxOrderCount': serializer.toJson<int?>(maxOrderCount),
      'shiftId': serializer.toJson<int?>(shiftId),
      'totalDependent': serializer.toJson<int?>(totalDependent),
      'noOfDependentAssigned': serializer.toJson<int?>(noOfDependentAssigned),
      'departmentId': serializer.toJson<int?>(departmentId),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'syncUpdatedAt': serializer.toJson<String?>(syncUpdatedAt),
    };
  }

  StaffData copyWith({
    int? id,
    String? empId,
    String? firstName,
    String? lastName,
    Value<int?> companyId = const Value.absent(),
    Value<String?> jobTitle = const Value.absent(),
    Value<String?> empStatus = const Value.absent(),
    String? employeeType,
    Value<String?> startDate = const Value.absent(),
    Value<String?> endDate = const Value.absent(),
    Value<bool?> allowGroupOrder = const Value.absent(),
    Value<int?> maxOrderCount = const Value.absent(),
    Value<int?> shiftId = const Value.absent(),
    Value<int?> totalDependent = const Value.absent(),
    Value<int?> noOfDependentAssigned = const Value.absent(),
    Value<int?> departmentId = const Value.absent(),
    int? syncStatus,
    Value<String?> syncUpdatedAt = const Value.absent(),
  }) => StaffData(
    id: id ?? this.id,
    empId: empId ?? this.empId,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    companyId: companyId.present ? companyId.value : this.companyId,
    jobTitle: jobTitle.present ? jobTitle.value : this.jobTitle,
    empStatus: empStatus.present ? empStatus.value : this.empStatus,
    employeeType: employeeType ?? this.employeeType,
    startDate: startDate.present ? startDate.value : this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    allowGroupOrder: allowGroupOrder.present
        ? allowGroupOrder.value
        : this.allowGroupOrder,
    maxOrderCount: maxOrderCount.present
        ? maxOrderCount.value
        : this.maxOrderCount,
    shiftId: shiftId.present ? shiftId.value : this.shiftId,
    totalDependent: totalDependent.present
        ? totalDependent.value
        : this.totalDependent,
    noOfDependentAssigned: noOfDependentAssigned.present
        ? noOfDependentAssigned.value
        : this.noOfDependentAssigned,
    departmentId: departmentId.present ? departmentId.value : this.departmentId,
    syncStatus: syncStatus ?? this.syncStatus,
    syncUpdatedAt: syncUpdatedAt.present
        ? syncUpdatedAt.value
        : this.syncUpdatedAt,
  );
  StaffData copyWithCompanion(StaffCompanion data) {
    return StaffData(
      id: data.id.present ? data.id.value : this.id,
      empId: data.empId.present ? data.empId.value : this.empId,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      companyId: data.companyId.present ? data.companyId.value : this.companyId,
      jobTitle: data.jobTitle.present ? data.jobTitle.value : this.jobTitle,
      empStatus: data.empStatus.present ? data.empStatus.value : this.empStatus,
      employeeType: data.employeeType.present
          ? data.employeeType.value
          : this.employeeType,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      allowGroupOrder: data.allowGroupOrder.present
          ? data.allowGroupOrder.value
          : this.allowGroupOrder,
      maxOrderCount: data.maxOrderCount.present
          ? data.maxOrderCount.value
          : this.maxOrderCount,
      shiftId: data.shiftId.present ? data.shiftId.value : this.shiftId,
      totalDependent: data.totalDependent.present
          ? data.totalDependent.value
          : this.totalDependent,
      noOfDependentAssigned: data.noOfDependentAssigned.present
          ? data.noOfDependentAssigned.value
          : this.noOfDependentAssigned,
      departmentId: data.departmentId.present
          ? data.departmentId.value
          : this.departmentId,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncUpdatedAt: data.syncUpdatedAt.present
          ? data.syncUpdatedAt.value
          : this.syncUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StaffData(')
          ..write('id: $id, ')
          ..write('empId: $empId, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('companyId: $companyId, ')
          ..write('jobTitle: $jobTitle, ')
          ..write('empStatus: $empStatus, ')
          ..write('employeeType: $employeeType, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('allowGroupOrder: $allowGroupOrder, ')
          ..write('maxOrderCount: $maxOrderCount, ')
          ..write('shiftId: $shiftId, ')
          ..write('totalDependent: $totalDependent, ')
          ..write('noOfDependentAssigned: $noOfDependentAssigned, ')
          ..write('departmentId: $departmentId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    empId,
    firstName,
    lastName,
    companyId,
    jobTitle,
    empStatus,
    employeeType,
    startDate,
    endDate,
    allowGroupOrder,
    maxOrderCount,
    shiftId,
    totalDependent,
    noOfDependentAssigned,
    departmentId,
    syncStatus,
    syncUpdatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StaffData &&
          other.id == this.id &&
          other.empId == this.empId &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.companyId == this.companyId &&
          other.jobTitle == this.jobTitle &&
          other.empStatus == this.empStatus &&
          other.employeeType == this.employeeType &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.allowGroupOrder == this.allowGroupOrder &&
          other.maxOrderCount == this.maxOrderCount &&
          other.shiftId == this.shiftId &&
          other.totalDependent == this.totalDependent &&
          other.noOfDependentAssigned == this.noOfDependentAssigned &&
          other.departmentId == this.departmentId &&
          other.syncStatus == this.syncStatus &&
          other.syncUpdatedAt == this.syncUpdatedAt);
}

class StaffCompanion extends UpdateCompanion<StaffData> {
  final Value<int> id;
  final Value<String> empId;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<int?> companyId;
  final Value<String?> jobTitle;
  final Value<String?> empStatus;
  final Value<String> employeeType;
  final Value<String?> startDate;
  final Value<String?> endDate;
  final Value<bool?> allowGroupOrder;
  final Value<int?> maxOrderCount;
  final Value<int?> shiftId;
  final Value<int?> totalDependent;
  final Value<int?> noOfDependentAssigned;
  final Value<int?> departmentId;
  final Value<int> syncStatus;
  final Value<String?> syncUpdatedAt;
  const StaffCompanion({
    this.id = const Value.absent(),
    this.empId = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.companyId = const Value.absent(),
    this.jobTitle = const Value.absent(),
    this.empStatus = const Value.absent(),
    this.employeeType = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.allowGroupOrder = const Value.absent(),
    this.maxOrderCount = const Value.absent(),
    this.shiftId = const Value.absent(),
    this.totalDependent = const Value.absent(),
    this.noOfDependentAssigned = const Value.absent(),
    this.departmentId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
  });
  StaffCompanion.insert({
    this.id = const Value.absent(),
    required String empId,
    required String firstName,
    required String lastName,
    this.companyId = const Value.absent(),
    this.jobTitle = const Value.absent(),
    this.empStatus = const Value.absent(),
    required String employeeType,
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.allowGroupOrder = const Value.absent(),
    this.maxOrderCount = const Value.absent(),
    this.shiftId = const Value.absent(),
    this.totalDependent = const Value.absent(),
    this.noOfDependentAssigned = const Value.absent(),
    this.departmentId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
  }) : empId = Value(empId),
       firstName = Value(firstName),
       lastName = Value(lastName),
       employeeType = Value(employeeType);
  static Insertable<StaffData> custom({
    Expression<int>? id,
    Expression<String>? empId,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<int>? companyId,
    Expression<String>? jobTitle,
    Expression<String>? empStatus,
    Expression<String>? employeeType,
    Expression<String>? startDate,
    Expression<String>? endDate,
    Expression<bool>? allowGroupOrder,
    Expression<int>? maxOrderCount,
    Expression<int>? shiftId,
    Expression<int>? totalDependent,
    Expression<int>? noOfDependentAssigned,
    Expression<int>? departmentId,
    Expression<int>? syncStatus,
    Expression<String>? syncUpdatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (empId != null) 'emp_id': empId,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (companyId != null) 'company_id': companyId,
      if (jobTitle != null) 'job_title': jobTitle,
      if (empStatus != null) 'emp_status': empStatus,
      if (employeeType != null) 'employee_type': employeeType,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (allowGroupOrder != null) 'allow_group_order': allowGroupOrder,
      if (maxOrderCount != null) 'max_order_count': maxOrderCount,
      if (shiftId != null) 'shift_id': shiftId,
      if (totalDependent != null) 'total_dependent': totalDependent,
      if (noOfDependentAssigned != null)
        'no_of_dependent_assigned': noOfDependentAssigned,
      if (departmentId != null) 'department_id': departmentId,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncUpdatedAt != null) 'sync_updated_at': syncUpdatedAt,
    });
  }

  StaffCompanion copyWith({
    Value<int>? id,
    Value<String>? empId,
    Value<String>? firstName,
    Value<String>? lastName,
    Value<int?>? companyId,
    Value<String?>? jobTitle,
    Value<String?>? empStatus,
    Value<String>? employeeType,
    Value<String?>? startDate,
    Value<String?>? endDate,
    Value<bool?>? allowGroupOrder,
    Value<int?>? maxOrderCount,
    Value<int?>? shiftId,
    Value<int?>? totalDependent,
    Value<int?>? noOfDependentAssigned,
    Value<int?>? departmentId,
    Value<int>? syncStatus,
    Value<String?>? syncUpdatedAt,
  }) {
    return StaffCompanion(
      id: id ?? this.id,
      empId: empId ?? this.empId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      companyId: companyId ?? this.companyId,
      jobTitle: jobTitle ?? this.jobTitle,
      empStatus: empStatus ?? this.empStatus,
      employeeType: employeeType ?? this.employeeType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      allowGroupOrder: allowGroupOrder ?? this.allowGroupOrder,
      maxOrderCount: maxOrderCount ?? this.maxOrderCount,
      shiftId: shiftId ?? this.shiftId,
      totalDependent: totalDependent ?? this.totalDependent,
      noOfDependentAssigned:
          noOfDependentAssigned ?? this.noOfDependentAssigned,
      departmentId: departmentId ?? this.departmentId,
      syncStatus: syncStatus ?? this.syncStatus,
      syncUpdatedAt: syncUpdatedAt ?? this.syncUpdatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (empId.present) {
      map['emp_id'] = Variable<String>(empId.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (companyId.present) {
      map['company_id'] = Variable<int>(companyId.value);
    }
    if (jobTitle.present) {
      map['job_title'] = Variable<String>(jobTitle.value);
    }
    if (empStatus.present) {
      map['emp_status'] = Variable<String>(empStatus.value);
    }
    if (employeeType.present) {
      map['employee_type'] = Variable<String>(employeeType.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<String>(endDate.value);
    }
    if (allowGroupOrder.present) {
      map['allow_group_order'] = Variable<bool>(allowGroupOrder.value);
    }
    if (maxOrderCount.present) {
      map['max_order_count'] = Variable<int>(maxOrderCount.value);
    }
    if (shiftId.present) {
      map['shift_id'] = Variable<int>(shiftId.value);
    }
    if (totalDependent.present) {
      map['total_dependent'] = Variable<int>(totalDependent.value);
    }
    if (noOfDependentAssigned.present) {
      map['no_of_dependent_assigned'] = Variable<int>(
        noOfDependentAssigned.value,
      );
    }
    if (departmentId.present) {
      map['department_id'] = Variable<int>(departmentId.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (syncUpdatedAt.present) {
      map['sync_updated_at'] = Variable<String>(syncUpdatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StaffCompanion(')
          ..write('id: $id, ')
          ..write('empId: $empId, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('companyId: $companyId, ')
          ..write('jobTitle: $jobTitle, ')
          ..write('empStatus: $empStatus, ')
          ..write('employeeType: $employeeType, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('allowGroupOrder: $allowGroupOrder, ')
          ..write('maxOrderCount: $maxOrderCount, ')
          ..write('shiftId: $shiftId, ')
          ..write('totalDependent: $totalDependent, ')
          ..write('noOfDependentAssigned: $noOfDependentAssigned, ')
          ..write('departmentId: $departmentId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt')
          ..write(')'))
        .toString();
  }
}

class $StaffKitchensTable extends StaffKitchens
    with TableInfo<$StaffKitchensTable, StaffKitchen> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StaffKitchensTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _staffIdMeta = const VerificationMeta(
    'staffId',
  );
  @override
  late final GeneratedColumn<int> staffId = GeneratedColumn<int>(
    'staff_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kitchenIdMeta = const VerificationMeta(
    'kitchenId',
  );
  @override
  late final GeneratedColumn<int> kitchenId = GeneratedColumn<int>(
    'kitchen_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [staffId, kitchenId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'staff_kitchens';
  @override
  VerificationContext validateIntegrity(
    Insertable<StaffKitchen> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('staff_id')) {
      context.handle(
        _staffIdMeta,
        staffId.isAcceptableOrUnknown(data['staff_id']!, _staffIdMeta),
      );
    } else if (isInserting) {
      context.missing(_staffIdMeta);
    }
    if (data.containsKey('kitchen_id')) {
      context.handle(
        _kitchenIdMeta,
        kitchenId.isAcceptableOrUnknown(data['kitchen_id']!, _kitchenIdMeta),
      );
    } else if (isInserting) {
      context.missing(_kitchenIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {staffId, kitchenId};
  @override
  StaffKitchen map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StaffKitchen(
      staffId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}staff_id'],
      )!,
      kitchenId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kitchen_id'],
      )!,
    );
  }

  @override
  $StaffKitchensTable createAlias(String alias) {
    return $StaffKitchensTable(attachedDatabase, alias);
  }
}

class StaffKitchen extends DataClass implements Insertable<StaffKitchen> {
  final int staffId;
  final int kitchenId;
  const StaffKitchen({required this.staffId, required this.kitchenId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['staff_id'] = Variable<int>(staffId);
    map['kitchen_id'] = Variable<int>(kitchenId);
    return map;
  }

  StaffKitchensCompanion toCompanion(bool nullToAbsent) {
    return StaffKitchensCompanion(
      staffId: Value(staffId),
      kitchenId: Value(kitchenId),
    );
  }

  factory StaffKitchen.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StaffKitchen(
      staffId: serializer.fromJson<int>(json['staffId']),
      kitchenId: serializer.fromJson<int>(json['kitchenId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'staffId': serializer.toJson<int>(staffId),
      'kitchenId': serializer.toJson<int>(kitchenId),
    };
  }

  StaffKitchen copyWith({int? staffId, int? kitchenId}) => StaffKitchen(
    staffId: staffId ?? this.staffId,
    kitchenId: kitchenId ?? this.kitchenId,
  );
  StaffKitchen copyWithCompanion(StaffKitchensCompanion data) {
    return StaffKitchen(
      staffId: data.staffId.present ? data.staffId.value : this.staffId,
      kitchenId: data.kitchenId.present ? data.kitchenId.value : this.kitchenId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StaffKitchen(')
          ..write('staffId: $staffId, ')
          ..write('kitchenId: $kitchenId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(staffId, kitchenId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StaffKitchen &&
          other.staffId == this.staffId &&
          other.kitchenId == this.kitchenId);
}

class StaffKitchensCompanion extends UpdateCompanion<StaffKitchen> {
  final Value<int> staffId;
  final Value<int> kitchenId;
  final Value<int> rowid;
  const StaffKitchensCompanion({
    this.staffId = const Value.absent(),
    this.kitchenId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StaffKitchensCompanion.insert({
    required int staffId,
    required int kitchenId,
    this.rowid = const Value.absent(),
  }) : staffId = Value(staffId),
       kitchenId = Value(kitchenId);
  static Insertable<StaffKitchen> custom({
    Expression<int>? staffId,
    Expression<int>? kitchenId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (staffId != null) 'staff_id': staffId,
      if (kitchenId != null) 'kitchen_id': kitchenId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StaffKitchensCompanion copyWith({
    Value<int>? staffId,
    Value<int>? kitchenId,
    Value<int>? rowid,
  }) {
    return StaffKitchensCompanion(
      staffId: staffId ?? this.staffId,
      kitchenId: kitchenId ?? this.kitchenId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (staffId.present) {
      map['staff_id'] = Variable<int>(staffId.value);
    }
    if (kitchenId.present) {
      map['kitchen_id'] = Variable<int>(kitchenId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StaffKitchensCompanion(')
          ..write('staffId: $staffId, ')
          ..write('kitchenId: $kitchenId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DependentsTable extends Dependents
    with TableInfo<$DependentsTable, Dependent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DependentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fullnameMeta = const VerificationMeta(
    'fullname',
  );
  @override
  late final GeneratedColumn<String> fullname = GeneratedColumn<String>(
    'fullname',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _staffIdMeta = const VerificationMeta(
    'staffId',
  );
  @override
  late final GeneratedColumn<int> staffId = GeneratedColumn<int>(
    'staff_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES staff (id)',
    ),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncUpdatedAtMeta = const VerificationMeta(
    'syncUpdatedAt',
  );
  @override
  late final GeneratedColumn<String> syncUpdatedAt = GeneratedColumn<String>(
    'sync_updated_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fullname,
    status,
    gender,
    staffId,
    syncStatus,
    syncUpdatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dependents';
  @override
  VerificationContext validateIntegrity(
    Insertable<Dependent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('fullname')) {
      context.handle(
        _fullnameMeta,
        fullname.isAcceptableOrUnknown(data['fullname']!, _fullnameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullnameMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    }
    if (data.containsKey('staff_id')) {
      context.handle(
        _staffIdMeta,
        staffId.isAcceptableOrUnknown(data['staff_id']!, _staffIdMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('sync_updated_at')) {
      context.handle(
        _syncUpdatedAtMeta,
        syncUpdatedAt.isAcceptableOrUnknown(
          data['sync_updated_at']!,
          _syncUpdatedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Dependent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Dependent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      fullname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fullname'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      ),
      staffId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}staff_id'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
      syncUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_updated_at'],
      ),
    );
  }

  @override
  $DependentsTable createAlias(String alias) {
    return $DependentsTable(attachedDatabase, alias);
  }
}

class Dependent extends DataClass implements Insertable<Dependent> {
  final int id;
  final String fullname;
  final String status;
  final String? gender;
  final int? staffId;
  final int syncStatus;
  final String? syncUpdatedAt;
  const Dependent({
    required this.id,
    required this.fullname,
    required this.status,
    this.gender,
    this.staffId,
    required this.syncStatus,
    this.syncUpdatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['fullname'] = Variable<String>(fullname);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || staffId != null) {
      map['staff_id'] = Variable<int>(staffId);
    }
    map['sync_status'] = Variable<int>(syncStatus);
    if (!nullToAbsent || syncUpdatedAt != null) {
      map['sync_updated_at'] = Variable<String>(syncUpdatedAt);
    }
    return map;
  }

  DependentsCompanion toCompanion(bool nullToAbsent) {
    return DependentsCompanion(
      id: Value(id),
      fullname: Value(fullname),
      status: Value(status),
      gender: gender == null && nullToAbsent
          ? const Value.absent()
          : Value(gender),
      staffId: staffId == null && nullToAbsent
          ? const Value.absent()
          : Value(staffId),
      syncStatus: Value(syncStatus),
      syncUpdatedAt: syncUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdatedAt),
    );
  }

  factory Dependent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Dependent(
      id: serializer.fromJson<int>(json['id']),
      fullname: serializer.fromJson<String>(json['fullname']),
      status: serializer.fromJson<String>(json['status']),
      gender: serializer.fromJson<String?>(json['gender']),
      staffId: serializer.fromJson<int?>(json['staffId']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      syncUpdatedAt: serializer.fromJson<String?>(json['syncUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fullname': serializer.toJson<String>(fullname),
      'status': serializer.toJson<String>(status),
      'gender': serializer.toJson<String?>(gender),
      'staffId': serializer.toJson<int?>(staffId),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'syncUpdatedAt': serializer.toJson<String?>(syncUpdatedAt),
    };
  }

  Dependent copyWith({
    int? id,
    String? fullname,
    String? status,
    Value<String?> gender = const Value.absent(),
    Value<int?> staffId = const Value.absent(),
    int? syncStatus,
    Value<String?> syncUpdatedAt = const Value.absent(),
  }) => Dependent(
    id: id ?? this.id,
    fullname: fullname ?? this.fullname,
    status: status ?? this.status,
    gender: gender.present ? gender.value : this.gender,
    staffId: staffId.present ? staffId.value : this.staffId,
    syncStatus: syncStatus ?? this.syncStatus,
    syncUpdatedAt: syncUpdatedAt.present
        ? syncUpdatedAt.value
        : this.syncUpdatedAt,
  );
  Dependent copyWithCompanion(DependentsCompanion data) {
    return Dependent(
      id: data.id.present ? data.id.value : this.id,
      fullname: data.fullname.present ? data.fullname.value : this.fullname,
      status: data.status.present ? data.status.value : this.status,
      gender: data.gender.present ? data.gender.value : this.gender,
      staffId: data.staffId.present ? data.staffId.value : this.staffId,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncUpdatedAt: data.syncUpdatedAt.present
          ? data.syncUpdatedAt.value
          : this.syncUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Dependent(')
          ..write('id: $id, ')
          ..write('fullname: $fullname, ')
          ..write('status: $status, ')
          ..write('gender: $gender, ')
          ..write('staffId: $staffId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    fullname,
    status,
    gender,
    staffId,
    syncStatus,
    syncUpdatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Dependent &&
          other.id == this.id &&
          other.fullname == this.fullname &&
          other.status == this.status &&
          other.gender == this.gender &&
          other.staffId == this.staffId &&
          other.syncStatus == this.syncStatus &&
          other.syncUpdatedAt == this.syncUpdatedAt);
}

class DependentsCompanion extends UpdateCompanion<Dependent> {
  final Value<int> id;
  final Value<String> fullname;
  final Value<String> status;
  final Value<String?> gender;
  final Value<int?> staffId;
  final Value<int> syncStatus;
  final Value<String?> syncUpdatedAt;
  const DependentsCompanion({
    this.id = const Value.absent(),
    this.fullname = const Value.absent(),
    this.status = const Value.absent(),
    this.gender = const Value.absent(),
    this.staffId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
  });
  DependentsCompanion.insert({
    this.id = const Value.absent(),
    required String fullname,
    required String status,
    this.gender = const Value.absent(),
    this.staffId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
  }) : fullname = Value(fullname),
       status = Value(status);
  static Insertable<Dependent> custom({
    Expression<int>? id,
    Expression<String>? fullname,
    Expression<String>? status,
    Expression<String>? gender,
    Expression<int>? staffId,
    Expression<int>? syncStatus,
    Expression<String>? syncUpdatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fullname != null) 'fullname': fullname,
      if (status != null) 'status': status,
      if (gender != null) 'gender': gender,
      if (staffId != null) 'staff_id': staffId,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncUpdatedAt != null) 'sync_updated_at': syncUpdatedAt,
    });
  }

  DependentsCompanion copyWith({
    Value<int>? id,
    Value<String>? fullname,
    Value<String>? status,
    Value<String?>? gender,
    Value<int?>? staffId,
    Value<int>? syncStatus,
    Value<String?>? syncUpdatedAt,
  }) {
    return DependentsCompanion(
      id: id ?? this.id,
      fullname: fullname ?? this.fullname,
      status: status ?? this.status,
      gender: gender ?? this.gender,
      staffId: staffId ?? this.staffId,
      syncStatus: syncStatus ?? this.syncStatus,
      syncUpdatedAt: syncUpdatedAt ?? this.syncUpdatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fullname.present) {
      map['fullname'] = Variable<String>(fullname.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (staffId.present) {
      map['staff_id'] = Variable<int>(staffId.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (syncUpdatedAt.present) {
      map['sync_updated_at'] = Variable<String>(syncUpdatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DependentsCompanion(')
          ..write('id: $id, ')
          ..write('fullname: $fullname, ')
          ..write('status: $status, ')
          ..write('gender: $gender, ')
          ..write('staffId: $staffId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt')
          ..write(')'))
        .toString();
  }
}

class $DependentKitchensTable extends DependentKitchens
    with TableInfo<$DependentKitchensTable, DependentKitchen> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DependentKitchensTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dependentIdMeta = const VerificationMeta(
    'dependentId',
  );
  @override
  late final GeneratedColumn<int> dependentId = GeneratedColumn<int>(
    'dependent_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kitchenIdMeta = const VerificationMeta(
    'kitchenId',
  );
  @override
  late final GeneratedColumn<int> kitchenId = GeneratedColumn<int>(
    'kitchen_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [dependentId, kitchenId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dependent_kitchens';
  @override
  VerificationContext validateIntegrity(
    Insertable<DependentKitchen> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('dependent_id')) {
      context.handle(
        _dependentIdMeta,
        dependentId.isAcceptableOrUnknown(
          data['dependent_id']!,
          _dependentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dependentIdMeta);
    }
    if (data.containsKey('kitchen_id')) {
      context.handle(
        _kitchenIdMeta,
        kitchenId.isAcceptableOrUnknown(data['kitchen_id']!, _kitchenIdMeta),
      );
    } else if (isInserting) {
      context.missing(_kitchenIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {dependentId, kitchenId};
  @override
  DependentKitchen map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DependentKitchen(
      dependentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dependent_id'],
      )!,
      kitchenId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kitchen_id'],
      )!,
    );
  }

  @override
  $DependentKitchensTable createAlias(String alias) {
    return $DependentKitchensTable(attachedDatabase, alias);
  }
}

class DependentKitchen extends DataClass
    implements Insertable<DependentKitchen> {
  final int dependentId;
  final int kitchenId;
  const DependentKitchen({required this.dependentId, required this.kitchenId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['dependent_id'] = Variable<int>(dependentId);
    map['kitchen_id'] = Variable<int>(kitchenId);
    return map;
  }

  DependentKitchensCompanion toCompanion(bool nullToAbsent) {
    return DependentKitchensCompanion(
      dependentId: Value(dependentId),
      kitchenId: Value(kitchenId),
    );
  }

  factory DependentKitchen.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DependentKitchen(
      dependentId: serializer.fromJson<int>(json['dependentId']),
      kitchenId: serializer.fromJson<int>(json['kitchenId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dependentId': serializer.toJson<int>(dependentId),
      'kitchenId': serializer.toJson<int>(kitchenId),
    };
  }

  DependentKitchen copyWith({int? dependentId, int? kitchenId}) =>
      DependentKitchen(
        dependentId: dependentId ?? this.dependentId,
        kitchenId: kitchenId ?? this.kitchenId,
      );
  DependentKitchen copyWithCompanion(DependentKitchensCompanion data) {
    return DependentKitchen(
      dependentId: data.dependentId.present
          ? data.dependentId.value
          : this.dependentId,
      kitchenId: data.kitchenId.present ? data.kitchenId.value : this.kitchenId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DependentKitchen(')
          ..write('dependentId: $dependentId, ')
          ..write('kitchenId: $kitchenId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(dependentId, kitchenId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DependentKitchen &&
          other.dependentId == this.dependentId &&
          other.kitchenId == this.kitchenId);
}

class DependentKitchensCompanion extends UpdateCompanion<DependentKitchen> {
  final Value<int> dependentId;
  final Value<int> kitchenId;
  final Value<int> rowid;
  const DependentKitchensCompanion({
    this.dependentId = const Value.absent(),
    this.kitchenId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DependentKitchensCompanion.insert({
    required int dependentId,
    required int kitchenId,
    this.rowid = const Value.absent(),
  }) : dependentId = Value(dependentId),
       kitchenId = Value(kitchenId);
  static Insertable<DependentKitchen> custom({
    Expression<int>? dependentId,
    Expression<int>? kitchenId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (dependentId != null) 'dependent_id': dependentId,
      if (kitchenId != null) 'kitchen_id': kitchenId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DependentKitchensCompanion copyWith({
    Value<int>? dependentId,
    Value<int>? kitchenId,
    Value<int>? rowid,
  }) {
    return DependentKitchensCompanion(
      dependentId: dependentId ?? this.dependentId,
      kitchenId: kitchenId ?? this.kitchenId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dependentId.present) {
      map['dependent_id'] = Variable<int>(dependentId.value);
    }
    if (kitchenId.present) {
      map['kitchen_id'] = Variable<int>(kitchenId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DependentKitchensCompanion(')
          ..write('dependentId: $dependentId, ')
          ..write('kitchenId: $kitchenId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CardsTable extends Cards with TableInfo<$CardsTable, Card> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<String> tagId = GeneratedColumn<String>(
    'tag_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<double> code = GeneratedColumn<double>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reversedCodeMeta = const VerificationMeta(
    'reversedCode',
  );
  @override
  late final GeneratedColumn<double> reversedCode = GeneratedColumn<double>(
    'reversed_code',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isAssignedMeta = const VerificationMeta(
    'isAssigned',
  );
  @override
  late final GeneratedColumn<bool> isAssigned = GeneratedColumn<bool>(
    'is_assigned',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_assigned" IN (0, 1))',
    ),
  );
  static const VerificationMeta _assignedToIdMeta = const VerificationMeta(
    'assignedToId',
  );
  @override
  late final GeneratedColumn<int> assignedToId = GeneratedColumn<int>(
    'assigned_to_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _assignedToTypeMeta = const VerificationMeta(
    'assignedToType',
  );
  @override
  late final GeneratedColumn<String> assignedToType = GeneratedColumn<String>(
    'assigned_to_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _issuedDateMeta = const VerificationMeta(
    'issuedDate',
  );
  @override
  late final GeneratedColumn<String> issuedDate = GeneratedColumn<String>(
    'issued_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncUpdatedAtMeta = const VerificationMeta(
    'syncUpdatedAt',
  );
  @override
  late final GeneratedColumn<String> syncUpdatedAt = GeneratedColumn<String>(
    'sync_updated_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tagId,
    code,
    reversedCode,
    status,
    isAssigned,
    assignedToId,
    assignedToType,
    issuedDate,
    createdAt,
    syncStatus,
    syncUpdatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<Card> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('reversed_code')) {
      context.handle(
        _reversedCodeMeta,
        reversedCode.isAcceptableOrUnknown(
          data['reversed_code']!,
          _reversedCodeMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('is_assigned')) {
      context.handle(
        _isAssignedMeta,
        isAssigned.isAcceptableOrUnknown(data['is_assigned']!, _isAssignedMeta),
      );
    }
    if (data.containsKey('assigned_to_id')) {
      context.handle(
        _assignedToIdMeta,
        assignedToId.isAcceptableOrUnknown(
          data['assigned_to_id']!,
          _assignedToIdMeta,
        ),
      );
    }
    if (data.containsKey('assigned_to_type')) {
      context.handle(
        _assignedToTypeMeta,
        assignedToType.isAcceptableOrUnknown(
          data['assigned_to_type']!,
          _assignedToTypeMeta,
        ),
      );
    }
    if (data.containsKey('issued_date')) {
      context.handle(
        _issuedDateMeta,
        issuedDate.isAcceptableOrUnknown(data['issued_date']!, _issuedDateMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('sync_updated_at')) {
      context.handle(
        _syncUpdatedAtMeta,
        syncUpdatedAt.isAcceptableOrUnknown(
          data['sync_updated_at']!,
          _syncUpdatedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Card map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Card(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_id'],
      ),
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}code'],
      )!,
      reversedCode: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}reversed_code'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      isAssigned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_assigned'],
      ),
      assignedToId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}assigned_to_id'],
      ),
      assignedToType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}assigned_to_type'],
      ),
      issuedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}issued_date'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
      syncUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_updated_at'],
      ),
    );
  }

  @override
  $CardsTable createAlias(String alias) {
    return $CardsTable(attachedDatabase, alias);
  }
}

class Card extends DataClass implements Insertable<Card> {
  final int id;
  final String? tagId;
  final double code;
  final double? reversedCode;
  final String status;
  final bool? isAssigned;
  final int? assignedToId;
  final String? assignedToType;
  final String? issuedDate;
  final String? createdAt;
  final int syncStatus;
  final String? syncUpdatedAt;
  const Card({
    required this.id,
    this.tagId,
    required this.code,
    this.reversedCode,
    required this.status,
    this.isAssigned,
    this.assignedToId,
    this.assignedToType,
    this.issuedDate,
    this.createdAt,
    required this.syncStatus,
    this.syncUpdatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || tagId != null) {
      map['tag_id'] = Variable<String>(tagId);
    }
    map['code'] = Variable<double>(code);
    if (!nullToAbsent || reversedCode != null) {
      map['reversed_code'] = Variable<double>(reversedCode);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || isAssigned != null) {
      map['is_assigned'] = Variable<bool>(isAssigned);
    }
    if (!nullToAbsent || assignedToId != null) {
      map['assigned_to_id'] = Variable<int>(assignedToId);
    }
    if (!nullToAbsent || assignedToType != null) {
      map['assigned_to_type'] = Variable<String>(assignedToType);
    }
    if (!nullToAbsent || issuedDate != null) {
      map['issued_date'] = Variable<String>(issuedDate);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    map['sync_status'] = Variable<int>(syncStatus);
    if (!nullToAbsent || syncUpdatedAt != null) {
      map['sync_updated_at'] = Variable<String>(syncUpdatedAt);
    }
    return map;
  }

  CardsCompanion toCompanion(bool nullToAbsent) {
    return CardsCompanion(
      id: Value(id),
      tagId: tagId == null && nullToAbsent
          ? const Value.absent()
          : Value(tagId),
      code: Value(code),
      reversedCode: reversedCode == null && nullToAbsent
          ? const Value.absent()
          : Value(reversedCode),
      status: Value(status),
      isAssigned: isAssigned == null && nullToAbsent
          ? const Value.absent()
          : Value(isAssigned),
      assignedToId: assignedToId == null && nullToAbsent
          ? const Value.absent()
          : Value(assignedToId),
      assignedToType: assignedToType == null && nullToAbsent
          ? const Value.absent()
          : Value(assignedToType),
      issuedDate: issuedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(issuedDate),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      syncStatus: Value(syncStatus),
      syncUpdatedAt: syncUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdatedAt),
    );
  }

  factory Card.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Card(
      id: serializer.fromJson<int>(json['id']),
      tagId: serializer.fromJson<String?>(json['tagId']),
      code: serializer.fromJson<double>(json['code']),
      reversedCode: serializer.fromJson<double?>(json['reversedCode']),
      status: serializer.fromJson<String>(json['status']),
      isAssigned: serializer.fromJson<bool?>(json['isAssigned']),
      assignedToId: serializer.fromJson<int?>(json['assignedToId']),
      assignedToType: serializer.fromJson<String?>(json['assignedToType']),
      issuedDate: serializer.fromJson<String?>(json['issuedDate']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      syncUpdatedAt: serializer.fromJson<String?>(json['syncUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tagId': serializer.toJson<String?>(tagId),
      'code': serializer.toJson<double>(code),
      'reversedCode': serializer.toJson<double?>(reversedCode),
      'status': serializer.toJson<String>(status),
      'isAssigned': serializer.toJson<bool?>(isAssigned),
      'assignedToId': serializer.toJson<int?>(assignedToId),
      'assignedToType': serializer.toJson<String?>(assignedToType),
      'issuedDate': serializer.toJson<String?>(issuedDate),
      'createdAt': serializer.toJson<String?>(createdAt),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'syncUpdatedAt': serializer.toJson<String?>(syncUpdatedAt),
    };
  }

  Card copyWith({
    int? id,
    Value<String?> tagId = const Value.absent(),
    double? code,
    Value<double?> reversedCode = const Value.absent(),
    String? status,
    Value<bool?> isAssigned = const Value.absent(),
    Value<int?> assignedToId = const Value.absent(),
    Value<String?> assignedToType = const Value.absent(),
    Value<String?> issuedDate = const Value.absent(),
    Value<String?> createdAt = const Value.absent(),
    int? syncStatus,
    Value<String?> syncUpdatedAt = const Value.absent(),
  }) => Card(
    id: id ?? this.id,
    tagId: tagId.present ? tagId.value : this.tagId,
    code: code ?? this.code,
    reversedCode: reversedCode.present ? reversedCode.value : this.reversedCode,
    status: status ?? this.status,
    isAssigned: isAssigned.present ? isAssigned.value : this.isAssigned,
    assignedToId: assignedToId.present ? assignedToId.value : this.assignedToId,
    assignedToType: assignedToType.present
        ? assignedToType.value
        : this.assignedToType,
    issuedDate: issuedDate.present ? issuedDate.value : this.issuedDate,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    syncStatus: syncStatus ?? this.syncStatus,
    syncUpdatedAt: syncUpdatedAt.present
        ? syncUpdatedAt.value
        : this.syncUpdatedAt,
  );
  Card copyWithCompanion(CardsCompanion data) {
    return Card(
      id: data.id.present ? data.id.value : this.id,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
      code: data.code.present ? data.code.value : this.code,
      reversedCode: data.reversedCode.present
          ? data.reversedCode.value
          : this.reversedCode,
      status: data.status.present ? data.status.value : this.status,
      isAssigned: data.isAssigned.present
          ? data.isAssigned.value
          : this.isAssigned,
      assignedToId: data.assignedToId.present
          ? data.assignedToId.value
          : this.assignedToId,
      assignedToType: data.assignedToType.present
          ? data.assignedToType.value
          : this.assignedToType,
      issuedDate: data.issuedDate.present
          ? data.issuedDate.value
          : this.issuedDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncUpdatedAt: data.syncUpdatedAt.present
          ? data.syncUpdatedAt.value
          : this.syncUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Card(')
          ..write('id: $id, ')
          ..write('tagId: $tagId, ')
          ..write('code: $code, ')
          ..write('reversedCode: $reversedCode, ')
          ..write('status: $status, ')
          ..write('isAssigned: $isAssigned, ')
          ..write('assignedToId: $assignedToId, ')
          ..write('assignedToType: $assignedToType, ')
          ..write('issuedDate: $issuedDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tagId,
    code,
    reversedCode,
    status,
    isAssigned,
    assignedToId,
    assignedToType,
    issuedDate,
    createdAt,
    syncStatus,
    syncUpdatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Card &&
          other.id == this.id &&
          other.tagId == this.tagId &&
          other.code == this.code &&
          other.reversedCode == this.reversedCode &&
          other.status == this.status &&
          other.isAssigned == this.isAssigned &&
          other.assignedToId == this.assignedToId &&
          other.assignedToType == this.assignedToType &&
          other.issuedDate == this.issuedDate &&
          other.createdAt == this.createdAt &&
          other.syncStatus == this.syncStatus &&
          other.syncUpdatedAt == this.syncUpdatedAt);
}

class CardsCompanion extends UpdateCompanion<Card> {
  final Value<int> id;
  final Value<String?> tagId;
  final Value<double> code;
  final Value<double?> reversedCode;
  final Value<String> status;
  final Value<bool?> isAssigned;
  final Value<int?> assignedToId;
  final Value<String?> assignedToType;
  final Value<String?> issuedDate;
  final Value<String?> createdAt;
  final Value<int> syncStatus;
  final Value<String?> syncUpdatedAt;
  const CardsCompanion({
    this.id = const Value.absent(),
    this.tagId = const Value.absent(),
    this.code = const Value.absent(),
    this.reversedCode = const Value.absent(),
    this.status = const Value.absent(),
    this.isAssigned = const Value.absent(),
    this.assignedToId = const Value.absent(),
    this.assignedToType = const Value.absent(),
    this.issuedDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
  });
  CardsCompanion.insert({
    this.id = const Value.absent(),
    this.tagId = const Value.absent(),
    required double code,
    this.reversedCode = const Value.absent(),
    required String status,
    this.isAssigned = const Value.absent(),
    this.assignedToId = const Value.absent(),
    this.assignedToType = const Value.absent(),
    this.issuedDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
  }) : code = Value(code),
       status = Value(status);
  static Insertable<Card> custom({
    Expression<int>? id,
    Expression<String>? tagId,
    Expression<double>? code,
    Expression<double>? reversedCode,
    Expression<String>? status,
    Expression<bool>? isAssigned,
    Expression<int>? assignedToId,
    Expression<String>? assignedToType,
    Expression<String>? issuedDate,
    Expression<String>? createdAt,
    Expression<int>? syncStatus,
    Expression<String>? syncUpdatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tagId != null) 'tag_id': tagId,
      if (code != null) 'code': code,
      if (reversedCode != null) 'reversed_code': reversedCode,
      if (status != null) 'status': status,
      if (isAssigned != null) 'is_assigned': isAssigned,
      if (assignedToId != null) 'assigned_to_id': assignedToId,
      if (assignedToType != null) 'assigned_to_type': assignedToType,
      if (issuedDate != null) 'issued_date': issuedDate,
      if (createdAt != null) 'created_at': createdAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncUpdatedAt != null) 'sync_updated_at': syncUpdatedAt,
    });
  }

  CardsCompanion copyWith({
    Value<int>? id,
    Value<String?>? tagId,
    Value<double>? code,
    Value<double?>? reversedCode,
    Value<String>? status,
    Value<bool?>? isAssigned,
    Value<int?>? assignedToId,
    Value<String?>? assignedToType,
    Value<String?>? issuedDate,
    Value<String?>? createdAt,
    Value<int>? syncStatus,
    Value<String?>? syncUpdatedAt,
  }) {
    return CardsCompanion(
      id: id ?? this.id,
      tagId: tagId ?? this.tagId,
      code: code ?? this.code,
      reversedCode: reversedCode ?? this.reversedCode,
      status: status ?? this.status,
      isAssigned: isAssigned ?? this.isAssigned,
      assignedToId: assignedToId ?? this.assignedToId,
      assignedToType: assignedToType ?? this.assignedToType,
      issuedDate: issuedDate ?? this.issuedDate,
      createdAt: createdAt ?? this.createdAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncUpdatedAt: syncUpdatedAt ?? this.syncUpdatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<String>(tagId.value);
    }
    if (code.present) {
      map['code'] = Variable<double>(code.value);
    }
    if (reversedCode.present) {
      map['reversed_code'] = Variable<double>(reversedCode.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (isAssigned.present) {
      map['is_assigned'] = Variable<bool>(isAssigned.value);
    }
    if (assignedToId.present) {
      map['assigned_to_id'] = Variable<int>(assignedToId.value);
    }
    if (assignedToType.present) {
      map['assigned_to_type'] = Variable<String>(assignedToType.value);
    }
    if (issuedDate.present) {
      map['issued_date'] = Variable<String>(issuedDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (syncUpdatedAt.present) {
      map['sync_updated_at'] = Variable<String>(syncUpdatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardsCompanion(')
          ..write('id: $id, ')
          ..write('tagId: $tagId, ')
          ..write('code: $code, ')
          ..write('reversedCode: $reversedCode, ')
          ..write('status: $status, ')
          ..write('isAssigned: $isAssigned, ')
          ..write('assignedToId: $assignedToId, ')
          ..write('assignedToType: $assignedToType, ')
          ..write('issuedDate: $issuedDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _lastLoginAtMeta = const VerificationMeta(
    'lastLoginAt',
  );
  @override
  late final GeneratedColumn<String> lastLoginAt = GeneratedColumn<String>(
    'last_login_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actStartDateMeta = const VerificationMeta(
    'actStartDate',
  );
  @override
  late final GeneratedColumn<String> actStartDate = GeneratedColumn<String>(
    'act_start_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actEndDateMeta = const VerificationMeta(
    'actEndDate',
  );
  @override
  late final GeneratedColumn<String> actEndDate = GeneratedColumn<String>(
    'act_end_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncUpdatedAtMeta = const VerificationMeta(
    'syncUpdatedAt',
  );
  @override
  late final GeneratedColumn<String> syncUpdatedAt = GeneratedColumn<String>(
    'sync_updated_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    firstName,
    lastName,
    email,
    phone,
    role,
    isActive,
    lastLoginAt,
    actStartDate,
    actEndDate,
    createdAt,
    updatedAt,
    syncStatus,
    syncUpdatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('last_login_at')) {
      context.handle(
        _lastLoginAtMeta,
        lastLoginAt.isAcceptableOrUnknown(
          data['last_login_at']!,
          _lastLoginAtMeta,
        ),
      );
    }
    if (data.containsKey('act_start_date')) {
      context.handle(
        _actStartDateMeta,
        actStartDate.isAcceptableOrUnknown(
          data['act_start_date']!,
          _actStartDateMeta,
        ),
      );
    }
    if (data.containsKey('act_end_date')) {
      context.handle(
        _actEndDateMeta,
        actEndDate.isAcceptableOrUnknown(
          data['act_end_date']!,
          _actEndDateMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('sync_updated_at')) {
      context.handle(
        _syncUpdatedAtMeta,
        syncUpdatedAt.isAcceptableOrUnknown(
          data['sync_updated_at']!,
          _syncUpdatedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      )!,
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      lastLoginAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_login_at'],
      ),
      actStartDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}act_start_date'],
      ),
      actEndDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}act_end_date'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
      syncUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_updated_at'],
      ),
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String firstName;
  final String lastName;
  final String? email;
  final String? phone;
  final String role;
  final bool isActive;
  final String? lastLoginAt;
  final String? actStartDate;
  final String? actEndDate;
  final String createdAt;
  final String updatedAt;
  final int syncStatus;
  final String? syncUpdatedAt;
  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    this.phone,
    required this.role,
    required this.isActive,
    this.lastLoginAt,
    this.actStartDate,
    this.actEndDate,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    this.syncUpdatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    map['role'] = Variable<String>(role);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || lastLoginAt != null) {
      map['last_login_at'] = Variable<String>(lastLoginAt);
    }
    if (!nullToAbsent || actStartDate != null) {
      map['act_start_date'] = Variable<String>(actStartDate);
    }
    if (!nullToAbsent || actEndDate != null) {
      map['act_end_date'] = Variable<String>(actEndDate);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    map['sync_status'] = Variable<int>(syncStatus);
    if (!nullToAbsent || syncUpdatedAt != null) {
      map['sync_updated_at'] = Variable<String>(syncUpdatedAt);
    }
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      firstName: Value(firstName),
      lastName: Value(lastName),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      role: Value(role),
      isActive: Value(isActive),
      lastLoginAt: lastLoginAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastLoginAt),
      actStartDate: actStartDate == null && nullToAbsent
          ? const Value.absent()
          : Value(actStartDate),
      actEndDate: actEndDate == null && nullToAbsent
          ? const Value.absent()
          : Value(actEndDate),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      syncUpdatedAt: syncUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdatedAt),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      email: serializer.fromJson<String?>(json['email']),
      phone: serializer.fromJson<String?>(json['phone']),
      role: serializer.fromJson<String>(json['role']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      lastLoginAt: serializer.fromJson<String?>(json['lastLoginAt']),
      actStartDate: serializer.fromJson<String?>(json['actStartDate']),
      actEndDate: serializer.fromJson<String?>(json['actEndDate']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      syncUpdatedAt: serializer.fromJson<String?>(json['syncUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'email': serializer.toJson<String?>(email),
      'phone': serializer.toJson<String?>(phone),
      'role': serializer.toJson<String>(role),
      'isActive': serializer.toJson<bool>(isActive),
      'lastLoginAt': serializer.toJson<String?>(lastLoginAt),
      'actStartDate': serializer.toJson<String?>(actStartDate),
      'actEndDate': serializer.toJson<String?>(actEndDate),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'syncUpdatedAt': serializer.toJson<String?>(syncUpdatedAt),
    };
  }

  User copyWith({
    int? id,
    String? firstName,
    String? lastName,
    Value<String?> email = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    String? role,
    bool? isActive,
    Value<String?> lastLoginAt = const Value.absent(),
    Value<String?> actStartDate = const Value.absent(),
    Value<String?> actEndDate = const Value.absent(),
    String? createdAt,
    String? updatedAt,
    int? syncStatus,
    Value<String?> syncUpdatedAt = const Value.absent(),
  }) => User(
    id: id ?? this.id,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    email: email.present ? email.value : this.email,
    phone: phone.present ? phone.value : this.phone,
    role: role ?? this.role,
    isActive: isActive ?? this.isActive,
    lastLoginAt: lastLoginAt.present ? lastLoginAt.value : this.lastLoginAt,
    actStartDate: actStartDate.present ? actStartDate.value : this.actStartDate,
    actEndDate: actEndDate.present ? actEndDate.value : this.actEndDate,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    syncUpdatedAt: syncUpdatedAt.present
        ? syncUpdatedAt.value
        : this.syncUpdatedAt,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      email: data.email.present ? data.email.value : this.email,
      phone: data.phone.present ? data.phone.value : this.phone,
      role: data.role.present ? data.role.value : this.role,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      lastLoginAt: data.lastLoginAt.present
          ? data.lastLoginAt.value
          : this.lastLoginAt,
      actStartDate: data.actStartDate.present
          ? data.actStartDate.value
          : this.actStartDate,
      actEndDate: data.actEndDate.present
          ? data.actEndDate.value
          : this.actEndDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncUpdatedAt: data.syncUpdatedAt.present
          ? data.syncUpdatedAt.value
          : this.syncUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('role: $role, ')
          ..write('isActive: $isActive, ')
          ..write('lastLoginAt: $lastLoginAt, ')
          ..write('actStartDate: $actStartDate, ')
          ..write('actEndDate: $actEndDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    firstName,
    lastName,
    email,
    phone,
    role,
    isActive,
    lastLoginAt,
    actStartDate,
    actEndDate,
    createdAt,
    updatedAt,
    syncStatus,
    syncUpdatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.email == this.email &&
          other.phone == this.phone &&
          other.role == this.role &&
          other.isActive == this.isActive &&
          other.lastLoginAt == this.lastLoginAt &&
          other.actStartDate == this.actStartDate &&
          other.actEndDate == this.actEndDate &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.syncUpdatedAt == this.syncUpdatedAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String?> email;
  final Value<String?> phone;
  final Value<String> role;
  final Value<bool> isActive;
  final Value<String?> lastLoginAt;
  final Value<String?> actStartDate;
  final Value<String?> actEndDate;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> syncStatus;
  final Value<String?> syncUpdatedAt;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.role = const Value.absent(),
    this.isActive = const Value.absent(),
    this.lastLoginAt = const Value.absent(),
    this.actStartDate = const Value.absent(),
    this.actEndDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String firstName,
    required String lastName,
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    required String role,
    this.isActive = const Value.absent(),
    this.lastLoginAt = const Value.absent(),
    this.actStartDate = const Value.absent(),
    this.actEndDate = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
  }) : firstName = Value(firstName),
       lastName = Value(lastName),
       role = Value(role),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? email,
    Expression<String>? phone,
    Expression<String>? role,
    Expression<bool>? isActive,
    Expression<String>? lastLoginAt,
    Expression<String>? actStartDate,
    Expression<String>? actEndDate,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? syncStatus,
    Expression<String>? syncUpdatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (role != null) 'role': role,
      if (isActive != null) 'is_active': isActive,
      if (lastLoginAt != null) 'last_login_at': lastLoginAt,
      if (actStartDate != null) 'act_start_date': actStartDate,
      if (actEndDate != null) 'act_end_date': actEndDate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncUpdatedAt != null) 'sync_updated_at': syncUpdatedAt,
    });
  }

  UsersCompanion copyWith({
    Value<int>? id,
    Value<String>? firstName,
    Value<String>? lastName,
    Value<String?>? email,
    Value<String?>? phone,
    Value<String>? role,
    Value<bool>? isActive,
    Value<String?>? lastLoginAt,
    Value<String?>? actStartDate,
    Value<String?>? actEndDate,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? syncStatus,
    Value<String?>? syncUpdatedAt,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      actStartDate: actStartDate ?? this.actStartDate,
      actEndDate: actEndDate ?? this.actEndDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncUpdatedAt: syncUpdatedAt ?? this.syncUpdatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (lastLoginAt.present) {
      map['last_login_at'] = Variable<String>(lastLoginAt.value);
    }
    if (actStartDate.present) {
      map['act_start_date'] = Variable<String>(actStartDate.value);
    }
    if (actEndDate.present) {
      map['act_end_date'] = Variable<String>(actEndDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (syncUpdatedAt.present) {
      map['sync_updated_at'] = Variable<String>(syncUpdatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('role: $role, ')
          ..write('isActive: $isActive, ')
          ..write('lastLoginAt: $lastLoginAt, ')
          ..write('actStartDate: $actStartDate, ')
          ..write('actEndDate: $actEndDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt')
          ..write(')'))
        .toString();
  }
}

class $UserKitchensTable extends UserKitchens
    with TableInfo<$UserKitchensTable, UserKitchen> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserKitchensTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kitchenIdMeta = const VerificationMeta(
    'kitchenId',
  );
  @override
  late final GeneratedColumn<int> kitchenId = GeneratedColumn<int>(
    'kitchen_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [userId, kitchenId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_kitchens';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserKitchen> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('kitchen_id')) {
      context.handle(
        _kitchenIdMeta,
        kitchenId.isAcceptableOrUnknown(data['kitchen_id']!, _kitchenIdMeta),
      );
    } else if (isInserting) {
      context.missing(_kitchenIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, kitchenId};
  @override
  UserKitchen map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserKitchen(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      kitchenId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kitchen_id'],
      )!,
    );
  }

  @override
  $UserKitchensTable createAlias(String alias) {
    return $UserKitchensTable(attachedDatabase, alias);
  }
}

class UserKitchen extends DataClass implements Insertable<UserKitchen> {
  final int userId;
  final int kitchenId;
  const UserKitchen({required this.userId, required this.kitchenId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<int>(userId);
    map['kitchen_id'] = Variable<int>(kitchenId);
    return map;
  }

  UserKitchensCompanion toCompanion(bool nullToAbsent) {
    return UserKitchensCompanion(
      userId: Value(userId),
      kitchenId: Value(kitchenId),
    );
  }

  factory UserKitchen.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserKitchen(
      userId: serializer.fromJson<int>(json['userId']),
      kitchenId: serializer.fromJson<int>(json['kitchenId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<int>(userId),
      'kitchenId': serializer.toJson<int>(kitchenId),
    };
  }

  UserKitchen copyWith({int? userId, int? kitchenId}) => UserKitchen(
    userId: userId ?? this.userId,
    kitchenId: kitchenId ?? this.kitchenId,
  );
  UserKitchen copyWithCompanion(UserKitchensCompanion data) {
    return UserKitchen(
      userId: data.userId.present ? data.userId.value : this.userId,
      kitchenId: data.kitchenId.present ? data.kitchenId.value : this.kitchenId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserKitchen(')
          ..write('userId: $userId, ')
          ..write('kitchenId: $kitchenId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userId, kitchenId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserKitchen &&
          other.userId == this.userId &&
          other.kitchenId == this.kitchenId);
}

class UserKitchensCompanion extends UpdateCompanion<UserKitchen> {
  final Value<int> userId;
  final Value<int> kitchenId;
  final Value<int> rowid;
  const UserKitchensCompanion({
    this.userId = const Value.absent(),
    this.kitchenId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserKitchensCompanion.insert({
    required int userId,
    required int kitchenId,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       kitchenId = Value(kitchenId);
  static Insertable<UserKitchen> custom({
    Expression<int>? userId,
    Expression<int>? kitchenId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (kitchenId != null) 'kitchen_id': kitchenId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserKitchensCompanion copyWith({
    Value<int>? userId,
    Value<int>? kitchenId,
    Value<int>? rowid,
  }) {
    return UserKitchensCompanion(
      userId: userId ?? this.userId,
      kitchenId: kitchenId ?? this.kitchenId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (kitchenId.present) {
      map['kitchen_id'] = Variable<int>(kitchenId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserKitchensCompanion(')
          ..write('userId: $userId, ')
          ..write('kitchenId: $kitchenId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrdersTable extends Orders with TableInfo<$OrdersTable, Order> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderCodeMeta = const VerificationMeta(
    'orderCode',
  );
  @override
  late final GeneratedColumn<String> orderCode = GeneratedColumn<String>(
    'order_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderTypeMeta = const VerificationMeta(
    'orderType',
  );
  @override
  late final GeneratedColumn<String> orderType = GeneratedColumn<String>(
    'order_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mealTypeMeta = const VerificationMeta(
    'mealType',
  );
  @override
  late final GeneratedColumn<String> mealType = GeneratedColumn<String>(
    'meal_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupCountMeta = const VerificationMeta(
    'groupCount',
  );
  @override
  late final GeneratedColumn<int> groupCount = GeneratedColumn<int>(
    'group_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderedByIdMeta = const VerificationMeta(
    'orderedById',
  );
  @override
  late final GeneratedColumn<int> orderedById = GeneratedColumn<int>(
    'ordered_by_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _employeeTypeMeta = const VerificationMeta(
    'employeeType',
  );
  @override
  late final GeneratedColumn<String> employeeType = GeneratedColumn<String>(
    'employee_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncUpdatedAtMeta = const VerificationMeta(
    'syncUpdatedAt',
  );
  @override
  late final GeneratedColumn<String> syncUpdatedAt = GeneratedColumn<String>(
    'sync_updated_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    uuid,
    orderCode,
    status,
    orderType,
    mealType,
    total,
    groupCount,
    description,
    orderedById,
    employeeType,
    createdAt,
    updatedAt,
    syncStatus,
    syncUpdatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'orders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Order> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('order_code')) {
      context.handle(
        _orderCodeMeta,
        orderCode.isAcceptableOrUnknown(data['order_code']!, _orderCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_orderCodeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('order_type')) {
      context.handle(
        _orderTypeMeta,
        orderType.isAcceptableOrUnknown(data['order_type']!, _orderTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_orderTypeMeta);
    }
    if (data.containsKey('meal_type')) {
      context.handle(
        _mealTypeMeta,
        mealType.isAcceptableOrUnknown(data['meal_type']!, _mealTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mealTypeMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('group_count')) {
      context.handle(
        _groupCountMeta,
        groupCount.isAcceptableOrUnknown(data['group_count']!, _groupCountMeta),
      );
    } else if (isInserting) {
      context.missing(_groupCountMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('ordered_by_id')) {
      context.handle(
        _orderedByIdMeta,
        orderedById.isAcceptableOrUnknown(
          data['ordered_by_id']!,
          _orderedByIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_orderedByIdMeta);
    }
    if (data.containsKey('employee_type')) {
      context.handle(
        _employeeTypeMeta,
        employeeType.isAcceptableOrUnknown(
          data['employee_type']!,
          _employeeTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_employeeTypeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('sync_updated_at')) {
      context.handle(
        _syncUpdatedAtMeta,
        syncUpdatedAt.isAcceptableOrUnknown(
          data['sync_updated_at']!,
          _syncUpdatedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Order map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Order(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      orderCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_code'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      orderType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_type'],
      )!,
      mealType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_type'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total'],
      )!,
      groupCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}group_count'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      orderedById: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ordered_by_id'],
      )!,
      employeeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}employee_type'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
      syncUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_updated_at'],
      ),
    );
  }

  @override
  $OrdersTable createAlias(String alias) {
    return $OrdersTable(attachedDatabase, alias);
  }
}

class Order extends DataClass implements Insertable<Order> {
  final int id;
  final String uuid;
  final String orderCode;
  final String status;
  final String orderType;
  final String mealType;
  final double total;
  final int groupCount;
  final String? description;
  final int orderedById;
  final String employeeType;
  final String createdAt;
  final String updatedAt;
  final int syncStatus;
  final String? syncUpdatedAt;
  const Order({
    required this.id,
    required this.uuid,
    required this.orderCode,
    required this.status,
    required this.orderType,
    required this.mealType,
    required this.total,
    required this.groupCount,
    this.description,
    required this.orderedById,
    required this.employeeType,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    this.syncUpdatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['order_code'] = Variable<String>(orderCode);
    map['status'] = Variable<String>(status);
    map['order_type'] = Variable<String>(orderType);
    map['meal_type'] = Variable<String>(mealType);
    map['total'] = Variable<double>(total);
    map['group_count'] = Variable<int>(groupCount);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['ordered_by_id'] = Variable<int>(orderedById);
    map['employee_type'] = Variable<String>(employeeType);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    map['sync_status'] = Variable<int>(syncStatus);
    if (!nullToAbsent || syncUpdatedAt != null) {
      map['sync_updated_at'] = Variable<String>(syncUpdatedAt);
    }
    return map;
  }

  OrdersCompanion toCompanion(bool nullToAbsent) {
    return OrdersCompanion(
      id: Value(id),
      uuid: Value(uuid),
      orderCode: Value(orderCode),
      status: Value(status),
      orderType: Value(orderType),
      mealType: Value(mealType),
      total: Value(total),
      groupCount: Value(groupCount),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      orderedById: Value(orderedById),
      employeeType: Value(employeeType),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      syncUpdatedAt: syncUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdatedAt),
    );
  }

  factory Order.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Order(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      orderCode: serializer.fromJson<String>(json['orderCode']),
      status: serializer.fromJson<String>(json['status']),
      orderType: serializer.fromJson<String>(json['orderType']),
      mealType: serializer.fromJson<String>(json['mealType']),
      total: serializer.fromJson<double>(json['total']),
      groupCount: serializer.fromJson<int>(json['groupCount']),
      description: serializer.fromJson<String?>(json['description']),
      orderedById: serializer.fromJson<int>(json['orderedById']),
      employeeType: serializer.fromJson<String>(json['employeeType']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      syncUpdatedAt: serializer.fromJson<String?>(json['syncUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'orderCode': serializer.toJson<String>(orderCode),
      'status': serializer.toJson<String>(status),
      'orderType': serializer.toJson<String>(orderType),
      'mealType': serializer.toJson<String>(mealType),
      'total': serializer.toJson<double>(total),
      'groupCount': serializer.toJson<int>(groupCount),
      'description': serializer.toJson<String?>(description),
      'orderedById': serializer.toJson<int>(orderedById),
      'employeeType': serializer.toJson<String>(employeeType),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'syncUpdatedAt': serializer.toJson<String?>(syncUpdatedAt),
    };
  }

  Order copyWith({
    int? id,
    String? uuid,
    String? orderCode,
    String? status,
    String? orderType,
    String? mealType,
    double? total,
    int? groupCount,
    Value<String?> description = const Value.absent(),
    int? orderedById,
    String? employeeType,
    String? createdAt,
    String? updatedAt,
    int? syncStatus,
    Value<String?> syncUpdatedAt = const Value.absent(),
  }) => Order(
    id: id ?? this.id,
    uuid: uuid ?? this.uuid,
    orderCode: orderCode ?? this.orderCode,
    status: status ?? this.status,
    orderType: orderType ?? this.orderType,
    mealType: mealType ?? this.mealType,
    total: total ?? this.total,
    groupCount: groupCount ?? this.groupCount,
    description: description.present ? description.value : this.description,
    orderedById: orderedById ?? this.orderedById,
    employeeType: employeeType ?? this.employeeType,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    syncUpdatedAt: syncUpdatedAt.present
        ? syncUpdatedAt.value
        : this.syncUpdatedAt,
  );
  Order copyWithCompanion(OrdersCompanion data) {
    return Order(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      orderCode: data.orderCode.present ? data.orderCode.value : this.orderCode,
      status: data.status.present ? data.status.value : this.status,
      orderType: data.orderType.present ? data.orderType.value : this.orderType,
      mealType: data.mealType.present ? data.mealType.value : this.mealType,
      total: data.total.present ? data.total.value : this.total,
      groupCount: data.groupCount.present
          ? data.groupCount.value
          : this.groupCount,
      description: data.description.present
          ? data.description.value
          : this.description,
      orderedById: data.orderedById.present
          ? data.orderedById.value
          : this.orderedById,
      employeeType: data.employeeType.present
          ? data.employeeType.value
          : this.employeeType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncUpdatedAt: data.syncUpdatedAt.present
          ? data.syncUpdatedAt.value
          : this.syncUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Order(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('orderCode: $orderCode, ')
          ..write('status: $status, ')
          ..write('orderType: $orderType, ')
          ..write('mealType: $mealType, ')
          ..write('total: $total, ')
          ..write('groupCount: $groupCount, ')
          ..write('description: $description, ')
          ..write('orderedById: $orderedById, ')
          ..write('employeeType: $employeeType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    uuid,
    orderCode,
    status,
    orderType,
    mealType,
    total,
    groupCount,
    description,
    orderedById,
    employeeType,
    createdAt,
    updatedAt,
    syncStatus,
    syncUpdatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Order &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.orderCode == this.orderCode &&
          other.status == this.status &&
          other.orderType == this.orderType &&
          other.mealType == this.mealType &&
          other.total == this.total &&
          other.groupCount == this.groupCount &&
          other.description == this.description &&
          other.orderedById == this.orderedById &&
          other.employeeType == this.employeeType &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.syncUpdatedAt == this.syncUpdatedAt);
}

class OrdersCompanion extends UpdateCompanion<Order> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> orderCode;
  final Value<String> status;
  final Value<String> orderType;
  final Value<String> mealType;
  final Value<double> total;
  final Value<int> groupCount;
  final Value<String?> description;
  final Value<int> orderedById;
  final Value<String> employeeType;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> syncStatus;
  final Value<String?> syncUpdatedAt;
  const OrdersCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.orderCode = const Value.absent(),
    this.status = const Value.absent(),
    this.orderType = const Value.absent(),
    this.mealType = const Value.absent(),
    this.total = const Value.absent(),
    this.groupCount = const Value.absent(),
    this.description = const Value.absent(),
    this.orderedById = const Value.absent(),
    this.employeeType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
  });
  OrdersCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required String orderCode,
    required String status,
    required String orderType,
    required String mealType,
    required double total,
    required int groupCount,
    this.description = const Value.absent(),
    required int orderedById,
    required String employeeType,
    required String createdAt,
    required String updatedAt,
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
  }) : uuid = Value(uuid),
       orderCode = Value(orderCode),
       status = Value(status),
       orderType = Value(orderType),
       mealType = Value(mealType),
       total = Value(total),
       groupCount = Value(groupCount),
       orderedById = Value(orderedById),
       employeeType = Value(employeeType),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Order> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? orderCode,
    Expression<String>? status,
    Expression<String>? orderType,
    Expression<String>? mealType,
    Expression<double>? total,
    Expression<int>? groupCount,
    Expression<String>? description,
    Expression<int>? orderedById,
    Expression<String>? employeeType,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? syncStatus,
    Expression<String>? syncUpdatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (orderCode != null) 'order_code': orderCode,
      if (status != null) 'status': status,
      if (orderType != null) 'order_type': orderType,
      if (mealType != null) 'meal_type': mealType,
      if (total != null) 'total': total,
      if (groupCount != null) 'group_count': groupCount,
      if (description != null) 'description': description,
      if (orderedById != null) 'ordered_by_id': orderedById,
      if (employeeType != null) 'employee_type': employeeType,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncUpdatedAt != null) 'sync_updated_at': syncUpdatedAt,
    });
  }

  OrdersCompanion copyWith({
    Value<int>? id,
    Value<String>? uuid,
    Value<String>? orderCode,
    Value<String>? status,
    Value<String>? orderType,
    Value<String>? mealType,
    Value<double>? total,
    Value<int>? groupCount,
    Value<String?>? description,
    Value<int>? orderedById,
    Value<String>? employeeType,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? syncStatus,
    Value<String?>? syncUpdatedAt,
  }) {
    return OrdersCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      orderCode: orderCode ?? this.orderCode,
      status: status ?? this.status,
      orderType: orderType ?? this.orderType,
      mealType: mealType ?? this.mealType,
      total: total ?? this.total,
      groupCount: groupCount ?? this.groupCount,
      description: description ?? this.description,
      orderedById: orderedById ?? this.orderedById,
      employeeType: employeeType ?? this.employeeType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncUpdatedAt: syncUpdatedAt ?? this.syncUpdatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (orderCode.present) {
      map['order_code'] = Variable<String>(orderCode.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (orderType.present) {
      map['order_type'] = Variable<String>(orderType.value);
    }
    if (mealType.present) {
      map['meal_type'] = Variable<String>(mealType.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (groupCount.present) {
      map['group_count'] = Variable<int>(groupCount.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (orderedById.present) {
      map['ordered_by_id'] = Variable<int>(orderedById.value);
    }
    if (employeeType.present) {
      map['employee_type'] = Variable<String>(employeeType.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (syncUpdatedAt.present) {
      map['sync_updated_at'] = Variable<String>(syncUpdatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdersCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('orderCode: $orderCode, ')
          ..write('status: $status, ')
          ..write('orderType: $orderType, ')
          ..write('mealType: $mealType, ')
          ..write('total: $total, ')
          ..write('groupCount: $groupCount, ')
          ..write('description: $description, ')
          ..write('orderedById: $orderedById, ')
          ..write('employeeType: $employeeType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt')
          ..write(')'))
        .toString();
  }
}

class $PosDevicesTable extends PosDevices
    with TableInfo<$PosDevicesTable, PosDevice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PosDevicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serialNumberMeta = const VerificationMeta(
    'serialNumber',
  );
  @override
  late final GeneratedColumn<String> serialNumber = GeneratedColumn<String>(
    'serial_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _macAddressMeta = const VerificationMeta(
    'macAddress',
  );
  @override
  late final GeneratedColumn<String> macAddress = GeneratedColumn<String>(
    'mac_address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kitchenIdMeta = const VerificationMeta(
    'kitchenId',
  );
  @override
  late final GeneratedColumn<int> kitchenId = GeneratedColumn<int>(
    'kitchen_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kitchenNameMeta = const VerificationMeta(
    'kitchenName',
  );
  @override
  late final GeneratedColumn<String> kitchenName = GeneratedColumn<String>(
    'kitchen_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncUpdatedAtMeta = const VerificationMeta(
    'syncUpdatedAt',
  );
  @override
  late final GeneratedColumn<String> syncUpdatedAt = GeneratedColumn<String>(
    'sync_updated_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    serialNumber,
    model,
    status,
    macAddress,
    kitchenId,
    kitchenName,
    createdAt,
    updatedAt,
    syncStatus,
    syncUpdatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pos_devices';
  @override
  VerificationContext validateIntegrity(
    Insertable<PosDevice> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('serial_number')) {
      context.handle(
        _serialNumberMeta,
        serialNumber.isAcceptableOrUnknown(
          data['serial_number']!,
          _serialNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serialNumberMeta);
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('mac_address')) {
      context.handle(
        _macAddressMeta,
        macAddress.isAcceptableOrUnknown(data['mac_address']!, _macAddressMeta),
      );
    }
    if (data.containsKey('kitchen_id')) {
      context.handle(
        _kitchenIdMeta,
        kitchenId.isAcceptableOrUnknown(data['kitchen_id']!, _kitchenIdMeta),
      );
    }
    if (data.containsKey('kitchen_name')) {
      context.handle(
        _kitchenNameMeta,
        kitchenName.isAcceptableOrUnknown(
          data['kitchen_name']!,
          _kitchenNameMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('sync_updated_at')) {
      context.handle(
        _syncUpdatedAtMeta,
        syncUpdatedAt.isAcceptableOrUnknown(
          data['sync_updated_at']!,
          _syncUpdatedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PosDevice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PosDevice(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      serialNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}serial_number'],
      )!,
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      macAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mac_address'],
      ),
      kitchenId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kitchen_id'],
      ),
      kitchenName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kitchen_name'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
      syncUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_updated_at'],
      ),
    );
  }

  @override
  $PosDevicesTable createAlias(String alias) {
    return $PosDevicesTable(attachedDatabase, alias);
  }
}

class PosDevice extends DataClass implements Insertable<PosDevice> {
  final int id;
  final String name;
  final String serialNumber;
  final String? model;
  final String status;
  final String? macAddress;
  final int? kitchenId;
  final String? kitchenName;
  final String createdAt;
  final String updatedAt;
  final int syncStatus;
  final String? syncUpdatedAt;
  const PosDevice({
    required this.id,
    required this.name,
    required this.serialNumber,
    this.model,
    required this.status,
    this.macAddress,
    this.kitchenId,
    this.kitchenName,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    this.syncUpdatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['serial_number'] = Variable<String>(serialNumber);
    if (!nullToAbsent || model != null) {
      map['model'] = Variable<String>(model);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || macAddress != null) {
      map['mac_address'] = Variable<String>(macAddress);
    }
    if (!nullToAbsent || kitchenId != null) {
      map['kitchen_id'] = Variable<int>(kitchenId);
    }
    if (!nullToAbsent || kitchenName != null) {
      map['kitchen_name'] = Variable<String>(kitchenName);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    map['sync_status'] = Variable<int>(syncStatus);
    if (!nullToAbsent || syncUpdatedAt != null) {
      map['sync_updated_at'] = Variable<String>(syncUpdatedAt);
    }
    return map;
  }

  PosDevicesCompanion toCompanion(bool nullToAbsent) {
    return PosDevicesCompanion(
      id: Value(id),
      name: Value(name),
      serialNumber: Value(serialNumber),
      model: model == null && nullToAbsent
          ? const Value.absent()
          : Value(model),
      status: Value(status),
      macAddress: macAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(macAddress),
      kitchenId: kitchenId == null && nullToAbsent
          ? const Value.absent()
          : Value(kitchenId),
      kitchenName: kitchenName == null && nullToAbsent
          ? const Value.absent()
          : Value(kitchenName),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      syncUpdatedAt: syncUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdatedAt),
    );
  }

  factory PosDevice.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PosDevice(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      serialNumber: serializer.fromJson<String>(json['serialNumber']),
      model: serializer.fromJson<String?>(json['model']),
      status: serializer.fromJson<String>(json['status']),
      macAddress: serializer.fromJson<String?>(json['macAddress']),
      kitchenId: serializer.fromJson<int?>(json['kitchenId']),
      kitchenName: serializer.fromJson<String?>(json['kitchenName']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      syncUpdatedAt: serializer.fromJson<String?>(json['syncUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'serialNumber': serializer.toJson<String>(serialNumber),
      'model': serializer.toJson<String?>(model),
      'status': serializer.toJson<String>(status),
      'macAddress': serializer.toJson<String?>(macAddress),
      'kitchenId': serializer.toJson<int?>(kitchenId),
      'kitchenName': serializer.toJson<String?>(kitchenName),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'syncUpdatedAt': serializer.toJson<String?>(syncUpdatedAt),
    };
  }

  PosDevice copyWith({
    int? id,
    String? name,
    String? serialNumber,
    Value<String?> model = const Value.absent(),
    String? status,
    Value<String?> macAddress = const Value.absent(),
    Value<int?> kitchenId = const Value.absent(),
    Value<String?> kitchenName = const Value.absent(),
    String? createdAt,
    String? updatedAt,
    int? syncStatus,
    Value<String?> syncUpdatedAt = const Value.absent(),
  }) => PosDevice(
    id: id ?? this.id,
    name: name ?? this.name,
    serialNumber: serialNumber ?? this.serialNumber,
    model: model.present ? model.value : this.model,
    status: status ?? this.status,
    macAddress: macAddress.present ? macAddress.value : this.macAddress,
    kitchenId: kitchenId.present ? kitchenId.value : this.kitchenId,
    kitchenName: kitchenName.present ? kitchenName.value : this.kitchenName,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    syncUpdatedAt: syncUpdatedAt.present
        ? syncUpdatedAt.value
        : this.syncUpdatedAt,
  );
  PosDevice copyWithCompanion(PosDevicesCompanion data) {
    return PosDevice(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      serialNumber: data.serialNumber.present
          ? data.serialNumber.value
          : this.serialNumber,
      model: data.model.present ? data.model.value : this.model,
      status: data.status.present ? data.status.value : this.status,
      macAddress: data.macAddress.present
          ? data.macAddress.value
          : this.macAddress,
      kitchenId: data.kitchenId.present ? data.kitchenId.value : this.kitchenId,
      kitchenName: data.kitchenName.present
          ? data.kitchenName.value
          : this.kitchenName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncUpdatedAt: data.syncUpdatedAt.present
          ? data.syncUpdatedAt.value
          : this.syncUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PosDevice(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('serialNumber: $serialNumber, ')
          ..write('model: $model, ')
          ..write('status: $status, ')
          ..write('macAddress: $macAddress, ')
          ..write('kitchenId: $kitchenId, ')
          ..write('kitchenName: $kitchenName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    serialNumber,
    model,
    status,
    macAddress,
    kitchenId,
    kitchenName,
    createdAt,
    updatedAt,
    syncStatus,
    syncUpdatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PosDevice &&
          other.id == this.id &&
          other.name == this.name &&
          other.serialNumber == this.serialNumber &&
          other.model == this.model &&
          other.status == this.status &&
          other.macAddress == this.macAddress &&
          other.kitchenId == this.kitchenId &&
          other.kitchenName == this.kitchenName &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.syncUpdatedAt == this.syncUpdatedAt);
}

class PosDevicesCompanion extends UpdateCompanion<PosDevice> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> serialNumber;
  final Value<String?> model;
  final Value<String> status;
  final Value<String?> macAddress;
  final Value<int?> kitchenId;
  final Value<String?> kitchenName;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> syncStatus;
  final Value<String?> syncUpdatedAt;
  const PosDevicesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.serialNumber = const Value.absent(),
    this.model = const Value.absent(),
    this.status = const Value.absent(),
    this.macAddress = const Value.absent(),
    this.kitchenId = const Value.absent(),
    this.kitchenName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
  });
  PosDevicesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String serialNumber,
    this.model = const Value.absent(),
    required String status,
    this.macAddress = const Value.absent(),
    this.kitchenId = const Value.absent(),
    this.kitchenName = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
  }) : name = Value(name),
       serialNumber = Value(serialNumber),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PosDevice> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? serialNumber,
    Expression<String>? model,
    Expression<String>? status,
    Expression<String>? macAddress,
    Expression<int>? kitchenId,
    Expression<String>? kitchenName,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? syncStatus,
    Expression<String>? syncUpdatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (serialNumber != null) 'serial_number': serialNumber,
      if (model != null) 'model': model,
      if (status != null) 'status': status,
      if (macAddress != null) 'mac_address': macAddress,
      if (kitchenId != null) 'kitchen_id': kitchenId,
      if (kitchenName != null) 'kitchen_name': kitchenName,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncUpdatedAt != null) 'sync_updated_at': syncUpdatedAt,
    });
  }

  PosDevicesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? serialNumber,
    Value<String?>? model,
    Value<String>? status,
    Value<String?>? macAddress,
    Value<int?>? kitchenId,
    Value<String?>? kitchenName,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? syncStatus,
    Value<String?>? syncUpdatedAt,
  }) {
    return PosDevicesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      serialNumber: serialNumber ?? this.serialNumber,
      model: model ?? this.model,
      status: status ?? this.status,
      macAddress: macAddress ?? this.macAddress,
      kitchenId: kitchenId ?? this.kitchenId,
      kitchenName: kitchenName ?? this.kitchenName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncUpdatedAt: syncUpdatedAt ?? this.syncUpdatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (serialNumber.present) {
      map['serial_number'] = Variable<String>(serialNumber.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (macAddress.present) {
      map['mac_address'] = Variable<String>(macAddress.value);
    }
    if (kitchenId.present) {
      map['kitchen_id'] = Variable<int>(kitchenId.value);
    }
    if (kitchenName.present) {
      map['kitchen_name'] = Variable<String>(kitchenName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (syncUpdatedAt.present) {
      map['sync_updated_at'] = Variable<String>(syncUpdatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PosDevicesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('serialNumber: $serialNumber, ')
          ..write('model: $model, ')
          ..write('status: $status, ')
          ..write('macAddress: $macAddress, ')
          ..write('kitchenId: $kitchenId, ')
          ..write('kitchenName: $kitchenName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt')
          ..write(')'))
        .toString();
  }
}

class $ActivityLogsTable extends ActivityLogs
    with TableInfo<$ActivityLogsTable, ActivityLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actorTypeMeta = const VerificationMeta(
    'actorType',
  );
  @override
  late final GeneratedColumn<String> actorType = GeneratedColumn<String>(
    'actor_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actorIdMeta = const VerificationMeta(
    'actorId',
  );
  @override
  late final GeneratedColumn<int> actorId = GeneratedColumn<int>(
    'actor_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actorNameMeta = const VerificationMeta(
    'actorName',
  );
  @override
  late final GeneratedColumn<String> actorName = GeneratedColumn<String>(
    'actor_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceTableMeta = const VerificationMeta(
    'sourceTable',
  );
  @override
  late final GeneratedColumn<String> sourceTable = GeneratedColumn<String>(
    'source_table',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recordIdMeta = const VerificationMeta(
    'recordId',
  );
  @override
  late final GeneratedColumn<String> recordId = GeneratedColumn<String>(
    'record_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _metadataMeta = const VerificationMeta(
    'metadata',
  );
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
    'metadata',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    message,
    actorType,
    actorId,
    actorName,
    sourceTable,
    recordId,
    metadata,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('actor_type')) {
      context.handle(
        _actorTypeMeta,
        actorType.isAcceptableOrUnknown(data['actor_type']!, _actorTypeMeta),
      );
    }
    if (data.containsKey('actor_id')) {
      context.handle(
        _actorIdMeta,
        actorId.isAcceptableOrUnknown(data['actor_id']!, _actorIdMeta),
      );
    }
    if (data.containsKey('actor_name')) {
      context.handle(
        _actorNameMeta,
        actorName.isAcceptableOrUnknown(data['actor_name']!, _actorNameMeta),
      );
    }
    if (data.containsKey('source_table')) {
      context.handle(
        _sourceTableMeta,
        sourceTable.isAcceptableOrUnknown(
          data['source_table']!,
          _sourceTableMeta,
        ),
      );
    }
    if (data.containsKey('record_id')) {
      context.handle(
        _recordIdMeta,
        recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta),
      );
    }
    if (data.containsKey('metadata')) {
      context.handle(
        _metadataMeta,
        metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActivityLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      )!,
      actorType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actor_type'],
      ),
      actorId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}actor_id'],
      ),
      actorName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actor_name'],
      ),
      sourceTable: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_table'],
      ),
      recordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_id'],
      ),
      metadata: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ActivityLogsTable createAlias(String alias) {
    return $ActivityLogsTable(attachedDatabase, alias);
  }
}

class ActivityLog extends DataClass implements Insertable<ActivityLog> {
  final int id;
  final String type;
  final String message;
  final String? actorType;
  final int? actorId;
  final String? actorName;
  final String? sourceTable;
  final String? recordId;
  final String? metadata;
  final String createdAt;
  const ActivityLog({
    required this.id,
    required this.type,
    required this.message,
    this.actorType,
    this.actorId,
    this.actorName,
    this.sourceTable,
    this.recordId,
    this.metadata,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    map['message'] = Variable<String>(message);
    if (!nullToAbsent || actorType != null) {
      map['actor_type'] = Variable<String>(actorType);
    }
    if (!nullToAbsent || actorId != null) {
      map['actor_id'] = Variable<int>(actorId);
    }
    if (!nullToAbsent || actorName != null) {
      map['actor_name'] = Variable<String>(actorName);
    }
    if (!nullToAbsent || sourceTable != null) {
      map['source_table'] = Variable<String>(sourceTable);
    }
    if (!nullToAbsent || recordId != null) {
      map['record_id'] = Variable<String>(recordId);
    }
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(metadata);
    }
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  ActivityLogsCompanion toCompanion(bool nullToAbsent) {
    return ActivityLogsCompanion(
      id: Value(id),
      type: Value(type),
      message: Value(message),
      actorType: actorType == null && nullToAbsent
          ? const Value.absent()
          : Value(actorType),
      actorId: actorId == null && nullToAbsent
          ? const Value.absent()
          : Value(actorId),
      actorName: actorName == null && nullToAbsent
          ? const Value.absent()
          : Value(actorName),
      sourceTable: sourceTable == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceTable),
      recordId: recordId == null && nullToAbsent
          ? const Value.absent()
          : Value(recordId),
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
      createdAt: Value(createdAt),
    );
  }

  factory ActivityLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityLog(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      message: serializer.fromJson<String>(json['message']),
      actorType: serializer.fromJson<String?>(json['actorType']),
      actorId: serializer.fromJson<int?>(json['actorId']),
      actorName: serializer.fromJson<String?>(json['actorName']),
      sourceTable: serializer.fromJson<String?>(json['sourceTable']),
      recordId: serializer.fromJson<String?>(json['recordId']),
      metadata: serializer.fromJson<String?>(json['metadata']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'message': serializer.toJson<String>(message),
      'actorType': serializer.toJson<String?>(actorType),
      'actorId': serializer.toJson<int?>(actorId),
      'actorName': serializer.toJson<String?>(actorName),
      'sourceTable': serializer.toJson<String?>(sourceTable),
      'recordId': serializer.toJson<String?>(recordId),
      'metadata': serializer.toJson<String?>(metadata),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  ActivityLog copyWith({
    int? id,
    String? type,
    String? message,
    Value<String?> actorType = const Value.absent(),
    Value<int?> actorId = const Value.absent(),
    Value<String?> actorName = const Value.absent(),
    Value<String?> sourceTable = const Value.absent(),
    Value<String?> recordId = const Value.absent(),
    Value<String?> metadata = const Value.absent(),
    String? createdAt,
  }) => ActivityLog(
    id: id ?? this.id,
    type: type ?? this.type,
    message: message ?? this.message,
    actorType: actorType.present ? actorType.value : this.actorType,
    actorId: actorId.present ? actorId.value : this.actorId,
    actorName: actorName.present ? actorName.value : this.actorName,
    sourceTable: sourceTable.present ? sourceTable.value : this.sourceTable,
    recordId: recordId.present ? recordId.value : this.recordId,
    metadata: metadata.present ? metadata.value : this.metadata,
    createdAt: createdAt ?? this.createdAt,
  );
  ActivityLog copyWithCompanion(ActivityLogsCompanion data) {
    return ActivityLog(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      message: data.message.present ? data.message.value : this.message,
      actorType: data.actorType.present ? data.actorType.value : this.actorType,
      actorId: data.actorId.present ? data.actorId.value : this.actorId,
      actorName: data.actorName.present ? data.actorName.value : this.actorName,
      sourceTable: data.sourceTable.present
          ? data.sourceTable.value
          : this.sourceTable,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityLog(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('message: $message, ')
          ..write('actorType: $actorType, ')
          ..write('actorId: $actorId, ')
          ..write('actorName: $actorName, ')
          ..write('sourceTable: $sourceTable, ')
          ..write('recordId: $recordId, ')
          ..write('metadata: $metadata, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    message,
    actorType,
    actorId,
    actorName,
    sourceTable,
    recordId,
    metadata,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityLog &&
          other.id == this.id &&
          other.type == this.type &&
          other.message == this.message &&
          other.actorType == this.actorType &&
          other.actorId == this.actorId &&
          other.actorName == this.actorName &&
          other.sourceTable == this.sourceTable &&
          other.recordId == this.recordId &&
          other.metadata == this.metadata &&
          other.createdAt == this.createdAt);
}

class ActivityLogsCompanion extends UpdateCompanion<ActivityLog> {
  final Value<int> id;
  final Value<String> type;
  final Value<String> message;
  final Value<String?> actorType;
  final Value<int?> actorId;
  final Value<String?> actorName;
  final Value<String?> sourceTable;
  final Value<String?> recordId;
  final Value<String?> metadata;
  final Value<String> createdAt;
  const ActivityLogsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.message = const Value.absent(),
    this.actorType = const Value.absent(),
    this.actorId = const Value.absent(),
    this.actorName = const Value.absent(),
    this.sourceTable = const Value.absent(),
    this.recordId = const Value.absent(),
    this.metadata = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ActivityLogsCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    required String message,
    this.actorType = const Value.absent(),
    this.actorId = const Value.absent(),
    this.actorName = const Value.absent(),
    this.sourceTable = const Value.absent(),
    this.recordId = const Value.absent(),
    this.metadata = const Value.absent(),
    required String createdAt,
  }) : type = Value(type),
       message = Value(message),
       createdAt = Value(createdAt);
  static Insertable<ActivityLog> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<String>? message,
    Expression<String>? actorType,
    Expression<int>? actorId,
    Expression<String>? actorName,
    Expression<String>? sourceTable,
    Expression<String>? recordId,
    Expression<String>? metadata,
    Expression<String>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (message != null) 'message': message,
      if (actorType != null) 'actor_type': actorType,
      if (actorId != null) 'actor_id': actorId,
      if (actorName != null) 'actor_name': actorName,
      if (sourceTable != null) 'source_table': sourceTable,
      if (recordId != null) 'record_id': recordId,
      if (metadata != null) 'metadata': metadata,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ActivityLogsCompanion copyWith({
    Value<int>? id,
    Value<String>? type,
    Value<String>? message,
    Value<String?>? actorType,
    Value<int?>? actorId,
    Value<String?>? actorName,
    Value<String?>? sourceTable,
    Value<String?>? recordId,
    Value<String?>? metadata,
    Value<String>? createdAt,
  }) {
    return ActivityLogsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      message: message ?? this.message,
      actorType: actorType ?? this.actorType,
      actorId: actorId ?? this.actorId,
      actorName: actorName ?? this.actorName,
      sourceTable: sourceTable ?? this.sourceTable,
      recordId: recordId ?? this.recordId,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (actorType.present) {
      map['actor_type'] = Variable<String>(actorType.value);
    }
    if (actorId.present) {
      map['actor_id'] = Variable<int>(actorId.value);
    }
    if (actorName.present) {
      map['actor_name'] = Variable<String>(actorName.value);
    }
    if (sourceTable.present) {
      map['source_table'] = Variable<String>(sourceTable.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<String>(recordId.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityLogsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('message: $message, ')
          ..write('actorType: $actorType, ')
          ..write('actorId: $actorId, ')
          ..write('actorName: $actorName, ')
          ..write('sourceTable: $sourceTable, ')
          ..write('recordId: $recordId, ')
          ..write('metadata: $metadata, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $GroupOrdersTable extends GroupOrders
    with TableInfo<$GroupOrdersTable, GroupOrder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupOrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderCodeMeta = const VerificationMeta(
    'orderCode',
  );
  @override
  late final GeneratedColumn<String> orderCode = GeneratedColumn<String>(
    'order_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderTypeMeta = const VerificationMeta(
    'orderType',
  );
  @override
  late final GeneratedColumn<String> orderType = GeneratedColumn<String>(
    'order_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mealTypeMeta = const VerificationMeta(
    'mealType',
  );
  @override
  late final GeneratedColumn<String> mealType = GeneratedColumn<String>(
    'meal_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupCountMeta = const VerificationMeta(
    'groupCount',
  );
  @override
  late final GeneratedColumn<int> groupCount = GeneratedColumn<int>(
    'group_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncUpdatedAtMeta = const VerificationMeta(
    'syncUpdatedAt',
  );
  @override
  late final GeneratedColumn<String> syncUpdatedAt = GeneratedColumn<String>(
    'sync_updated_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    uuid,
    orderCode,
    status,
    orderType,
    mealType,
    total,
    groupCount,
    description,
    createdAt,
    updatedAt,
    syncStatus,
    syncUpdatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'group_orders';
  @override
  VerificationContext validateIntegrity(
    Insertable<GroupOrder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('order_code')) {
      context.handle(
        _orderCodeMeta,
        orderCode.isAcceptableOrUnknown(data['order_code']!, _orderCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_orderCodeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('order_type')) {
      context.handle(
        _orderTypeMeta,
        orderType.isAcceptableOrUnknown(data['order_type']!, _orderTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_orderTypeMeta);
    }
    if (data.containsKey('meal_type')) {
      context.handle(
        _mealTypeMeta,
        mealType.isAcceptableOrUnknown(data['meal_type']!, _mealTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mealTypeMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('group_count')) {
      context.handle(
        _groupCountMeta,
        groupCount.isAcceptableOrUnknown(data['group_count']!, _groupCountMeta),
      );
    } else if (isInserting) {
      context.missing(_groupCountMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('sync_updated_at')) {
      context.handle(
        _syncUpdatedAtMeta,
        syncUpdatedAt.isAcceptableOrUnknown(
          data['sync_updated_at']!,
          _syncUpdatedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GroupOrder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupOrder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      orderCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_code'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      orderType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_type'],
      )!,
      mealType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_type'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total'],
      )!,
      groupCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}group_count'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
      syncUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_updated_at'],
      ),
    );
  }

  @override
  $GroupOrdersTable createAlias(String alias) {
    return $GroupOrdersTable(attachedDatabase, alias);
  }
}

class GroupOrder extends DataClass implements Insertable<GroupOrder> {
  final int id;
  final String uuid;
  final String orderCode;
  final String status;
  final String orderType;
  final String mealType;
  final double total;
  final int groupCount;
  final String? description;
  final String createdAt;
  final String updatedAt;
  final int syncStatus;
  final String? syncUpdatedAt;
  const GroupOrder({
    required this.id,
    required this.uuid,
    required this.orderCode,
    required this.status,
    required this.orderType,
    required this.mealType,
    required this.total,
    required this.groupCount,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    this.syncUpdatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['order_code'] = Variable<String>(orderCode);
    map['status'] = Variable<String>(status);
    map['order_type'] = Variable<String>(orderType);
    map['meal_type'] = Variable<String>(mealType);
    map['total'] = Variable<double>(total);
    map['group_count'] = Variable<int>(groupCount);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    map['sync_status'] = Variable<int>(syncStatus);
    if (!nullToAbsent || syncUpdatedAt != null) {
      map['sync_updated_at'] = Variable<String>(syncUpdatedAt);
    }
    return map;
  }

  GroupOrdersCompanion toCompanion(bool nullToAbsent) {
    return GroupOrdersCompanion(
      id: Value(id),
      uuid: Value(uuid),
      orderCode: Value(orderCode),
      status: Value(status),
      orderType: Value(orderType),
      mealType: Value(mealType),
      total: Value(total),
      groupCount: Value(groupCount),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      syncUpdatedAt: syncUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdatedAt),
    );
  }

  factory GroupOrder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupOrder(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      orderCode: serializer.fromJson<String>(json['orderCode']),
      status: serializer.fromJson<String>(json['status']),
      orderType: serializer.fromJson<String>(json['orderType']),
      mealType: serializer.fromJson<String>(json['mealType']),
      total: serializer.fromJson<double>(json['total']),
      groupCount: serializer.fromJson<int>(json['groupCount']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      syncUpdatedAt: serializer.fromJson<String?>(json['syncUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'orderCode': serializer.toJson<String>(orderCode),
      'status': serializer.toJson<String>(status),
      'orderType': serializer.toJson<String>(orderType),
      'mealType': serializer.toJson<String>(mealType),
      'total': serializer.toJson<double>(total),
      'groupCount': serializer.toJson<int>(groupCount),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'syncUpdatedAt': serializer.toJson<String?>(syncUpdatedAt),
    };
  }

  GroupOrder copyWith({
    int? id,
    String? uuid,
    String? orderCode,
    String? status,
    String? orderType,
    String? mealType,
    double? total,
    int? groupCount,
    Value<String?> description = const Value.absent(),
    String? createdAt,
    String? updatedAt,
    int? syncStatus,
    Value<String?> syncUpdatedAt = const Value.absent(),
  }) => GroupOrder(
    id: id ?? this.id,
    uuid: uuid ?? this.uuid,
    orderCode: orderCode ?? this.orderCode,
    status: status ?? this.status,
    orderType: orderType ?? this.orderType,
    mealType: mealType ?? this.mealType,
    total: total ?? this.total,
    groupCount: groupCount ?? this.groupCount,
    description: description.present ? description.value : this.description,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    syncUpdatedAt: syncUpdatedAt.present
        ? syncUpdatedAt.value
        : this.syncUpdatedAt,
  );
  GroupOrder copyWithCompanion(GroupOrdersCompanion data) {
    return GroupOrder(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      orderCode: data.orderCode.present ? data.orderCode.value : this.orderCode,
      status: data.status.present ? data.status.value : this.status,
      orderType: data.orderType.present ? data.orderType.value : this.orderType,
      mealType: data.mealType.present ? data.mealType.value : this.mealType,
      total: data.total.present ? data.total.value : this.total,
      groupCount: data.groupCount.present
          ? data.groupCount.value
          : this.groupCount,
      description: data.description.present
          ? data.description.value
          : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncUpdatedAt: data.syncUpdatedAt.present
          ? data.syncUpdatedAt.value
          : this.syncUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupOrder(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('orderCode: $orderCode, ')
          ..write('status: $status, ')
          ..write('orderType: $orderType, ')
          ..write('mealType: $mealType, ')
          ..write('total: $total, ')
          ..write('groupCount: $groupCount, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    uuid,
    orderCode,
    status,
    orderType,
    mealType,
    total,
    groupCount,
    description,
    createdAt,
    updatedAt,
    syncStatus,
    syncUpdatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupOrder &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.orderCode == this.orderCode &&
          other.status == this.status &&
          other.orderType == this.orderType &&
          other.mealType == this.mealType &&
          other.total == this.total &&
          other.groupCount == this.groupCount &&
          other.description == this.description &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.syncUpdatedAt == this.syncUpdatedAt);
}

class GroupOrdersCompanion extends UpdateCompanion<GroupOrder> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> orderCode;
  final Value<String> status;
  final Value<String> orderType;
  final Value<String> mealType;
  final Value<double> total;
  final Value<int> groupCount;
  final Value<String?> description;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> syncStatus;
  final Value<String?> syncUpdatedAt;
  const GroupOrdersCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.orderCode = const Value.absent(),
    this.status = const Value.absent(),
    this.orderType = const Value.absent(),
    this.mealType = const Value.absent(),
    this.total = const Value.absent(),
    this.groupCount = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
  });
  GroupOrdersCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required String orderCode,
    required String status,
    required String orderType,
    required String mealType,
    required double total,
    required int groupCount,
    this.description = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
  }) : uuid = Value(uuid),
       orderCode = Value(orderCode),
       status = Value(status),
       orderType = Value(orderType),
       mealType = Value(mealType),
       total = Value(total),
       groupCount = Value(groupCount),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<GroupOrder> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? orderCode,
    Expression<String>? status,
    Expression<String>? orderType,
    Expression<String>? mealType,
    Expression<double>? total,
    Expression<int>? groupCount,
    Expression<String>? description,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? syncStatus,
    Expression<String>? syncUpdatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (orderCode != null) 'order_code': orderCode,
      if (status != null) 'status': status,
      if (orderType != null) 'order_type': orderType,
      if (mealType != null) 'meal_type': mealType,
      if (total != null) 'total': total,
      if (groupCount != null) 'group_count': groupCount,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncUpdatedAt != null) 'sync_updated_at': syncUpdatedAt,
    });
  }

  GroupOrdersCompanion copyWith({
    Value<int>? id,
    Value<String>? uuid,
    Value<String>? orderCode,
    Value<String>? status,
    Value<String>? orderType,
    Value<String>? mealType,
    Value<double>? total,
    Value<int>? groupCount,
    Value<String?>? description,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? syncStatus,
    Value<String?>? syncUpdatedAt,
  }) {
    return GroupOrdersCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      orderCode: orderCode ?? this.orderCode,
      status: status ?? this.status,
      orderType: orderType ?? this.orderType,
      mealType: mealType ?? this.mealType,
      total: total ?? this.total,
      groupCount: groupCount ?? this.groupCount,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncUpdatedAt: syncUpdatedAt ?? this.syncUpdatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (orderCode.present) {
      map['order_code'] = Variable<String>(orderCode.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (orderType.present) {
      map['order_type'] = Variable<String>(orderType.value);
    }
    if (mealType.present) {
      map['meal_type'] = Variable<String>(mealType.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (groupCount.present) {
      map['group_count'] = Variable<int>(groupCount.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (syncUpdatedAt.present) {
      map['sync_updated_at'] = Variable<String>(syncUpdatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupOrdersCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('orderCode: $orderCode, ')
          ..write('status: $status, ')
          ..write('orderType: $orderType, ')
          ..write('mealType: $mealType, ')
          ..write('total: $total, ')
          ..write('groupCount: $groupCount, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt')
          ..write(')'))
        .toString();
  }
}

class $ContractorsTable extends Contractors
    with TableInfo<$ContractorsTable, Contractor> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContractorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noOfStaffsMeta = const VerificationMeta(
    'noOfStaffs',
  );
  @override
  late final GeneratedColumn<int> noOfStaffs = GeneratedColumn<int>(
    'no_of_staffs',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _companyIdMeta = const VerificationMeta(
    'companyId',
  );
  @override
  late final GeneratedColumn<int> companyId = GeneratedColumn<int>(
    'company_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _departmentIdMeta = const VerificationMeta(
    'departmentId',
  );
  @override
  late final GeneratedColumn<int> departmentId = GeneratedColumn<int>(
    'department_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _companyMeta = const VerificationMeta(
    'company',
  );
  @override
  late final GeneratedColumn<String> company = GeneratedColumn<String>(
    'company',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _departmentMeta = const VerificationMeta(
    'department',
  );
  @override
  late final GeneratedColumn<String> department = GeneratedColumn<String>(
    'department',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncUpdatedAtMeta = const VerificationMeta(
    'syncUpdatedAt',
  );
  @override
  late final GeneratedColumn<String> syncUpdatedAt = GeneratedColumn<String>(
    'sync_updated_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    status,
    noOfStaffs,
    companyId,
    departmentId,
    company,
    department,
    syncStatus,
    syncUpdatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contractors';
  @override
  VerificationContext validateIntegrity(
    Insertable<Contractor> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('no_of_staffs')) {
      context.handle(
        _noOfStaffsMeta,
        noOfStaffs.isAcceptableOrUnknown(
          data['no_of_staffs']!,
          _noOfStaffsMeta,
        ),
      );
    }
    if (data.containsKey('company_id')) {
      context.handle(
        _companyIdMeta,
        companyId.isAcceptableOrUnknown(data['company_id']!, _companyIdMeta),
      );
    }
    if (data.containsKey('department_id')) {
      context.handle(
        _departmentIdMeta,
        departmentId.isAcceptableOrUnknown(
          data['department_id']!,
          _departmentIdMeta,
        ),
      );
    }
    if (data.containsKey('company')) {
      context.handle(
        _companyMeta,
        company.isAcceptableOrUnknown(data['company']!, _companyMeta),
      );
    }
    if (data.containsKey('department')) {
      context.handle(
        _departmentMeta,
        department.isAcceptableOrUnknown(data['department']!, _departmentMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('sync_updated_at')) {
      context.handle(
        _syncUpdatedAtMeta,
        syncUpdatedAt.isAcceptableOrUnknown(
          data['sync_updated_at']!,
          _syncUpdatedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Contractor map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Contractor(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      noOfStaffs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}no_of_staffs'],
      )!,
      companyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}company_id'],
      ),
      departmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}department_id'],
      ),
      company: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company'],
      ),
      department: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}department'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
      syncUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_updated_at'],
      ),
    );
  }

  @override
  $ContractorsTable createAlias(String alias) {
    return $ContractorsTable(attachedDatabase, alias);
  }
}

class Contractor extends DataClass implements Insertable<Contractor> {
  final int id;
  final String name;
  final String status;
  final int noOfStaffs;
  final int? companyId;
  final int? departmentId;
  final String? company;
  final String? department;
  final int syncStatus;
  final String? syncUpdatedAt;
  const Contractor({
    required this.id,
    required this.name,
    required this.status,
    required this.noOfStaffs,
    this.companyId,
    this.departmentId,
    this.company,
    this.department,
    required this.syncStatus,
    this.syncUpdatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['status'] = Variable<String>(status);
    map['no_of_staffs'] = Variable<int>(noOfStaffs);
    if (!nullToAbsent || companyId != null) {
      map['company_id'] = Variable<int>(companyId);
    }
    if (!nullToAbsent || departmentId != null) {
      map['department_id'] = Variable<int>(departmentId);
    }
    if (!nullToAbsent || company != null) {
      map['company'] = Variable<String>(company);
    }
    if (!nullToAbsent || department != null) {
      map['department'] = Variable<String>(department);
    }
    map['sync_status'] = Variable<int>(syncStatus);
    if (!nullToAbsent || syncUpdatedAt != null) {
      map['sync_updated_at'] = Variable<String>(syncUpdatedAt);
    }
    return map;
  }

  ContractorsCompanion toCompanion(bool nullToAbsent) {
    return ContractorsCompanion(
      id: Value(id),
      name: Value(name),
      status: Value(status),
      noOfStaffs: Value(noOfStaffs),
      companyId: companyId == null && nullToAbsent
          ? const Value.absent()
          : Value(companyId),
      departmentId: departmentId == null && nullToAbsent
          ? const Value.absent()
          : Value(departmentId),
      company: company == null && nullToAbsent
          ? const Value.absent()
          : Value(company),
      department: department == null && nullToAbsent
          ? const Value.absent()
          : Value(department),
      syncStatus: Value(syncStatus),
      syncUpdatedAt: syncUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdatedAt),
    );
  }

  factory Contractor.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Contractor(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      status: serializer.fromJson<String>(json['status']),
      noOfStaffs: serializer.fromJson<int>(json['noOfStaffs']),
      companyId: serializer.fromJson<int?>(json['companyId']),
      departmentId: serializer.fromJson<int?>(json['departmentId']),
      company: serializer.fromJson<String?>(json['company']),
      department: serializer.fromJson<String?>(json['department']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      syncUpdatedAt: serializer.fromJson<String?>(json['syncUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'status': serializer.toJson<String>(status),
      'noOfStaffs': serializer.toJson<int>(noOfStaffs),
      'companyId': serializer.toJson<int?>(companyId),
      'departmentId': serializer.toJson<int?>(departmentId),
      'company': serializer.toJson<String?>(company),
      'department': serializer.toJson<String?>(department),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'syncUpdatedAt': serializer.toJson<String?>(syncUpdatedAt),
    };
  }

  Contractor copyWith({
    int? id,
    String? name,
    String? status,
    int? noOfStaffs,
    Value<int?> companyId = const Value.absent(),
    Value<int?> departmentId = const Value.absent(),
    Value<String?> company = const Value.absent(),
    Value<String?> department = const Value.absent(),
    int? syncStatus,
    Value<String?> syncUpdatedAt = const Value.absent(),
  }) => Contractor(
    id: id ?? this.id,
    name: name ?? this.name,
    status: status ?? this.status,
    noOfStaffs: noOfStaffs ?? this.noOfStaffs,
    companyId: companyId.present ? companyId.value : this.companyId,
    departmentId: departmentId.present ? departmentId.value : this.departmentId,
    company: company.present ? company.value : this.company,
    department: department.present ? department.value : this.department,
    syncStatus: syncStatus ?? this.syncStatus,
    syncUpdatedAt: syncUpdatedAt.present
        ? syncUpdatedAt.value
        : this.syncUpdatedAt,
  );
  Contractor copyWithCompanion(ContractorsCompanion data) {
    return Contractor(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      status: data.status.present ? data.status.value : this.status,
      noOfStaffs: data.noOfStaffs.present
          ? data.noOfStaffs.value
          : this.noOfStaffs,
      companyId: data.companyId.present ? data.companyId.value : this.companyId,
      departmentId: data.departmentId.present
          ? data.departmentId.value
          : this.departmentId,
      company: data.company.present ? data.company.value : this.company,
      department: data.department.present
          ? data.department.value
          : this.department,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncUpdatedAt: data.syncUpdatedAt.present
          ? data.syncUpdatedAt.value
          : this.syncUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Contractor(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('status: $status, ')
          ..write('noOfStaffs: $noOfStaffs, ')
          ..write('companyId: $companyId, ')
          ..write('departmentId: $departmentId, ')
          ..write('company: $company, ')
          ..write('department: $department, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    status,
    noOfStaffs,
    companyId,
    departmentId,
    company,
    department,
    syncStatus,
    syncUpdatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Contractor &&
          other.id == this.id &&
          other.name == this.name &&
          other.status == this.status &&
          other.noOfStaffs == this.noOfStaffs &&
          other.companyId == this.companyId &&
          other.departmentId == this.departmentId &&
          other.company == this.company &&
          other.department == this.department &&
          other.syncStatus == this.syncStatus &&
          other.syncUpdatedAt == this.syncUpdatedAt);
}

class ContractorsCompanion extends UpdateCompanion<Contractor> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> status;
  final Value<int> noOfStaffs;
  final Value<int?> companyId;
  final Value<int?> departmentId;
  final Value<String?> company;
  final Value<String?> department;
  final Value<int> syncStatus;
  final Value<String?> syncUpdatedAt;
  const ContractorsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.status = const Value.absent(),
    this.noOfStaffs = const Value.absent(),
    this.companyId = const Value.absent(),
    this.departmentId = const Value.absent(),
    this.company = const Value.absent(),
    this.department = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
  });
  ContractorsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String status,
    this.noOfStaffs = const Value.absent(),
    this.companyId = const Value.absent(),
    this.departmentId = const Value.absent(),
    this.company = const Value.absent(),
    this.department = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
  }) : name = Value(name),
       status = Value(status);
  static Insertable<Contractor> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? status,
    Expression<int>? noOfStaffs,
    Expression<int>? companyId,
    Expression<int>? departmentId,
    Expression<String>? company,
    Expression<String>? department,
    Expression<int>? syncStatus,
    Expression<String>? syncUpdatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (status != null) 'status': status,
      if (noOfStaffs != null) 'no_of_staffs': noOfStaffs,
      if (companyId != null) 'company_id': companyId,
      if (departmentId != null) 'department_id': departmentId,
      if (company != null) 'company': company,
      if (department != null) 'department': department,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncUpdatedAt != null) 'sync_updated_at': syncUpdatedAt,
    });
  }

  ContractorsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? status,
    Value<int>? noOfStaffs,
    Value<int?>? companyId,
    Value<int?>? departmentId,
    Value<String?>? company,
    Value<String?>? department,
    Value<int>? syncStatus,
    Value<String?>? syncUpdatedAt,
  }) {
    return ContractorsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      noOfStaffs: noOfStaffs ?? this.noOfStaffs,
      companyId: companyId ?? this.companyId,
      departmentId: departmentId ?? this.departmentId,
      company: company ?? this.company,
      department: department ?? this.department,
      syncStatus: syncStatus ?? this.syncStatus,
      syncUpdatedAt: syncUpdatedAt ?? this.syncUpdatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (noOfStaffs.present) {
      map['no_of_staffs'] = Variable<int>(noOfStaffs.value);
    }
    if (companyId.present) {
      map['company_id'] = Variable<int>(companyId.value);
    }
    if (departmentId.present) {
      map['department_id'] = Variable<int>(departmentId.value);
    }
    if (company.present) {
      map['company'] = Variable<String>(company.value);
    }
    if (department.present) {
      map['department'] = Variable<String>(department.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (syncUpdatedAt.present) {
      map['sync_updated_at'] = Variable<String>(syncUpdatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContractorsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('status: $status, ')
          ..write('noOfStaffs: $noOfStaffs, ')
          ..write('companyId: $companyId, ')
          ..write('departmentId: $departmentId, ')
          ..write('company: $company, ')
          ..write('department: $department, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt')
          ..write(')'))
        .toString();
  }
}

class $ContractorStaffTableTable extends ContractorStaffTable
    with TableInfo<$ContractorStaffTableTable, ContractorStaffTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContractorStaffTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contractorIdMeta = const VerificationMeta(
    'contractorId',
  );
  @override
  late final GeneratedColumn<int> contractorId = GeneratedColumn<int>(
    'contractor_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contractorNameMeta = const VerificationMeta(
    'contractorName',
  );
  @override
  late final GeneratedColumn<String> contractorName = GeneratedColumn<String>(
    'contractor_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _companyIdMeta = const VerificationMeta(
    'companyId',
  );
  @override
  late final GeneratedColumn<int> companyId = GeneratedColumn<int>(
    'company_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _companyMeta = const VerificationMeta(
    'company',
  );
  @override
  late final GeneratedColumn<String> company = GeneratedColumn<String>(
    'company',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _departmentIdMeta = const VerificationMeta(
    'departmentId',
  );
  @override
  late final GeneratedColumn<int> departmentId = GeneratedColumn<int>(
    'department_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _departmentMeta = const VerificationMeta(
    'department',
  );
  @override
  late final GeneratedColumn<String> department = GeneratedColumn<String>(
    'department',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<String> startDate = GeneratedColumn<String>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<String> endDate = GeneratedColumn<String>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isChargedMeta = const VerificationMeta(
    'isCharged',
  );
  @override
  late final GeneratedColumn<bool> isCharged = GeneratedColumn<bool>(
    'is_charged',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_charged" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncUpdatedAtMeta = const VerificationMeta(
    'syncUpdatedAt',
  );
  @override
  late final GeneratedColumn<String> syncUpdatedAt = GeneratedColumn<String>(
    'sync_updated_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    gender,
    contractorId,
    contractorName,
    companyId,
    company,
    departmentId,
    department,
    startDate,
    endDate,
    isCharged,
    syncStatus,
    syncUpdatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contractor_staff_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContractorStaffTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    }
    if (data.containsKey('contractor_id')) {
      context.handle(
        _contractorIdMeta,
        contractorId.isAcceptableOrUnknown(
          data['contractor_id']!,
          _contractorIdMeta,
        ),
      );
    }
    if (data.containsKey('contractor_name')) {
      context.handle(
        _contractorNameMeta,
        contractorName.isAcceptableOrUnknown(
          data['contractor_name']!,
          _contractorNameMeta,
        ),
      );
    }
    if (data.containsKey('company_id')) {
      context.handle(
        _companyIdMeta,
        companyId.isAcceptableOrUnknown(data['company_id']!, _companyIdMeta),
      );
    }
    if (data.containsKey('company')) {
      context.handle(
        _companyMeta,
        company.isAcceptableOrUnknown(data['company']!, _companyMeta),
      );
    }
    if (data.containsKey('department_id')) {
      context.handle(
        _departmentIdMeta,
        departmentId.isAcceptableOrUnknown(
          data['department_id']!,
          _departmentIdMeta,
        ),
      );
    }
    if (data.containsKey('department')) {
      context.handle(
        _departmentMeta,
        department.isAcceptableOrUnknown(data['department']!, _departmentMeta),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('is_charged')) {
      context.handle(
        _isChargedMeta,
        isCharged.isAcceptableOrUnknown(data['is_charged']!, _isChargedMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('sync_updated_at')) {
      context.handle(
        _syncUpdatedAtMeta,
        syncUpdatedAt.isAcceptableOrUnknown(
          data['sync_updated_at']!,
          _syncUpdatedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ContractorStaffTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContractorStaffTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      ),
      contractorId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}contractor_id'],
      ),
      contractorName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contractor_name'],
      ),
      companyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}company_id'],
      ),
      company: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company'],
      ),
      departmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}department_id'],
      ),
      department: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}department'],
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_date'],
      )!,
      isCharged: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_charged'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
      syncUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_updated_at'],
      ),
    );
  }

  @override
  $ContractorStaffTableTable createAlias(String alias) {
    return $ContractorStaffTableTable(attachedDatabase, alias);
  }
}

class ContractorStaffTableData extends DataClass
    implements Insertable<ContractorStaffTableData> {
  final int id;
  final String name;
  final String? gender;
  final int? contractorId;
  final String? contractorName;
  final int? companyId;
  final String? company;
  final int? departmentId;
  final String? department;
  final String startDate;
  final String endDate;
  final bool isCharged;
  final int syncStatus;
  final String? syncUpdatedAt;
  const ContractorStaffTableData({
    required this.id,
    required this.name,
    this.gender,
    this.contractorId,
    this.contractorName,
    this.companyId,
    this.company,
    this.departmentId,
    this.department,
    required this.startDate,
    required this.endDate,
    required this.isCharged,
    required this.syncStatus,
    this.syncUpdatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || contractorId != null) {
      map['contractor_id'] = Variable<int>(contractorId);
    }
    if (!nullToAbsent || contractorName != null) {
      map['contractor_name'] = Variable<String>(contractorName);
    }
    if (!nullToAbsent || companyId != null) {
      map['company_id'] = Variable<int>(companyId);
    }
    if (!nullToAbsent || company != null) {
      map['company'] = Variable<String>(company);
    }
    if (!nullToAbsent || departmentId != null) {
      map['department_id'] = Variable<int>(departmentId);
    }
    if (!nullToAbsent || department != null) {
      map['department'] = Variable<String>(department);
    }
    map['start_date'] = Variable<String>(startDate);
    map['end_date'] = Variable<String>(endDate);
    map['is_charged'] = Variable<bool>(isCharged);
    map['sync_status'] = Variable<int>(syncStatus);
    if (!nullToAbsent || syncUpdatedAt != null) {
      map['sync_updated_at'] = Variable<String>(syncUpdatedAt);
    }
    return map;
  }

  ContractorStaffTableCompanion toCompanion(bool nullToAbsent) {
    return ContractorStaffTableCompanion(
      id: Value(id),
      name: Value(name),
      gender: gender == null && nullToAbsent
          ? const Value.absent()
          : Value(gender),
      contractorId: contractorId == null && nullToAbsent
          ? const Value.absent()
          : Value(contractorId),
      contractorName: contractorName == null && nullToAbsent
          ? const Value.absent()
          : Value(contractorName),
      companyId: companyId == null && nullToAbsent
          ? const Value.absent()
          : Value(companyId),
      company: company == null && nullToAbsent
          ? const Value.absent()
          : Value(company),
      departmentId: departmentId == null && nullToAbsent
          ? const Value.absent()
          : Value(departmentId),
      department: department == null && nullToAbsent
          ? const Value.absent()
          : Value(department),
      startDate: Value(startDate),
      endDate: Value(endDate),
      isCharged: Value(isCharged),
      syncStatus: Value(syncStatus),
      syncUpdatedAt: syncUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdatedAt),
    );
  }

  factory ContractorStaffTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContractorStaffTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      gender: serializer.fromJson<String?>(json['gender']),
      contractorId: serializer.fromJson<int?>(json['contractorId']),
      contractorName: serializer.fromJson<String?>(json['contractorName']),
      companyId: serializer.fromJson<int?>(json['companyId']),
      company: serializer.fromJson<String?>(json['company']),
      departmentId: serializer.fromJson<int?>(json['departmentId']),
      department: serializer.fromJson<String?>(json['department']),
      startDate: serializer.fromJson<String>(json['startDate']),
      endDate: serializer.fromJson<String>(json['endDate']),
      isCharged: serializer.fromJson<bool>(json['isCharged']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      syncUpdatedAt: serializer.fromJson<String?>(json['syncUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'gender': serializer.toJson<String?>(gender),
      'contractorId': serializer.toJson<int?>(contractorId),
      'contractorName': serializer.toJson<String?>(contractorName),
      'companyId': serializer.toJson<int?>(companyId),
      'company': serializer.toJson<String?>(company),
      'departmentId': serializer.toJson<int?>(departmentId),
      'department': serializer.toJson<String?>(department),
      'startDate': serializer.toJson<String>(startDate),
      'endDate': serializer.toJson<String>(endDate),
      'isCharged': serializer.toJson<bool>(isCharged),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'syncUpdatedAt': serializer.toJson<String?>(syncUpdatedAt),
    };
  }

  ContractorStaffTableData copyWith({
    int? id,
    String? name,
    Value<String?> gender = const Value.absent(),
    Value<int?> contractorId = const Value.absent(),
    Value<String?> contractorName = const Value.absent(),
    Value<int?> companyId = const Value.absent(),
    Value<String?> company = const Value.absent(),
    Value<int?> departmentId = const Value.absent(),
    Value<String?> department = const Value.absent(),
    String? startDate,
    String? endDate,
    bool? isCharged,
    int? syncStatus,
    Value<String?> syncUpdatedAt = const Value.absent(),
  }) => ContractorStaffTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    gender: gender.present ? gender.value : this.gender,
    contractorId: contractorId.present ? contractorId.value : this.contractorId,
    contractorName: contractorName.present
        ? contractorName.value
        : this.contractorName,
    companyId: companyId.present ? companyId.value : this.companyId,
    company: company.present ? company.value : this.company,
    departmentId: departmentId.present ? departmentId.value : this.departmentId,
    department: department.present ? department.value : this.department,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    isCharged: isCharged ?? this.isCharged,
    syncStatus: syncStatus ?? this.syncStatus,
    syncUpdatedAt: syncUpdatedAt.present
        ? syncUpdatedAt.value
        : this.syncUpdatedAt,
  );
  ContractorStaffTableData copyWithCompanion(
    ContractorStaffTableCompanion data,
  ) {
    return ContractorStaffTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      gender: data.gender.present ? data.gender.value : this.gender,
      contractorId: data.contractorId.present
          ? data.contractorId.value
          : this.contractorId,
      contractorName: data.contractorName.present
          ? data.contractorName.value
          : this.contractorName,
      companyId: data.companyId.present ? data.companyId.value : this.companyId,
      company: data.company.present ? data.company.value : this.company,
      departmentId: data.departmentId.present
          ? data.departmentId.value
          : this.departmentId,
      department: data.department.present
          ? data.department.value
          : this.department,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      isCharged: data.isCharged.present ? data.isCharged.value : this.isCharged,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncUpdatedAt: data.syncUpdatedAt.present
          ? data.syncUpdatedAt.value
          : this.syncUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContractorStaffTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('gender: $gender, ')
          ..write('contractorId: $contractorId, ')
          ..write('contractorName: $contractorName, ')
          ..write('companyId: $companyId, ')
          ..write('company: $company, ')
          ..write('departmentId: $departmentId, ')
          ..write('department: $department, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('isCharged: $isCharged, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    gender,
    contractorId,
    contractorName,
    companyId,
    company,
    departmentId,
    department,
    startDate,
    endDate,
    isCharged,
    syncStatus,
    syncUpdatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContractorStaffTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.gender == this.gender &&
          other.contractorId == this.contractorId &&
          other.contractorName == this.contractorName &&
          other.companyId == this.companyId &&
          other.company == this.company &&
          other.departmentId == this.departmentId &&
          other.department == this.department &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.isCharged == this.isCharged &&
          other.syncStatus == this.syncStatus &&
          other.syncUpdatedAt == this.syncUpdatedAt);
}

class ContractorStaffTableCompanion
    extends UpdateCompanion<ContractorStaffTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> gender;
  final Value<int?> contractorId;
  final Value<String?> contractorName;
  final Value<int?> companyId;
  final Value<String?> company;
  final Value<int?> departmentId;
  final Value<String?> department;
  final Value<String> startDate;
  final Value<String> endDate;
  final Value<bool> isCharged;
  final Value<int> syncStatus;
  final Value<String?> syncUpdatedAt;
  const ContractorStaffTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.gender = const Value.absent(),
    this.contractorId = const Value.absent(),
    this.contractorName = const Value.absent(),
    this.companyId = const Value.absent(),
    this.company = const Value.absent(),
    this.departmentId = const Value.absent(),
    this.department = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.isCharged = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
  });
  ContractorStaffTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.gender = const Value.absent(),
    this.contractorId = const Value.absent(),
    this.contractorName = const Value.absent(),
    this.companyId = const Value.absent(),
    this.company = const Value.absent(),
    this.departmentId = const Value.absent(),
    this.department = const Value.absent(),
    required String startDate,
    required String endDate,
    this.isCharged = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
  }) : name = Value(name),
       startDate = Value(startDate),
       endDate = Value(endDate);
  static Insertable<ContractorStaffTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? gender,
    Expression<int>? contractorId,
    Expression<String>? contractorName,
    Expression<int>? companyId,
    Expression<String>? company,
    Expression<int>? departmentId,
    Expression<String>? department,
    Expression<String>? startDate,
    Expression<String>? endDate,
    Expression<bool>? isCharged,
    Expression<int>? syncStatus,
    Expression<String>? syncUpdatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (gender != null) 'gender': gender,
      if (contractorId != null) 'contractor_id': contractorId,
      if (contractorName != null) 'contractor_name': contractorName,
      if (companyId != null) 'company_id': companyId,
      if (company != null) 'company': company,
      if (departmentId != null) 'department_id': departmentId,
      if (department != null) 'department': department,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (isCharged != null) 'is_charged': isCharged,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncUpdatedAt != null) 'sync_updated_at': syncUpdatedAt,
    });
  }

  ContractorStaffTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? gender,
    Value<int?>? contractorId,
    Value<String?>? contractorName,
    Value<int?>? companyId,
    Value<String?>? company,
    Value<int?>? departmentId,
    Value<String?>? department,
    Value<String>? startDate,
    Value<String>? endDate,
    Value<bool>? isCharged,
    Value<int>? syncStatus,
    Value<String?>? syncUpdatedAt,
  }) {
    return ContractorStaffTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      contractorId: contractorId ?? this.contractorId,
      contractorName: contractorName ?? this.contractorName,
      companyId: companyId ?? this.companyId,
      company: company ?? this.company,
      departmentId: departmentId ?? this.departmentId,
      department: department ?? this.department,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCharged: isCharged ?? this.isCharged,
      syncStatus: syncStatus ?? this.syncStatus,
      syncUpdatedAt: syncUpdatedAt ?? this.syncUpdatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (contractorId.present) {
      map['contractor_id'] = Variable<int>(contractorId.value);
    }
    if (contractorName.present) {
      map['contractor_name'] = Variable<String>(contractorName.value);
    }
    if (companyId.present) {
      map['company_id'] = Variable<int>(companyId.value);
    }
    if (company.present) {
      map['company'] = Variable<String>(company.value);
    }
    if (departmentId.present) {
      map['department_id'] = Variable<int>(departmentId.value);
    }
    if (department.present) {
      map['department'] = Variable<String>(department.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<String>(endDate.value);
    }
    if (isCharged.present) {
      map['is_charged'] = Variable<bool>(isCharged.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (syncUpdatedAt.present) {
      map['sync_updated_at'] = Variable<String>(syncUpdatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContractorStaffTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('gender: $gender, ')
          ..write('contractorId: $contractorId, ')
          ..write('contractorName: $contractorName, ')
          ..write('companyId: $companyId, ')
          ..write('company: $company, ')
          ..write('departmentId: $departmentId, ')
          ..write('department: $department, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('isCharged: $isCharged, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt')
          ..write(')'))
        .toString();
  }
}

class $ContractorStaffKitchensTable extends ContractorStaffKitchens
    with TableInfo<$ContractorStaffKitchensTable, ContractorStaffKitchen> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContractorStaffKitchensTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _contractorStaffIdMeta = const VerificationMeta(
    'contractorStaffId',
  );
  @override
  late final GeneratedColumn<int> contractorStaffId = GeneratedColumn<int>(
    'contractor_staff_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kitchenIdMeta = const VerificationMeta(
    'kitchenId',
  );
  @override
  late final GeneratedColumn<int> kitchenId = GeneratedColumn<int>(
    'kitchen_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [contractorStaffId, kitchenId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contractor_staff_kitchens';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContractorStaffKitchen> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('contractor_staff_id')) {
      context.handle(
        _contractorStaffIdMeta,
        contractorStaffId.isAcceptableOrUnknown(
          data['contractor_staff_id']!,
          _contractorStaffIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contractorStaffIdMeta);
    }
    if (data.containsKey('kitchen_id')) {
      context.handle(
        _kitchenIdMeta,
        kitchenId.isAcceptableOrUnknown(data['kitchen_id']!, _kitchenIdMeta),
      );
    } else if (isInserting) {
      context.missing(_kitchenIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {contractorStaffId, kitchenId};
  @override
  ContractorStaffKitchen map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContractorStaffKitchen(
      contractorStaffId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}contractor_staff_id'],
      )!,
      kitchenId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kitchen_id'],
      )!,
    );
  }

  @override
  $ContractorStaffKitchensTable createAlias(String alias) {
    return $ContractorStaffKitchensTable(attachedDatabase, alias);
  }
}

class ContractorStaffKitchen extends DataClass
    implements Insertable<ContractorStaffKitchen> {
  final int contractorStaffId;
  final int kitchenId;
  const ContractorStaffKitchen({
    required this.contractorStaffId,
    required this.kitchenId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['contractor_staff_id'] = Variable<int>(contractorStaffId);
    map['kitchen_id'] = Variable<int>(kitchenId);
    return map;
  }

  ContractorStaffKitchensCompanion toCompanion(bool nullToAbsent) {
    return ContractorStaffKitchensCompanion(
      contractorStaffId: Value(contractorStaffId),
      kitchenId: Value(kitchenId),
    );
  }

  factory ContractorStaffKitchen.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContractorStaffKitchen(
      contractorStaffId: serializer.fromJson<int>(json['contractorStaffId']),
      kitchenId: serializer.fromJson<int>(json['kitchenId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'contractorStaffId': serializer.toJson<int>(contractorStaffId),
      'kitchenId': serializer.toJson<int>(kitchenId),
    };
  }

  ContractorStaffKitchen copyWith({int? contractorStaffId, int? kitchenId}) =>
      ContractorStaffKitchen(
        contractorStaffId: contractorStaffId ?? this.contractorStaffId,
        kitchenId: kitchenId ?? this.kitchenId,
      );
  ContractorStaffKitchen copyWithCompanion(
    ContractorStaffKitchensCompanion data,
  ) {
    return ContractorStaffKitchen(
      contractorStaffId: data.contractorStaffId.present
          ? data.contractorStaffId.value
          : this.contractorStaffId,
      kitchenId: data.kitchenId.present ? data.kitchenId.value : this.kitchenId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContractorStaffKitchen(')
          ..write('contractorStaffId: $contractorStaffId, ')
          ..write('kitchenId: $kitchenId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(contractorStaffId, kitchenId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContractorStaffKitchen &&
          other.contractorStaffId == this.contractorStaffId &&
          other.kitchenId == this.kitchenId);
}

class ContractorStaffKitchensCompanion
    extends UpdateCompanion<ContractorStaffKitchen> {
  final Value<int> contractorStaffId;
  final Value<int> kitchenId;
  final Value<int> rowid;
  const ContractorStaffKitchensCompanion({
    this.contractorStaffId = const Value.absent(),
    this.kitchenId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContractorStaffKitchensCompanion.insert({
    required int contractorStaffId,
    required int kitchenId,
    this.rowid = const Value.absent(),
  }) : contractorStaffId = Value(contractorStaffId),
       kitchenId = Value(kitchenId);
  static Insertable<ContractorStaffKitchen> custom({
    Expression<int>? contractorStaffId,
    Expression<int>? kitchenId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (contractorStaffId != null) 'contractor_staff_id': contractorStaffId,
      if (kitchenId != null) 'kitchen_id': kitchenId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContractorStaffKitchensCompanion copyWith({
    Value<int>? contractorStaffId,
    Value<int>? kitchenId,
    Value<int>? rowid,
  }) {
    return ContractorStaffKitchensCompanion(
      contractorStaffId: contractorStaffId ?? this.contractorStaffId,
      kitchenId: kitchenId ?? this.kitchenId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (contractorStaffId.present) {
      map['contractor_staff_id'] = Variable<int>(contractorStaffId.value);
    }
    if (kitchenId.present) {
      map['kitchen_id'] = Variable<int>(kitchenId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContractorStaffKitchensCompanion(')
          ..write('contractorStaffId: $contractorStaffId, ')
          ..write('kitchenId: $kitchenId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VisitorsTable extends Visitors with TableInfo<$VisitorsTable, Visitor> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VisitorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<String> startDate = GeneratedColumn<String>(
    'start_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<String> endTime = GeneratedColumn<String>(
    'end_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _companyIdMeta = const VerificationMeta(
    'companyId',
  );
  @override
  late final GeneratedColumn<int> companyId = GeneratedColumn<int>(
    'company_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _companyMeta = const VerificationMeta(
    'company',
  );
  @override
  late final GeneratedColumn<String> company = GeneratedColumn<String>(
    'company',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _departmentIdMeta = const VerificationMeta(
    'departmentId',
  );
  @override
  late final GeneratedColumn<int> departmentId = GeneratedColumn<int>(
    'department_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _departmentMeta = const VerificationMeta(
    'department',
  );
  @override
  late final GeneratedColumn<String> department = GeneratedColumn<String>(
    'department',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncUpdatedAtMeta = const VerificationMeta(
    'syncUpdatedAt',
  );
  @override
  late final GeneratedColumn<String> syncUpdatedAt = GeneratedColumn<String>(
    'sync_updated_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    gender,
    startDate,
    endTime,
    companyId,
    company,
    departmentId,
    department,
    syncStatus,
    syncUpdatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'visitors';
  @override
  VerificationContext validateIntegrity(
    Insertable<Visitor> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    }
    if (data.containsKey('company_id')) {
      context.handle(
        _companyIdMeta,
        companyId.isAcceptableOrUnknown(data['company_id']!, _companyIdMeta),
      );
    }
    if (data.containsKey('company')) {
      context.handle(
        _companyMeta,
        company.isAcceptableOrUnknown(data['company']!, _companyMeta),
      );
    }
    if (data.containsKey('department_id')) {
      context.handle(
        _departmentIdMeta,
        departmentId.isAcceptableOrUnknown(
          data['department_id']!,
          _departmentIdMeta,
        ),
      );
    }
    if (data.containsKey('department')) {
      context.handle(
        _departmentMeta,
        department.isAcceptableOrUnknown(data['department']!, _departmentMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('sync_updated_at')) {
      context.handle(
        _syncUpdatedAtMeta,
        syncUpdatedAt.isAcceptableOrUnknown(
          data['sync_updated_at']!,
          _syncUpdatedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Visitor map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Visitor(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_date'],
      ),
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_time'],
      ),
      companyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}company_id'],
      ),
      company: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company'],
      ),
      departmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}department_id'],
      ),
      department: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}department'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
      syncUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_updated_at'],
      ),
    );
  }

  @override
  $VisitorsTable createAlias(String alias) {
    return $VisitorsTable(attachedDatabase, alias);
  }
}

class Visitor extends DataClass implements Insertable<Visitor> {
  final int id;
  final String name;
  final String? gender;
  final String? startDate;
  final String? endTime;
  final int? companyId;
  final String? company;
  final int? departmentId;
  final String? department;
  final int syncStatus;
  final String? syncUpdatedAt;
  const Visitor({
    required this.id,
    required this.name,
    this.gender,
    this.startDate,
    this.endTime,
    this.companyId,
    this.company,
    this.departmentId,
    this.department,
    required this.syncStatus,
    this.syncUpdatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<String>(startDate);
    }
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<String>(endTime);
    }
    if (!nullToAbsent || companyId != null) {
      map['company_id'] = Variable<int>(companyId);
    }
    if (!nullToAbsent || company != null) {
      map['company'] = Variable<String>(company);
    }
    if (!nullToAbsent || departmentId != null) {
      map['department_id'] = Variable<int>(departmentId);
    }
    if (!nullToAbsent || department != null) {
      map['department'] = Variable<String>(department);
    }
    map['sync_status'] = Variable<int>(syncStatus);
    if (!nullToAbsent || syncUpdatedAt != null) {
      map['sync_updated_at'] = Variable<String>(syncUpdatedAt);
    }
    return map;
  }

  VisitorsCompanion toCompanion(bool nullToAbsent) {
    return VisitorsCompanion(
      id: Value(id),
      name: Value(name),
      gender: gender == null && nullToAbsent
          ? const Value.absent()
          : Value(gender),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      companyId: companyId == null && nullToAbsent
          ? const Value.absent()
          : Value(companyId),
      company: company == null && nullToAbsent
          ? const Value.absent()
          : Value(company),
      departmentId: departmentId == null && nullToAbsent
          ? const Value.absent()
          : Value(departmentId),
      department: department == null && nullToAbsent
          ? const Value.absent()
          : Value(department),
      syncStatus: Value(syncStatus),
      syncUpdatedAt: syncUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdatedAt),
    );
  }

  factory Visitor.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Visitor(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      gender: serializer.fromJson<String?>(json['gender']),
      startDate: serializer.fromJson<String?>(json['startDate']),
      endTime: serializer.fromJson<String?>(json['endTime']),
      companyId: serializer.fromJson<int?>(json['companyId']),
      company: serializer.fromJson<String?>(json['company']),
      departmentId: serializer.fromJson<int?>(json['departmentId']),
      department: serializer.fromJson<String?>(json['department']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      syncUpdatedAt: serializer.fromJson<String?>(json['syncUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'gender': serializer.toJson<String?>(gender),
      'startDate': serializer.toJson<String?>(startDate),
      'endTime': serializer.toJson<String?>(endTime),
      'companyId': serializer.toJson<int?>(companyId),
      'company': serializer.toJson<String?>(company),
      'departmentId': serializer.toJson<int?>(departmentId),
      'department': serializer.toJson<String?>(department),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'syncUpdatedAt': serializer.toJson<String?>(syncUpdatedAt),
    };
  }

  Visitor copyWith({
    int? id,
    String? name,
    Value<String?> gender = const Value.absent(),
    Value<String?> startDate = const Value.absent(),
    Value<String?> endTime = const Value.absent(),
    Value<int?> companyId = const Value.absent(),
    Value<String?> company = const Value.absent(),
    Value<int?> departmentId = const Value.absent(),
    Value<String?> department = const Value.absent(),
    int? syncStatus,
    Value<String?> syncUpdatedAt = const Value.absent(),
  }) => Visitor(
    id: id ?? this.id,
    name: name ?? this.name,
    gender: gender.present ? gender.value : this.gender,
    startDate: startDate.present ? startDate.value : this.startDate,
    endTime: endTime.present ? endTime.value : this.endTime,
    companyId: companyId.present ? companyId.value : this.companyId,
    company: company.present ? company.value : this.company,
    departmentId: departmentId.present ? departmentId.value : this.departmentId,
    department: department.present ? department.value : this.department,
    syncStatus: syncStatus ?? this.syncStatus,
    syncUpdatedAt: syncUpdatedAt.present
        ? syncUpdatedAt.value
        : this.syncUpdatedAt,
  );
  Visitor copyWithCompanion(VisitorsCompanion data) {
    return Visitor(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      gender: data.gender.present ? data.gender.value : this.gender,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      companyId: data.companyId.present ? data.companyId.value : this.companyId,
      company: data.company.present ? data.company.value : this.company,
      departmentId: data.departmentId.present
          ? data.departmentId.value
          : this.departmentId,
      department: data.department.present
          ? data.department.value
          : this.department,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncUpdatedAt: data.syncUpdatedAt.present
          ? data.syncUpdatedAt.value
          : this.syncUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Visitor(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('gender: $gender, ')
          ..write('startDate: $startDate, ')
          ..write('endTime: $endTime, ')
          ..write('companyId: $companyId, ')
          ..write('company: $company, ')
          ..write('departmentId: $departmentId, ')
          ..write('department: $department, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    gender,
    startDate,
    endTime,
    companyId,
    company,
    departmentId,
    department,
    syncStatus,
    syncUpdatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Visitor &&
          other.id == this.id &&
          other.name == this.name &&
          other.gender == this.gender &&
          other.startDate == this.startDate &&
          other.endTime == this.endTime &&
          other.companyId == this.companyId &&
          other.company == this.company &&
          other.departmentId == this.departmentId &&
          other.department == this.department &&
          other.syncStatus == this.syncStatus &&
          other.syncUpdatedAt == this.syncUpdatedAt);
}

class VisitorsCompanion extends UpdateCompanion<Visitor> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> gender;
  final Value<String?> startDate;
  final Value<String?> endTime;
  final Value<int?> companyId;
  final Value<String?> company;
  final Value<int?> departmentId;
  final Value<String?> department;
  final Value<int> syncStatus;
  final Value<String?> syncUpdatedAt;
  const VisitorsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.gender = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endTime = const Value.absent(),
    this.companyId = const Value.absent(),
    this.company = const Value.absent(),
    this.departmentId = const Value.absent(),
    this.department = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
  });
  VisitorsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.gender = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endTime = const Value.absent(),
    this.companyId = const Value.absent(),
    this.company = const Value.absent(),
    this.departmentId = const Value.absent(),
    this.department = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Visitor> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? gender,
    Expression<String>? startDate,
    Expression<String>? endTime,
    Expression<int>? companyId,
    Expression<String>? company,
    Expression<int>? departmentId,
    Expression<String>? department,
    Expression<int>? syncStatus,
    Expression<String>? syncUpdatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (gender != null) 'gender': gender,
      if (startDate != null) 'start_date': startDate,
      if (endTime != null) 'end_time': endTime,
      if (companyId != null) 'company_id': companyId,
      if (company != null) 'company': company,
      if (departmentId != null) 'department_id': departmentId,
      if (department != null) 'department': department,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncUpdatedAt != null) 'sync_updated_at': syncUpdatedAt,
    });
  }

  VisitorsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? gender,
    Value<String?>? startDate,
    Value<String?>? endTime,
    Value<int?>? companyId,
    Value<String?>? company,
    Value<int?>? departmentId,
    Value<String?>? department,
    Value<int>? syncStatus,
    Value<String?>? syncUpdatedAt,
  }) {
    return VisitorsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      startDate: startDate ?? this.startDate,
      endTime: endTime ?? this.endTime,
      companyId: companyId ?? this.companyId,
      company: company ?? this.company,
      departmentId: departmentId ?? this.departmentId,
      department: department ?? this.department,
      syncStatus: syncStatus ?? this.syncStatus,
      syncUpdatedAt: syncUpdatedAt ?? this.syncUpdatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(startDate.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<String>(endTime.value);
    }
    if (companyId.present) {
      map['company_id'] = Variable<int>(companyId.value);
    }
    if (company.present) {
      map['company'] = Variable<String>(company.value);
    }
    if (departmentId.present) {
      map['department_id'] = Variable<int>(departmentId.value);
    }
    if (department.present) {
      map['department'] = Variable<String>(department.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (syncUpdatedAt.present) {
      map['sync_updated_at'] = Variable<String>(syncUpdatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VisitorsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('gender: $gender, ')
          ..write('startDate: $startDate, ')
          ..write('endTime: $endTime, ')
          ..write('companyId: $companyId, ')
          ..write('company: $company, ')
          ..write('departmentId: $departmentId, ')
          ..write('department: $department, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt')
          ..write(')'))
        .toString();
  }
}

class $VisitorKitchensTable extends VisitorKitchens
    with TableInfo<$VisitorKitchensTable, VisitorKitchen> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VisitorKitchensTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _visitorIdMeta = const VerificationMeta(
    'visitorId',
  );
  @override
  late final GeneratedColumn<int> visitorId = GeneratedColumn<int>(
    'visitor_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kitchenIdMeta = const VerificationMeta(
    'kitchenId',
  );
  @override
  late final GeneratedColumn<int> kitchenId = GeneratedColumn<int>(
    'kitchen_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [visitorId, kitchenId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'visitor_kitchens';
  @override
  VerificationContext validateIntegrity(
    Insertable<VisitorKitchen> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('visitor_id')) {
      context.handle(
        _visitorIdMeta,
        visitorId.isAcceptableOrUnknown(data['visitor_id']!, _visitorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_visitorIdMeta);
    }
    if (data.containsKey('kitchen_id')) {
      context.handle(
        _kitchenIdMeta,
        kitchenId.isAcceptableOrUnknown(data['kitchen_id']!, _kitchenIdMeta),
      );
    } else if (isInserting) {
      context.missing(_kitchenIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {visitorId, kitchenId};
  @override
  VisitorKitchen map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VisitorKitchen(
      visitorId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}visitor_id'],
      )!,
      kitchenId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kitchen_id'],
      )!,
    );
  }

  @override
  $VisitorKitchensTable createAlias(String alias) {
    return $VisitorKitchensTable(attachedDatabase, alias);
  }
}

class VisitorKitchen extends DataClass implements Insertable<VisitorKitchen> {
  final int visitorId;
  final int kitchenId;
  const VisitorKitchen({required this.visitorId, required this.kitchenId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['visitor_id'] = Variable<int>(visitorId);
    map['kitchen_id'] = Variable<int>(kitchenId);
    return map;
  }

  VisitorKitchensCompanion toCompanion(bool nullToAbsent) {
    return VisitorKitchensCompanion(
      visitorId: Value(visitorId),
      kitchenId: Value(kitchenId),
    );
  }

  factory VisitorKitchen.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VisitorKitchen(
      visitorId: serializer.fromJson<int>(json['visitorId']),
      kitchenId: serializer.fromJson<int>(json['kitchenId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'visitorId': serializer.toJson<int>(visitorId),
      'kitchenId': serializer.toJson<int>(kitchenId),
    };
  }

  VisitorKitchen copyWith({int? visitorId, int? kitchenId}) => VisitorKitchen(
    visitorId: visitorId ?? this.visitorId,
    kitchenId: kitchenId ?? this.kitchenId,
  );
  VisitorKitchen copyWithCompanion(VisitorKitchensCompanion data) {
    return VisitorKitchen(
      visitorId: data.visitorId.present ? data.visitorId.value : this.visitorId,
      kitchenId: data.kitchenId.present ? data.kitchenId.value : this.kitchenId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VisitorKitchen(')
          ..write('visitorId: $visitorId, ')
          ..write('kitchenId: $kitchenId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(visitorId, kitchenId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VisitorKitchen &&
          other.visitorId == this.visitorId &&
          other.kitchenId == this.kitchenId);
}

class VisitorKitchensCompanion extends UpdateCompanion<VisitorKitchen> {
  final Value<int> visitorId;
  final Value<int> kitchenId;
  final Value<int> rowid;
  const VisitorKitchensCompanion({
    this.visitorId = const Value.absent(),
    this.kitchenId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VisitorKitchensCompanion.insert({
    required int visitorId,
    required int kitchenId,
    this.rowid = const Value.absent(),
  }) : visitorId = Value(visitorId),
       kitchenId = Value(kitchenId);
  static Insertable<VisitorKitchen> custom({
    Expression<int>? visitorId,
    Expression<int>? kitchenId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (visitorId != null) 'visitor_id': visitorId,
      if (kitchenId != null) 'kitchen_id': kitchenId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VisitorKitchensCompanion copyWith({
    Value<int>? visitorId,
    Value<int>? kitchenId,
    Value<int>? rowid,
  }) {
    return VisitorKitchensCompanion(
      visitorId: visitorId ?? this.visitorId,
      kitchenId: kitchenId ?? this.kitchenId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (visitorId.present) {
      map['visitor_id'] = Variable<int>(visitorId.value);
    }
    if (kitchenId.present) {
      map['kitchen_id'] = Variable<int>(kitchenId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VisitorKitchensCompanion(')
          ..write('visitorId: $visitorId, ')
          ..write('kitchenId: $kitchenId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BioDataEntriesTable extends BioDataEntries
    with TableInfo<$BioDataEntriesTable, BioDataEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BioDataEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _staffIdMeta = const VerificationMeta(
    'staffId',
  );
  @override
  late final GeneratedColumn<int> staffId = GeneratedColumn<int>(
    'staff_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES staff (id)',
    ),
  );
  static const VerificationMeta _dependentIdMeta = const VerificationMeta(
    'dependentId',
  );
  @override
  late final GeneratedColumn<int> dependentId = GeneratedColumn<int>(
    'dependent_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES dependents (id)',
    ),
  );
  static const VerificationMeta _contractorStaffIdMeta = const VerificationMeta(
    'contractorStaffId',
  );
  @override
  late final GeneratedColumn<int> contractorStaffId = GeneratedColumn<int>(
    'contractor_staff_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES contractor_staff_table (id)',
    ),
  );
  static const VerificationMeta _visitorIdMeta = const VerificationMeta(
    'visitorId',
  );
  @override
  late final GeneratedColumn<int> visitorId = GeneratedColumn<int>(
    'visitor_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES visitors (id)',
    ),
  );
  static const VerificationMeta _fingerMeta = const VerificationMeta('finger');
  @override
  late final GeneratedColumn<String> finger = GeneratedColumn<String>(
    'finger',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataBase64Meta = const VerificationMeta(
    'dataBase64',
  );
  @override
  late final GeneratedColumn<String> dataBase64 = GeneratedColumn<String>(
    'data_base64',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncUpdatedAtMeta = const VerificationMeta(
    'syncUpdatedAt',
  );
  @override
  late final GeneratedColumn<String> syncUpdatedAt = GeneratedColumn<String>(
    'sync_updated_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    staffId,
    dependentId,
    contractorStaffId,
    visitorId,
    finger,
    dataBase64,
    isActive,
    createdAt,
    updatedAt,
    syncStatus,
    syncUpdatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bio_data_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<BioDataEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('staff_id')) {
      context.handle(
        _staffIdMeta,
        staffId.isAcceptableOrUnknown(data['staff_id']!, _staffIdMeta),
      );
    }
    if (data.containsKey('dependent_id')) {
      context.handle(
        _dependentIdMeta,
        dependentId.isAcceptableOrUnknown(
          data['dependent_id']!,
          _dependentIdMeta,
        ),
      );
    }
    if (data.containsKey('contractor_staff_id')) {
      context.handle(
        _contractorStaffIdMeta,
        contractorStaffId.isAcceptableOrUnknown(
          data['contractor_staff_id']!,
          _contractorStaffIdMeta,
        ),
      );
    }
    if (data.containsKey('visitor_id')) {
      context.handle(
        _visitorIdMeta,
        visitorId.isAcceptableOrUnknown(data['visitor_id']!, _visitorIdMeta),
      );
    }
    if (data.containsKey('finger')) {
      context.handle(
        _fingerMeta,
        finger.isAcceptableOrUnknown(data['finger']!, _fingerMeta),
      );
    } else if (isInserting) {
      context.missing(_fingerMeta);
    }
    if (data.containsKey('data_base64')) {
      context.handle(
        _dataBase64Meta,
        dataBase64.isAcceptableOrUnknown(data['data_base64']!, _dataBase64Meta),
      );
    } else if (isInserting) {
      context.missing(_dataBase64Meta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('sync_updated_at')) {
      context.handle(
        _syncUpdatedAtMeta,
        syncUpdatedAt.isAcceptableOrUnknown(
          data['sync_updated_at']!,
          _syncUpdatedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BioDataEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BioDataEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      staffId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}staff_id'],
      ),
      dependentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dependent_id'],
      ),
      contractorStaffId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}contractor_staff_id'],
      ),
      visitorId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}visitor_id'],
      ),
      finger: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}finger'],
      )!,
      dataBase64: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data_base64'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
      syncUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_updated_at'],
      ),
    );
  }

  @override
  $BioDataEntriesTable createAlias(String alias) {
    return $BioDataEntriesTable(attachedDatabase, alias);
  }
}

class BioDataEntry extends DataClass implements Insertable<BioDataEntry> {
  final int id;
  final int? staffId;
  final int? dependentId;
  final int? contractorStaffId;
  final int? visitorId;
  final String finger;
  final String dataBase64;
  final bool isActive;
  final String createdAt;
  final String updatedAt;
  final int syncStatus;
  final String? syncUpdatedAt;
  const BioDataEntry({
    required this.id,
    this.staffId,
    this.dependentId,
    this.contractorStaffId,
    this.visitorId,
    required this.finger,
    required this.dataBase64,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    this.syncUpdatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || staffId != null) {
      map['staff_id'] = Variable<int>(staffId);
    }
    if (!nullToAbsent || dependentId != null) {
      map['dependent_id'] = Variable<int>(dependentId);
    }
    if (!nullToAbsent || contractorStaffId != null) {
      map['contractor_staff_id'] = Variable<int>(contractorStaffId);
    }
    if (!nullToAbsent || visitorId != null) {
      map['visitor_id'] = Variable<int>(visitorId);
    }
    map['finger'] = Variable<String>(finger);
    map['data_base64'] = Variable<String>(dataBase64);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    map['sync_status'] = Variable<int>(syncStatus);
    if (!nullToAbsent || syncUpdatedAt != null) {
      map['sync_updated_at'] = Variable<String>(syncUpdatedAt);
    }
    return map;
  }

  BioDataEntriesCompanion toCompanion(bool nullToAbsent) {
    return BioDataEntriesCompanion(
      id: Value(id),
      staffId: staffId == null && nullToAbsent
          ? const Value.absent()
          : Value(staffId),
      dependentId: dependentId == null && nullToAbsent
          ? const Value.absent()
          : Value(dependentId),
      contractorStaffId: contractorStaffId == null && nullToAbsent
          ? const Value.absent()
          : Value(contractorStaffId),
      visitorId: visitorId == null && nullToAbsent
          ? const Value.absent()
          : Value(visitorId),
      finger: Value(finger),
      dataBase64: Value(dataBase64),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      syncUpdatedAt: syncUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdatedAt),
    );
  }

  factory BioDataEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BioDataEntry(
      id: serializer.fromJson<int>(json['id']),
      staffId: serializer.fromJson<int?>(json['staffId']),
      dependentId: serializer.fromJson<int?>(json['dependentId']),
      contractorStaffId: serializer.fromJson<int?>(json['contractorStaffId']),
      visitorId: serializer.fromJson<int?>(json['visitorId']),
      finger: serializer.fromJson<String>(json['finger']),
      dataBase64: serializer.fromJson<String>(json['dataBase64']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      syncUpdatedAt: serializer.fromJson<String?>(json['syncUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'staffId': serializer.toJson<int?>(staffId),
      'dependentId': serializer.toJson<int?>(dependentId),
      'contractorStaffId': serializer.toJson<int?>(contractorStaffId),
      'visitorId': serializer.toJson<int?>(visitorId),
      'finger': serializer.toJson<String>(finger),
      'dataBase64': serializer.toJson<String>(dataBase64),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'syncUpdatedAt': serializer.toJson<String?>(syncUpdatedAt),
    };
  }

  BioDataEntry copyWith({
    int? id,
    Value<int?> staffId = const Value.absent(),
    Value<int?> dependentId = const Value.absent(),
    Value<int?> contractorStaffId = const Value.absent(),
    Value<int?> visitorId = const Value.absent(),
    String? finger,
    String? dataBase64,
    bool? isActive,
    String? createdAt,
    String? updatedAt,
    int? syncStatus,
    Value<String?> syncUpdatedAt = const Value.absent(),
  }) => BioDataEntry(
    id: id ?? this.id,
    staffId: staffId.present ? staffId.value : this.staffId,
    dependentId: dependentId.present ? dependentId.value : this.dependentId,
    contractorStaffId: contractorStaffId.present
        ? contractorStaffId.value
        : this.contractorStaffId,
    visitorId: visitorId.present ? visitorId.value : this.visitorId,
    finger: finger ?? this.finger,
    dataBase64: dataBase64 ?? this.dataBase64,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    syncUpdatedAt: syncUpdatedAt.present
        ? syncUpdatedAt.value
        : this.syncUpdatedAt,
  );
  BioDataEntry copyWithCompanion(BioDataEntriesCompanion data) {
    return BioDataEntry(
      id: data.id.present ? data.id.value : this.id,
      staffId: data.staffId.present ? data.staffId.value : this.staffId,
      dependentId: data.dependentId.present
          ? data.dependentId.value
          : this.dependentId,
      contractorStaffId: data.contractorStaffId.present
          ? data.contractorStaffId.value
          : this.contractorStaffId,
      visitorId: data.visitorId.present ? data.visitorId.value : this.visitorId,
      finger: data.finger.present ? data.finger.value : this.finger,
      dataBase64: data.dataBase64.present
          ? data.dataBase64.value
          : this.dataBase64,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncUpdatedAt: data.syncUpdatedAt.present
          ? data.syncUpdatedAt.value
          : this.syncUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BioDataEntry(')
          ..write('id: $id, ')
          ..write('staffId: $staffId, ')
          ..write('dependentId: $dependentId, ')
          ..write('contractorStaffId: $contractorStaffId, ')
          ..write('visitorId: $visitorId, ')
          ..write('finger: $finger, ')
          ..write('dataBase64: $dataBase64, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    staffId,
    dependentId,
    contractorStaffId,
    visitorId,
    finger,
    dataBase64,
    isActive,
    createdAt,
    updatedAt,
    syncStatus,
    syncUpdatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BioDataEntry &&
          other.id == this.id &&
          other.staffId == this.staffId &&
          other.dependentId == this.dependentId &&
          other.contractorStaffId == this.contractorStaffId &&
          other.visitorId == this.visitorId &&
          other.finger == this.finger &&
          other.dataBase64 == this.dataBase64 &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.syncUpdatedAt == this.syncUpdatedAt);
}

class BioDataEntriesCompanion extends UpdateCompanion<BioDataEntry> {
  final Value<int> id;
  final Value<int?> staffId;
  final Value<int?> dependentId;
  final Value<int?> contractorStaffId;
  final Value<int?> visitorId;
  final Value<String> finger;
  final Value<String> dataBase64;
  final Value<bool> isActive;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> syncStatus;
  final Value<String?> syncUpdatedAt;
  const BioDataEntriesCompanion({
    this.id = const Value.absent(),
    this.staffId = const Value.absent(),
    this.dependentId = const Value.absent(),
    this.contractorStaffId = const Value.absent(),
    this.visitorId = const Value.absent(),
    this.finger = const Value.absent(),
    this.dataBase64 = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
  });
  BioDataEntriesCompanion.insert({
    this.id = const Value.absent(),
    this.staffId = const Value.absent(),
    this.dependentId = const Value.absent(),
    this.contractorStaffId = const Value.absent(),
    this.visitorId = const Value.absent(),
    required String finger,
    required String dataBase64,
    this.isActive = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
  }) : finger = Value(finger),
       dataBase64 = Value(dataBase64),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<BioDataEntry> custom({
    Expression<int>? id,
    Expression<int>? staffId,
    Expression<int>? dependentId,
    Expression<int>? contractorStaffId,
    Expression<int>? visitorId,
    Expression<String>? finger,
    Expression<String>? dataBase64,
    Expression<bool>? isActive,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? syncStatus,
    Expression<String>? syncUpdatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (staffId != null) 'staff_id': staffId,
      if (dependentId != null) 'dependent_id': dependentId,
      if (contractorStaffId != null) 'contractor_staff_id': contractorStaffId,
      if (visitorId != null) 'visitor_id': visitorId,
      if (finger != null) 'finger': finger,
      if (dataBase64 != null) 'data_base64': dataBase64,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncUpdatedAt != null) 'sync_updated_at': syncUpdatedAt,
    });
  }

  BioDataEntriesCompanion copyWith({
    Value<int>? id,
    Value<int?>? staffId,
    Value<int?>? dependentId,
    Value<int?>? contractorStaffId,
    Value<int?>? visitorId,
    Value<String>? finger,
    Value<String>? dataBase64,
    Value<bool>? isActive,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? syncStatus,
    Value<String?>? syncUpdatedAt,
  }) {
    return BioDataEntriesCompanion(
      id: id ?? this.id,
      staffId: staffId ?? this.staffId,
      dependentId: dependentId ?? this.dependentId,
      contractorStaffId: contractorStaffId ?? this.contractorStaffId,
      visitorId: visitorId ?? this.visitorId,
      finger: finger ?? this.finger,
      dataBase64: dataBase64 ?? this.dataBase64,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncUpdatedAt: syncUpdatedAt ?? this.syncUpdatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (staffId.present) {
      map['staff_id'] = Variable<int>(staffId.value);
    }
    if (dependentId.present) {
      map['dependent_id'] = Variable<int>(dependentId.value);
    }
    if (contractorStaffId.present) {
      map['contractor_staff_id'] = Variable<int>(contractorStaffId.value);
    }
    if (visitorId.present) {
      map['visitor_id'] = Variable<int>(visitorId.value);
    }
    if (finger.present) {
      map['finger'] = Variable<String>(finger.value);
    }
    if (dataBase64.present) {
      map['data_base64'] = Variable<String>(dataBase64.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (syncUpdatedAt.present) {
      map['sync_updated_at'] = Variable<String>(syncUpdatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BioDataEntriesCompanion(')
          ..write('id: $id, ')
          ..write('staffId: $staffId, ')
          ..write('dependentId: $dependentId, ')
          ..write('contractorStaffId: $contractorStaffId, ')
          ..write('visitorId: $visitorId, ')
          ..write('finger: $finger, ')
          ..write('dataBase64: $dataBase64, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SitesTable sites = $SitesTable(this);
  late final $DepartmentsTable departments = $DepartmentsTable(this);
  late final $ShiftsTable shifts = $ShiftsTable(this);
  late final $ShiftMealTypesTable shiftMealTypes = $ShiftMealTypesTable(this);
  late final $KitchensTable kitchens = $KitchensTable(this);
  late final $MenuTypesTable menuTypes = $MenuTypesTable(this);
  late final $MealTypesTable mealTypes = $MealTypesTable(this);
  late final $StaffTable staff = $StaffTable(this);
  late final $StaffKitchensTable staffKitchens = $StaffKitchensTable(this);
  late final $DependentsTable dependents = $DependentsTable(this);
  late final $DependentKitchensTable dependentKitchens =
      $DependentKitchensTable(this);
  late final $CardsTable cards = $CardsTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $UserKitchensTable userKitchens = $UserKitchensTable(this);
  late final $OrdersTable orders = $OrdersTable(this);
  late final $PosDevicesTable posDevices = $PosDevicesTable(this);
  late final $ActivityLogsTable activityLogs = $ActivityLogsTable(this);
  late final $GroupOrdersTable groupOrders = $GroupOrdersTable(this);
  late final $ContractorsTable contractors = $ContractorsTable(this);
  late final $ContractorStaffTableTable contractorStaffTable =
      $ContractorStaffTableTable(this);
  late final $ContractorStaffKitchensTable contractorStaffKitchens =
      $ContractorStaffKitchensTable(this);
  late final $VisitorsTable visitors = $VisitorsTable(this);
  late final $VisitorKitchensTable visitorKitchens = $VisitorKitchensTable(
    this,
  );
  late final $BioDataEntriesTable bioDataEntries = $BioDataEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    sites,
    departments,
    shifts,
    shiftMealTypes,
    kitchens,
    menuTypes,
    mealTypes,
    staff,
    staffKitchens,
    dependents,
    dependentKitchens,
    cards,
    users,
    userKitchens,
    orders,
    posDevices,
    activityLogs,
    groupOrders,
    contractors,
    contractorStaffTable,
    contractorStaffKitchens,
    visitors,
    visitorKitchens,
    bioDataEntries,
  ];
}

typedef $$SitesTableCreateCompanionBuilder =
    SitesCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> location,
      Value<int> noOfEmployees,
      Value<bool> isActive,
      Value<String?> startDate,
      Value<String?> endDate,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
    });
typedef $$SitesTableUpdateCompanionBuilder =
    SitesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> location,
      Value<int> noOfEmployees,
      Value<bool> isActive,
      Value<String?> startDate,
      Value<String?> endDate,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
    });

final class $$SitesTableReferences
    extends BaseReferences<_$AppDatabase, $SitesTable, Site> {
  $$SitesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DepartmentsTable, List<Department>>
  _departmentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.departments,
    aliasName: $_aliasNameGenerator(db.sites.id, db.departments.companyId),
  );

  $$DepartmentsTableProcessedTableManager get departmentsRefs {
    final manager = $$DepartmentsTableTableManager(
      $_db,
      $_db.departments,
    ).filter((f) => f.companyId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_departmentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$KitchensTable, List<Kitchen>> _kitchensRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.kitchens,
    aliasName: $_aliasNameGenerator(db.sites.id, db.kitchens.companyId),
  );

  $$KitchensTableProcessedTableManager get kitchensRefs {
    final manager = $$KitchensTableTableManager(
      $_db,
      $_db.kitchens,
    ).filter((f) => f.companyId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_kitchensRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SitesTableFilterComposer extends Composer<_$AppDatabase, $SitesTable> {
  $$SitesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get noOfEmployees => $composableBuilder(
    column: $table.noOfEmployees,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> departmentsRefs(
    Expression<bool> Function($$DepartmentsTableFilterComposer f) f,
  ) {
    final $$DepartmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.departments,
      getReferencedColumn: (t) => t.companyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepartmentsTableFilterComposer(
            $db: $db,
            $table: $db.departments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> kitchensRefs(
    Expression<bool> Function($$KitchensTableFilterComposer f) f,
  ) {
    final $$KitchensTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.kitchens,
      getReferencedColumn: (t) => t.companyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KitchensTableFilterComposer(
            $db: $db,
            $table: $db.kitchens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SitesTableOrderingComposer
    extends Composer<_$AppDatabase, $SitesTable> {
  $$SitesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get noOfEmployees => $composableBuilder(
    column: $table.noOfEmployees,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SitesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SitesTable> {
  $$SitesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<int> get noOfEmployees => $composableBuilder(
    column: $table.noOfEmployees,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => column,
  );

  Expression<T> departmentsRefs<T extends Object>(
    Expression<T> Function($$DepartmentsTableAnnotationComposer a) f,
  ) {
    final $$DepartmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.departments,
      getReferencedColumn: (t) => t.companyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepartmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.departments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> kitchensRefs<T extends Object>(
    Expression<T> Function($$KitchensTableAnnotationComposer a) f,
  ) {
    final $$KitchensTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.kitchens,
      getReferencedColumn: (t) => t.companyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KitchensTableAnnotationComposer(
            $db: $db,
            $table: $db.kitchens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SitesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SitesTable,
          Site,
          $$SitesTableFilterComposer,
          $$SitesTableOrderingComposer,
          $$SitesTableAnnotationComposer,
          $$SitesTableCreateCompanionBuilder,
          $$SitesTableUpdateCompanionBuilder,
          (Site, $$SitesTableReferences),
          Site,
          PrefetchHooks Function({bool departmentsRefs, bool kitchensRefs})
        > {
  $$SitesTableTableManager(_$AppDatabase db, $SitesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SitesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SitesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SitesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<int> noOfEmployees = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String?> startDate = const Value.absent(),
                Value<String?> endDate = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
              }) => SitesCompanion(
                id: id,
                name: name,
                location: location,
                noOfEmployees: noOfEmployees,
                isActive: isActive,
                startDate: startDate,
                endDate: endDate,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> location = const Value.absent(),
                Value<int> noOfEmployees = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String?> startDate = const Value.absent(),
                Value<String?> endDate = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
              }) => SitesCompanion.insert(
                id: id,
                name: name,
                location: location,
                noOfEmployees: noOfEmployees,
                isActive: isActive,
                startDate: startDate,
                endDate: endDate,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$SitesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({departmentsRefs = false, kitchensRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (departmentsRefs) db.departments,
                    if (kitchensRefs) db.kitchens,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (departmentsRefs)
                        await $_getPrefetchedData<
                          Site,
                          $SitesTable,
                          Department
                        >(
                          currentTable: table,
                          referencedTable: $$SitesTableReferences
                              ._departmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SitesTableReferences(
                                db,
                                table,
                                p0,
                              ).departmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.companyId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (kitchensRefs)
                        await $_getPrefetchedData<Site, $SitesTable, Kitchen>(
                          currentTable: table,
                          referencedTable: $$SitesTableReferences
                              ._kitchensRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SitesTableReferences(
                                db,
                                table,
                                p0,
                              ).kitchensRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.companyId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SitesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SitesTable,
      Site,
      $$SitesTableFilterComposer,
      $$SitesTableOrderingComposer,
      $$SitesTableAnnotationComposer,
      $$SitesTableCreateCompanionBuilder,
      $$SitesTableUpdateCompanionBuilder,
      (Site, $$SitesTableReferences),
      Site,
      PrefetchHooks Function({bool departmentsRefs, bool kitchensRefs})
    >;
typedef $$DepartmentsTableCreateCompanionBuilder =
    DepartmentsCompanion Function({
      Value<int> id,
      required String name,
      required int companyId,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
    });
typedef $$DepartmentsTableUpdateCompanionBuilder =
    DepartmentsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> companyId,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
    });

final class $$DepartmentsTableReferences
    extends BaseReferences<_$AppDatabase, $DepartmentsTable, Department> {
  $$DepartmentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SitesTable _companyIdTable(_$AppDatabase db) => db.sites.createAlias(
    $_aliasNameGenerator(db.departments.companyId, db.sites.id),
  );

  $$SitesTableProcessedTableManager get companyId {
    final $_column = $_itemColumn<int>('company_id')!;

    final manager = $$SitesTableTableManager(
      $_db,
      $_db.sites,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_companyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DepartmentsTableFilterComposer
    extends Composer<_$AppDatabase, $DepartmentsTable> {
  $$DepartmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SitesTableFilterComposer get companyId {
    final $$SitesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.companyId,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableFilterComposer(
            $db: $db,
            $table: $db.sites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DepartmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $DepartmentsTable> {
  $$DepartmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SitesTableOrderingComposer get companyId {
    final $$SitesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.companyId,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableOrderingComposer(
            $db: $db,
            $table: $db.sites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DepartmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DepartmentsTable> {
  $$DepartmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => column,
  );

  $$SitesTableAnnotationComposer get companyId {
    final $$SitesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.companyId,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableAnnotationComposer(
            $db: $db,
            $table: $db.sites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DepartmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DepartmentsTable,
          Department,
          $$DepartmentsTableFilterComposer,
          $$DepartmentsTableOrderingComposer,
          $$DepartmentsTableAnnotationComposer,
          $$DepartmentsTableCreateCompanionBuilder,
          $$DepartmentsTableUpdateCompanionBuilder,
          (Department, $$DepartmentsTableReferences),
          Department,
          PrefetchHooks Function({bool companyId})
        > {
  $$DepartmentsTableTableManager(_$AppDatabase db, $DepartmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DepartmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DepartmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DepartmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> companyId = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
              }) => DepartmentsCompanion(
                id: id,
                name: name,
                companyId: companyId,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int companyId,
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
              }) => DepartmentsCompanion.insert(
                id: id,
                name: name,
                companyId: companyId,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DepartmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({companyId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (companyId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.companyId,
                                referencedTable: $$DepartmentsTableReferences
                                    ._companyIdTable(db),
                                referencedColumn: $$DepartmentsTableReferences
                                    ._companyIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DepartmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DepartmentsTable,
      Department,
      $$DepartmentsTableFilterComposer,
      $$DepartmentsTableOrderingComposer,
      $$DepartmentsTableAnnotationComposer,
      $$DepartmentsTableCreateCompanionBuilder,
      $$DepartmentsTableUpdateCompanionBuilder,
      (Department, $$DepartmentsTableReferences),
      Department,
      PrefetchHooks Function({bool companyId})
    >;
typedef $$ShiftsTableCreateCompanionBuilder =
    ShiftsCompanion Function({
      Value<int> id,
      required String name,
      required int hours,
      Value<int?> companyId,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
    });
typedef $$ShiftsTableUpdateCompanionBuilder =
    ShiftsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> hours,
      Value<int?> companyId,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
    });

class $$ShiftsTableFilterComposer
    extends Composer<_$AppDatabase, $ShiftsTable> {
  $$ShiftsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hours => $composableBuilder(
    column: $table.hours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get companyId => $composableBuilder(
    column: $table.companyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ShiftsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShiftsTable> {
  $$ShiftsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hours => $composableBuilder(
    column: $table.hours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get companyId => $composableBuilder(
    column: $table.companyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShiftsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShiftsTable> {
  $$ShiftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get hours =>
      $composableBuilder(column: $table.hours, builder: (column) => column);

  GeneratedColumn<int> get companyId =>
      $composableBuilder(column: $table.companyId, builder: (column) => column);

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => column,
  );
}

class $$ShiftsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShiftsTable,
          Shift,
          $$ShiftsTableFilterComposer,
          $$ShiftsTableOrderingComposer,
          $$ShiftsTableAnnotationComposer,
          $$ShiftsTableCreateCompanionBuilder,
          $$ShiftsTableUpdateCompanionBuilder,
          (Shift, BaseReferences<_$AppDatabase, $ShiftsTable, Shift>),
          Shift,
          PrefetchHooks Function()
        > {
  $$ShiftsTableTableManager(_$AppDatabase db, $ShiftsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShiftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShiftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShiftsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> hours = const Value.absent(),
                Value<int?> companyId = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
              }) => ShiftsCompanion(
                id: id,
                name: name,
                hours: hours,
                companyId: companyId,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int hours,
                Value<int?> companyId = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
              }) => ShiftsCompanion.insert(
                id: id,
                name: name,
                hours: hours,
                companyId: companyId,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ShiftsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShiftsTable,
      Shift,
      $$ShiftsTableFilterComposer,
      $$ShiftsTableOrderingComposer,
      $$ShiftsTableAnnotationComposer,
      $$ShiftsTableCreateCompanionBuilder,
      $$ShiftsTableUpdateCompanionBuilder,
      (Shift, BaseReferences<_$AppDatabase, $ShiftsTable, Shift>),
      Shift,
      PrefetchHooks Function()
    >;
typedef $$ShiftMealTypesTableCreateCompanionBuilder =
    ShiftMealTypesCompanion Function({
      required int shiftId,
      required int mealTypeId,
      Value<int> rowid,
    });
typedef $$ShiftMealTypesTableUpdateCompanionBuilder =
    ShiftMealTypesCompanion Function({
      Value<int> shiftId,
      Value<int> mealTypeId,
      Value<int> rowid,
    });

class $$ShiftMealTypesTableFilterComposer
    extends Composer<_$AppDatabase, $ShiftMealTypesTable> {
  $$ShiftMealTypesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get shiftId => $composableBuilder(
    column: $table.shiftId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mealTypeId => $composableBuilder(
    column: $table.mealTypeId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ShiftMealTypesTableOrderingComposer
    extends Composer<_$AppDatabase, $ShiftMealTypesTable> {
  $$ShiftMealTypesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get shiftId => $composableBuilder(
    column: $table.shiftId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mealTypeId => $composableBuilder(
    column: $table.mealTypeId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShiftMealTypesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShiftMealTypesTable> {
  $$ShiftMealTypesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get shiftId =>
      $composableBuilder(column: $table.shiftId, builder: (column) => column);

  GeneratedColumn<int> get mealTypeId => $composableBuilder(
    column: $table.mealTypeId,
    builder: (column) => column,
  );
}

class $$ShiftMealTypesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShiftMealTypesTable,
          ShiftMealType,
          $$ShiftMealTypesTableFilterComposer,
          $$ShiftMealTypesTableOrderingComposer,
          $$ShiftMealTypesTableAnnotationComposer,
          $$ShiftMealTypesTableCreateCompanionBuilder,
          $$ShiftMealTypesTableUpdateCompanionBuilder,
          (
            ShiftMealType,
            BaseReferences<_$AppDatabase, $ShiftMealTypesTable, ShiftMealType>,
          ),
          ShiftMealType,
          PrefetchHooks Function()
        > {
  $$ShiftMealTypesTableTableManager(
    _$AppDatabase db,
    $ShiftMealTypesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShiftMealTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShiftMealTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShiftMealTypesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> shiftId = const Value.absent(),
                Value<int> mealTypeId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShiftMealTypesCompanion(
                shiftId: shiftId,
                mealTypeId: mealTypeId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int shiftId,
                required int mealTypeId,
                Value<int> rowid = const Value.absent(),
              }) => ShiftMealTypesCompanion.insert(
                shiftId: shiftId,
                mealTypeId: mealTypeId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ShiftMealTypesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShiftMealTypesTable,
      ShiftMealType,
      $$ShiftMealTypesTableFilterComposer,
      $$ShiftMealTypesTableOrderingComposer,
      $$ShiftMealTypesTableAnnotationComposer,
      $$ShiftMealTypesTableCreateCompanionBuilder,
      $$ShiftMealTypesTableUpdateCompanionBuilder,
      (
        ShiftMealType,
        BaseReferences<_$AppDatabase, $ShiftMealTypesTable, ShiftMealType>,
      ),
      ShiftMealType,
      PrefetchHooks Function()
    >;
typedef $$KitchensTableCreateCompanionBuilder =
    KitchensCompanion Function({
      Value<int> id,
      required String name,
      required int minTierRequired,
      required String status,
      Value<int?> companyId,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
    });
typedef $$KitchensTableUpdateCompanionBuilder =
    KitchensCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> minTierRequired,
      Value<String> status,
      Value<int?> companyId,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
    });

final class $$KitchensTableReferences
    extends BaseReferences<_$AppDatabase, $KitchensTable, Kitchen> {
  $$KitchensTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SitesTable _companyIdTable(_$AppDatabase db) => db.sites.createAlias(
    $_aliasNameGenerator(db.kitchens.companyId, db.sites.id),
  );

  $$SitesTableProcessedTableManager? get companyId {
    final $_column = $_itemColumn<int>('company_id');
    if ($_column == null) return null;
    final manager = $$SitesTableTableManager(
      $_db,
      $_db.sites,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_companyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$KitchensTableFilterComposer
    extends Composer<_$AppDatabase, $KitchensTable> {
  $$KitchensTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minTierRequired => $composableBuilder(
    column: $table.minTierRequired,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SitesTableFilterComposer get companyId {
    final $$SitesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.companyId,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableFilterComposer(
            $db: $db,
            $table: $db.sites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KitchensTableOrderingComposer
    extends Composer<_$AppDatabase, $KitchensTable> {
  $$KitchensTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minTierRequired => $composableBuilder(
    column: $table.minTierRequired,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SitesTableOrderingComposer get companyId {
    final $$SitesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.companyId,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableOrderingComposer(
            $db: $db,
            $table: $db.sites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KitchensTableAnnotationComposer
    extends Composer<_$AppDatabase, $KitchensTable> {
  $$KitchensTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get minTierRequired => $composableBuilder(
    column: $table.minTierRequired,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => column,
  );

  $$SitesTableAnnotationComposer get companyId {
    final $$SitesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.companyId,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableAnnotationComposer(
            $db: $db,
            $table: $db.sites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KitchensTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KitchensTable,
          Kitchen,
          $$KitchensTableFilterComposer,
          $$KitchensTableOrderingComposer,
          $$KitchensTableAnnotationComposer,
          $$KitchensTableCreateCompanionBuilder,
          $$KitchensTableUpdateCompanionBuilder,
          (Kitchen, $$KitchensTableReferences),
          Kitchen,
          PrefetchHooks Function({bool companyId})
        > {
  $$KitchensTableTableManager(_$AppDatabase db, $KitchensTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KitchensTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KitchensTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KitchensTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> minTierRequired = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int?> companyId = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
              }) => KitchensCompanion(
                id: id,
                name: name,
                minTierRequired: minTierRequired,
                status: status,
                companyId: companyId,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int minTierRequired,
                required String status,
                Value<int?> companyId = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
              }) => KitchensCompanion.insert(
                id: id,
                name: name,
                minTierRequired: minTierRequired,
                status: status,
                companyId: companyId,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$KitchensTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({companyId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (companyId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.companyId,
                                referencedTable: $$KitchensTableReferences
                                    ._companyIdTable(db),
                                referencedColumn: $$KitchensTableReferences
                                    ._companyIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$KitchensTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KitchensTable,
      Kitchen,
      $$KitchensTableFilterComposer,
      $$KitchensTableOrderingComposer,
      $$KitchensTableAnnotationComposer,
      $$KitchensTableCreateCompanionBuilder,
      $$KitchensTableUpdateCompanionBuilder,
      (Kitchen, $$KitchensTableReferences),
      Kitchen,
      PrefetchHooks Function({bool companyId})
    >;
typedef $$MenuTypesTableCreateCompanionBuilder =
    MenuTypesCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> remarks,
      required String status,
      required String createdAt,
      required String updatedAt,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
    });
typedef $$MenuTypesTableUpdateCompanionBuilder =
    MenuTypesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> remarks,
      Value<String> status,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
    });

class $$MenuTypesTableFilterComposer
    extends Composer<_$AppDatabase, $MenuTypesTable> {
  $$MenuTypesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remarks => $composableBuilder(
    column: $table.remarks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MenuTypesTableOrderingComposer
    extends Composer<_$AppDatabase, $MenuTypesTable> {
  $$MenuTypesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remarks => $composableBuilder(
    column: $table.remarks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MenuTypesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MenuTypesTable> {
  $$MenuTypesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get remarks =>
      $composableBuilder(column: $table.remarks, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => column,
  );
}

class $$MenuTypesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MenuTypesTable,
          MenuType,
          $$MenuTypesTableFilterComposer,
          $$MenuTypesTableOrderingComposer,
          $$MenuTypesTableAnnotationComposer,
          $$MenuTypesTableCreateCompanionBuilder,
          $$MenuTypesTableUpdateCompanionBuilder,
          (MenuType, BaseReferences<_$AppDatabase, $MenuTypesTable, MenuType>),
          MenuType,
          PrefetchHooks Function()
        > {
  $$MenuTypesTableTableManager(_$AppDatabase db, $MenuTypesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MenuTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MenuTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MenuTypesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> remarks = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
              }) => MenuTypesCompanion(
                id: id,
                name: name,
                remarks: remarks,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> remarks = const Value.absent(),
                required String status,
                required String createdAt,
                required String updatedAt,
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
              }) => MenuTypesCompanion.insert(
                id: id,
                name: name,
                remarks: remarks,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MenuTypesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MenuTypesTable,
      MenuType,
      $$MenuTypesTableFilterComposer,
      $$MenuTypesTableOrderingComposer,
      $$MenuTypesTableAnnotationComposer,
      $$MenuTypesTableCreateCompanionBuilder,
      $$MenuTypesTableUpdateCompanionBuilder,
      (MenuType, BaseReferences<_$AppDatabase, $MenuTypesTable, MenuType>),
      MenuType,
      PrefetchHooks Function()
    >;
typedef $$MealTypesTableCreateCompanionBuilder =
    MealTypesCompanion Function({
      Value<int> id,
      required String name,
      required String status,
      required String beginTime,
      required String endTime,
      Value<double> price,
      Value<String?> remarks,
      required String createdAt,
      required String updatedAt,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
    });
typedef $$MealTypesTableUpdateCompanionBuilder =
    MealTypesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> status,
      Value<String> beginTime,
      Value<String> endTime,
      Value<double> price,
      Value<String?> remarks,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
    });

class $$MealTypesTableFilterComposer
    extends Composer<_$AppDatabase, $MealTypesTable> {
  $$MealTypesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get beginTime => $composableBuilder(
    column: $table.beginTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remarks => $composableBuilder(
    column: $table.remarks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MealTypesTableOrderingComposer
    extends Composer<_$AppDatabase, $MealTypesTable> {
  $$MealTypesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get beginTime => $composableBuilder(
    column: $table.beginTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remarks => $composableBuilder(
    column: $table.remarks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MealTypesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealTypesTable> {
  $$MealTypesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get beginTime =>
      $composableBuilder(column: $table.beginTime, builder: (column) => column);

  GeneratedColumn<String> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get remarks =>
      $composableBuilder(column: $table.remarks, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => column,
  );
}

class $$MealTypesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealTypesTable,
          MealType,
          $$MealTypesTableFilterComposer,
          $$MealTypesTableOrderingComposer,
          $$MealTypesTableAnnotationComposer,
          $$MealTypesTableCreateCompanionBuilder,
          $$MealTypesTableUpdateCompanionBuilder,
          (MealType, BaseReferences<_$AppDatabase, $MealTypesTable, MealType>),
          MealType,
          PrefetchHooks Function()
        > {
  $$MealTypesTableTableManager(_$AppDatabase db, $MealTypesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealTypesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> beginTime = const Value.absent(),
                Value<String> endTime = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<String?> remarks = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
              }) => MealTypesCompanion(
                id: id,
                name: name,
                status: status,
                beginTime: beginTime,
                endTime: endTime,
                price: price,
                remarks: remarks,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String status,
                required String beginTime,
                required String endTime,
                Value<double> price = const Value.absent(),
                Value<String?> remarks = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
              }) => MealTypesCompanion.insert(
                id: id,
                name: name,
                status: status,
                beginTime: beginTime,
                endTime: endTime,
                price: price,
                remarks: remarks,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MealTypesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealTypesTable,
      MealType,
      $$MealTypesTableFilterComposer,
      $$MealTypesTableOrderingComposer,
      $$MealTypesTableAnnotationComposer,
      $$MealTypesTableCreateCompanionBuilder,
      $$MealTypesTableUpdateCompanionBuilder,
      (MealType, BaseReferences<_$AppDatabase, $MealTypesTable, MealType>),
      MealType,
      PrefetchHooks Function()
    >;
typedef $$StaffTableCreateCompanionBuilder =
    StaffCompanion Function({
      Value<int> id,
      required String empId,
      required String firstName,
      required String lastName,
      Value<int?> companyId,
      Value<String?> jobTitle,
      Value<String?> empStatus,
      required String employeeType,
      Value<String?> startDate,
      Value<String?> endDate,
      Value<bool?> allowGroupOrder,
      Value<int?> maxOrderCount,
      Value<int?> shiftId,
      Value<int?> totalDependent,
      Value<int?> noOfDependentAssigned,
      Value<int?> departmentId,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
    });
typedef $$StaffTableUpdateCompanionBuilder =
    StaffCompanion Function({
      Value<int> id,
      Value<String> empId,
      Value<String> firstName,
      Value<String> lastName,
      Value<int?> companyId,
      Value<String?> jobTitle,
      Value<String?> empStatus,
      Value<String> employeeType,
      Value<String?> startDate,
      Value<String?> endDate,
      Value<bool?> allowGroupOrder,
      Value<int?> maxOrderCount,
      Value<int?> shiftId,
      Value<int?> totalDependent,
      Value<int?> noOfDependentAssigned,
      Value<int?> departmentId,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
    });

final class $$StaffTableReferences
    extends BaseReferences<_$AppDatabase, $StaffTable, StaffData> {
  $$StaffTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DependentsTable, List<Dependent>>
  _dependentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.dependents,
    aliasName: $_aliasNameGenerator(db.staff.id, db.dependents.staffId),
  );

  $$DependentsTableProcessedTableManager get dependentsRefs {
    final manager = $$DependentsTableTableManager(
      $_db,
      $_db.dependents,
    ).filter((f) => f.staffId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_dependentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BioDataEntriesTable, List<BioDataEntry>>
  _bioDataEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.bioDataEntries,
    aliasName: $_aliasNameGenerator(db.staff.id, db.bioDataEntries.staffId),
  );

  $$BioDataEntriesTableProcessedTableManager get bioDataEntriesRefs {
    final manager = $$BioDataEntriesTableTableManager(
      $_db,
      $_db.bioDataEntries,
    ).filter((f) => f.staffId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_bioDataEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StaffTableFilterComposer extends Composer<_$AppDatabase, $StaffTable> {
  $$StaffTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get empId => $composableBuilder(
    column: $table.empId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get companyId => $composableBuilder(
    column: $table.companyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jobTitle => $composableBuilder(
    column: $table.jobTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get empStatus => $composableBuilder(
    column: $table.empStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get employeeType => $composableBuilder(
    column: $table.employeeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get allowGroupOrder => $composableBuilder(
    column: $table.allowGroupOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxOrderCount => $composableBuilder(
    column: $table.maxOrderCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get shiftId => $composableBuilder(
    column: $table.shiftId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalDependent => $composableBuilder(
    column: $table.totalDependent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get noOfDependentAssigned => $composableBuilder(
    column: $table.noOfDependentAssigned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get departmentId => $composableBuilder(
    column: $table.departmentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> dependentsRefs(
    Expression<bool> Function($$DependentsTableFilterComposer f) f,
  ) {
    final $$DependentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dependents,
      getReferencedColumn: (t) => t.staffId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DependentsTableFilterComposer(
            $db: $db,
            $table: $db.dependents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> bioDataEntriesRefs(
    Expression<bool> Function($$BioDataEntriesTableFilterComposer f) f,
  ) {
    final $$BioDataEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bioDataEntries,
      getReferencedColumn: (t) => t.staffId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BioDataEntriesTableFilterComposer(
            $db: $db,
            $table: $db.bioDataEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StaffTableOrderingComposer
    extends Composer<_$AppDatabase, $StaffTable> {
  $$StaffTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get empId => $composableBuilder(
    column: $table.empId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get companyId => $composableBuilder(
    column: $table.companyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jobTitle => $composableBuilder(
    column: $table.jobTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get empStatus => $composableBuilder(
    column: $table.empStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get employeeType => $composableBuilder(
    column: $table.employeeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get allowGroupOrder => $composableBuilder(
    column: $table.allowGroupOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxOrderCount => $composableBuilder(
    column: $table.maxOrderCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get shiftId => $composableBuilder(
    column: $table.shiftId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalDependent => $composableBuilder(
    column: $table.totalDependent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get noOfDependentAssigned => $composableBuilder(
    column: $table.noOfDependentAssigned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get departmentId => $composableBuilder(
    column: $table.departmentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StaffTableAnnotationComposer
    extends Composer<_$AppDatabase, $StaffTable> {
  $$StaffTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get empId =>
      $composableBuilder(column: $table.empId, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<int> get companyId =>
      $composableBuilder(column: $table.companyId, builder: (column) => column);

  GeneratedColumn<String> get jobTitle =>
      $composableBuilder(column: $table.jobTitle, builder: (column) => column);

  GeneratedColumn<String> get empStatus =>
      $composableBuilder(column: $table.empStatus, builder: (column) => column);

  GeneratedColumn<String> get employeeType => $composableBuilder(
    column: $table.employeeType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<bool> get allowGroupOrder => $composableBuilder(
    column: $table.allowGroupOrder,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxOrderCount => $composableBuilder(
    column: $table.maxOrderCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get shiftId =>
      $composableBuilder(column: $table.shiftId, builder: (column) => column);

  GeneratedColumn<int> get totalDependent => $composableBuilder(
    column: $table.totalDependent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get noOfDependentAssigned => $composableBuilder(
    column: $table.noOfDependentAssigned,
    builder: (column) => column,
  );

  GeneratedColumn<int> get departmentId => $composableBuilder(
    column: $table.departmentId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => column,
  );

  Expression<T> dependentsRefs<T extends Object>(
    Expression<T> Function($$DependentsTableAnnotationComposer a) f,
  ) {
    final $$DependentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dependents,
      getReferencedColumn: (t) => t.staffId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DependentsTableAnnotationComposer(
            $db: $db,
            $table: $db.dependents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> bioDataEntriesRefs<T extends Object>(
    Expression<T> Function($$BioDataEntriesTableAnnotationComposer a) f,
  ) {
    final $$BioDataEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bioDataEntries,
      getReferencedColumn: (t) => t.staffId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BioDataEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.bioDataEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StaffTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StaffTable,
          StaffData,
          $$StaffTableFilterComposer,
          $$StaffTableOrderingComposer,
          $$StaffTableAnnotationComposer,
          $$StaffTableCreateCompanionBuilder,
          $$StaffTableUpdateCompanionBuilder,
          (StaffData, $$StaffTableReferences),
          StaffData,
          PrefetchHooks Function({bool dependentsRefs, bool bioDataEntriesRefs})
        > {
  $$StaffTableTableManager(_$AppDatabase db, $StaffTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StaffTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StaffTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StaffTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> empId = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String> lastName = const Value.absent(),
                Value<int?> companyId = const Value.absent(),
                Value<String?> jobTitle = const Value.absent(),
                Value<String?> empStatus = const Value.absent(),
                Value<String> employeeType = const Value.absent(),
                Value<String?> startDate = const Value.absent(),
                Value<String?> endDate = const Value.absent(),
                Value<bool?> allowGroupOrder = const Value.absent(),
                Value<int?> maxOrderCount = const Value.absent(),
                Value<int?> shiftId = const Value.absent(),
                Value<int?> totalDependent = const Value.absent(),
                Value<int?> noOfDependentAssigned = const Value.absent(),
                Value<int?> departmentId = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
              }) => StaffCompanion(
                id: id,
                empId: empId,
                firstName: firstName,
                lastName: lastName,
                companyId: companyId,
                jobTitle: jobTitle,
                empStatus: empStatus,
                employeeType: employeeType,
                startDate: startDate,
                endDate: endDate,
                allowGroupOrder: allowGroupOrder,
                maxOrderCount: maxOrderCount,
                shiftId: shiftId,
                totalDependent: totalDependent,
                noOfDependentAssigned: noOfDependentAssigned,
                departmentId: departmentId,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String empId,
                required String firstName,
                required String lastName,
                Value<int?> companyId = const Value.absent(),
                Value<String?> jobTitle = const Value.absent(),
                Value<String?> empStatus = const Value.absent(),
                required String employeeType,
                Value<String?> startDate = const Value.absent(),
                Value<String?> endDate = const Value.absent(),
                Value<bool?> allowGroupOrder = const Value.absent(),
                Value<int?> maxOrderCount = const Value.absent(),
                Value<int?> shiftId = const Value.absent(),
                Value<int?> totalDependent = const Value.absent(),
                Value<int?> noOfDependentAssigned = const Value.absent(),
                Value<int?> departmentId = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
              }) => StaffCompanion.insert(
                id: id,
                empId: empId,
                firstName: firstName,
                lastName: lastName,
                companyId: companyId,
                jobTitle: jobTitle,
                empStatus: empStatus,
                employeeType: employeeType,
                startDate: startDate,
                endDate: endDate,
                allowGroupOrder: allowGroupOrder,
                maxOrderCount: maxOrderCount,
                shiftId: shiftId,
                totalDependent: totalDependent,
                noOfDependentAssigned: noOfDependentAssigned,
                departmentId: departmentId,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$StaffTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({dependentsRefs = false, bioDataEntriesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (dependentsRefs) db.dependents,
                    if (bioDataEntriesRefs) db.bioDataEntries,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (dependentsRefs)
                        await $_getPrefetchedData<
                          StaffData,
                          $StaffTable,
                          Dependent
                        >(
                          currentTable: table,
                          referencedTable: $$StaffTableReferences
                              ._dependentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StaffTableReferences(
                                db,
                                table,
                                p0,
                              ).dependentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.staffId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (bioDataEntriesRefs)
                        await $_getPrefetchedData<
                          StaffData,
                          $StaffTable,
                          BioDataEntry
                        >(
                          currentTable: table,
                          referencedTable: $$StaffTableReferences
                              ._bioDataEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StaffTableReferences(
                                db,
                                table,
                                p0,
                              ).bioDataEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.staffId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$StaffTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StaffTable,
      StaffData,
      $$StaffTableFilterComposer,
      $$StaffTableOrderingComposer,
      $$StaffTableAnnotationComposer,
      $$StaffTableCreateCompanionBuilder,
      $$StaffTableUpdateCompanionBuilder,
      (StaffData, $$StaffTableReferences),
      StaffData,
      PrefetchHooks Function({bool dependentsRefs, bool bioDataEntriesRefs})
    >;
typedef $$StaffKitchensTableCreateCompanionBuilder =
    StaffKitchensCompanion Function({
      required int staffId,
      required int kitchenId,
      Value<int> rowid,
    });
typedef $$StaffKitchensTableUpdateCompanionBuilder =
    StaffKitchensCompanion Function({
      Value<int> staffId,
      Value<int> kitchenId,
      Value<int> rowid,
    });

class $$StaffKitchensTableFilterComposer
    extends Composer<_$AppDatabase, $StaffKitchensTable> {
  $$StaffKitchensTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get staffId => $composableBuilder(
    column: $table.staffId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get kitchenId => $composableBuilder(
    column: $table.kitchenId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StaffKitchensTableOrderingComposer
    extends Composer<_$AppDatabase, $StaffKitchensTable> {
  $$StaffKitchensTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get staffId => $composableBuilder(
    column: $table.staffId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get kitchenId => $composableBuilder(
    column: $table.kitchenId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StaffKitchensTableAnnotationComposer
    extends Composer<_$AppDatabase, $StaffKitchensTable> {
  $$StaffKitchensTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get staffId =>
      $composableBuilder(column: $table.staffId, builder: (column) => column);

  GeneratedColumn<int> get kitchenId =>
      $composableBuilder(column: $table.kitchenId, builder: (column) => column);
}

class $$StaffKitchensTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StaffKitchensTable,
          StaffKitchen,
          $$StaffKitchensTableFilterComposer,
          $$StaffKitchensTableOrderingComposer,
          $$StaffKitchensTableAnnotationComposer,
          $$StaffKitchensTableCreateCompanionBuilder,
          $$StaffKitchensTableUpdateCompanionBuilder,
          (
            StaffKitchen,
            BaseReferences<_$AppDatabase, $StaffKitchensTable, StaffKitchen>,
          ),
          StaffKitchen,
          PrefetchHooks Function()
        > {
  $$StaffKitchensTableTableManager(_$AppDatabase db, $StaffKitchensTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StaffKitchensTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StaffKitchensTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StaffKitchensTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> staffId = const Value.absent(),
                Value<int> kitchenId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StaffKitchensCompanion(
                staffId: staffId,
                kitchenId: kitchenId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int staffId,
                required int kitchenId,
                Value<int> rowid = const Value.absent(),
              }) => StaffKitchensCompanion.insert(
                staffId: staffId,
                kitchenId: kitchenId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StaffKitchensTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StaffKitchensTable,
      StaffKitchen,
      $$StaffKitchensTableFilterComposer,
      $$StaffKitchensTableOrderingComposer,
      $$StaffKitchensTableAnnotationComposer,
      $$StaffKitchensTableCreateCompanionBuilder,
      $$StaffKitchensTableUpdateCompanionBuilder,
      (
        StaffKitchen,
        BaseReferences<_$AppDatabase, $StaffKitchensTable, StaffKitchen>,
      ),
      StaffKitchen,
      PrefetchHooks Function()
    >;
typedef $$DependentsTableCreateCompanionBuilder =
    DependentsCompanion Function({
      Value<int> id,
      required String fullname,
      required String status,
      Value<String?> gender,
      Value<int?> staffId,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
    });
typedef $$DependentsTableUpdateCompanionBuilder =
    DependentsCompanion Function({
      Value<int> id,
      Value<String> fullname,
      Value<String> status,
      Value<String?> gender,
      Value<int?> staffId,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
    });

final class $$DependentsTableReferences
    extends BaseReferences<_$AppDatabase, $DependentsTable, Dependent> {
  $$DependentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $StaffTable _staffIdTable(_$AppDatabase db) => db.staff.createAlias(
    $_aliasNameGenerator(db.dependents.staffId, db.staff.id),
  );

  $$StaffTableProcessedTableManager? get staffId {
    final $_column = $_itemColumn<int>('staff_id');
    if ($_column == null) return null;
    final manager = $$StaffTableTableManager(
      $_db,
      $_db.staff,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_staffIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$BioDataEntriesTable, List<BioDataEntry>>
  _bioDataEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.bioDataEntries,
    aliasName: $_aliasNameGenerator(
      db.dependents.id,
      db.bioDataEntries.dependentId,
    ),
  );

  $$BioDataEntriesTableProcessedTableManager get bioDataEntriesRefs {
    final manager = $$BioDataEntriesTableTableManager(
      $_db,
      $_db.bioDataEntries,
    ).filter((f) => f.dependentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_bioDataEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DependentsTableFilterComposer
    extends Composer<_$AppDatabase, $DependentsTable> {
  $$DependentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullname => $composableBuilder(
    column: $table.fullname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$StaffTableFilterComposer get staffId {
    final $$StaffTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.staffId,
      referencedTable: $db.staff,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StaffTableFilterComposer(
            $db: $db,
            $table: $db.staff,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> bioDataEntriesRefs(
    Expression<bool> Function($$BioDataEntriesTableFilterComposer f) f,
  ) {
    final $$BioDataEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bioDataEntries,
      getReferencedColumn: (t) => t.dependentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BioDataEntriesTableFilterComposer(
            $db: $db,
            $table: $db.bioDataEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DependentsTableOrderingComposer
    extends Composer<_$AppDatabase, $DependentsTable> {
  $$DependentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullname => $composableBuilder(
    column: $table.fullname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$StaffTableOrderingComposer get staffId {
    final $$StaffTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.staffId,
      referencedTable: $db.staff,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StaffTableOrderingComposer(
            $db: $db,
            $table: $db.staff,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DependentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DependentsTable> {
  $$DependentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fullname =>
      $composableBuilder(column: $table.fullname, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => column,
  );

  $$StaffTableAnnotationComposer get staffId {
    final $$StaffTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.staffId,
      referencedTable: $db.staff,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StaffTableAnnotationComposer(
            $db: $db,
            $table: $db.staff,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> bioDataEntriesRefs<T extends Object>(
    Expression<T> Function($$BioDataEntriesTableAnnotationComposer a) f,
  ) {
    final $$BioDataEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bioDataEntries,
      getReferencedColumn: (t) => t.dependentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BioDataEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.bioDataEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DependentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DependentsTable,
          Dependent,
          $$DependentsTableFilterComposer,
          $$DependentsTableOrderingComposer,
          $$DependentsTableAnnotationComposer,
          $$DependentsTableCreateCompanionBuilder,
          $$DependentsTableUpdateCompanionBuilder,
          (Dependent, $$DependentsTableReferences),
          Dependent,
          PrefetchHooks Function({bool staffId, bool bioDataEntriesRefs})
        > {
  $$DependentsTableTableManager(_$AppDatabase db, $DependentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DependentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DependentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DependentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> fullname = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<int?> staffId = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
              }) => DependentsCompanion(
                id: id,
                fullname: fullname,
                status: status,
                gender: gender,
                staffId: staffId,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String fullname,
                required String status,
                Value<String?> gender = const Value.absent(),
                Value<int?> staffId = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
              }) => DependentsCompanion.insert(
                id: id,
                fullname: fullname,
                status: status,
                gender: gender,
                staffId: staffId,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DependentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({staffId = false, bioDataEntriesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (bioDataEntriesRefs) db.bioDataEntries,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (staffId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.staffId,
                                    referencedTable: $$DependentsTableReferences
                                        ._staffIdTable(db),
                                    referencedColumn:
                                        $$DependentsTableReferences
                                            ._staffIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (bioDataEntriesRefs)
                        await $_getPrefetchedData<
                          Dependent,
                          $DependentsTable,
                          BioDataEntry
                        >(
                          currentTable: table,
                          referencedTable: $$DependentsTableReferences
                              ._bioDataEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DependentsTableReferences(
                                db,
                                table,
                                p0,
                              ).bioDataEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.dependentId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$DependentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DependentsTable,
      Dependent,
      $$DependentsTableFilterComposer,
      $$DependentsTableOrderingComposer,
      $$DependentsTableAnnotationComposer,
      $$DependentsTableCreateCompanionBuilder,
      $$DependentsTableUpdateCompanionBuilder,
      (Dependent, $$DependentsTableReferences),
      Dependent,
      PrefetchHooks Function({bool staffId, bool bioDataEntriesRefs})
    >;
typedef $$DependentKitchensTableCreateCompanionBuilder =
    DependentKitchensCompanion Function({
      required int dependentId,
      required int kitchenId,
      Value<int> rowid,
    });
typedef $$DependentKitchensTableUpdateCompanionBuilder =
    DependentKitchensCompanion Function({
      Value<int> dependentId,
      Value<int> kitchenId,
      Value<int> rowid,
    });

class $$DependentKitchensTableFilterComposer
    extends Composer<_$AppDatabase, $DependentKitchensTable> {
  $$DependentKitchensTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get dependentId => $composableBuilder(
    column: $table.dependentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get kitchenId => $composableBuilder(
    column: $table.kitchenId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DependentKitchensTableOrderingComposer
    extends Composer<_$AppDatabase, $DependentKitchensTable> {
  $$DependentKitchensTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get dependentId => $composableBuilder(
    column: $table.dependentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get kitchenId => $composableBuilder(
    column: $table.kitchenId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DependentKitchensTableAnnotationComposer
    extends Composer<_$AppDatabase, $DependentKitchensTable> {
  $$DependentKitchensTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get dependentId => $composableBuilder(
    column: $table.dependentId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get kitchenId =>
      $composableBuilder(column: $table.kitchenId, builder: (column) => column);
}

class $$DependentKitchensTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DependentKitchensTable,
          DependentKitchen,
          $$DependentKitchensTableFilterComposer,
          $$DependentKitchensTableOrderingComposer,
          $$DependentKitchensTableAnnotationComposer,
          $$DependentKitchensTableCreateCompanionBuilder,
          $$DependentKitchensTableUpdateCompanionBuilder,
          (
            DependentKitchen,
            BaseReferences<
              _$AppDatabase,
              $DependentKitchensTable,
              DependentKitchen
            >,
          ),
          DependentKitchen,
          PrefetchHooks Function()
        > {
  $$DependentKitchensTableTableManager(
    _$AppDatabase db,
    $DependentKitchensTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DependentKitchensTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DependentKitchensTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DependentKitchensTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> dependentId = const Value.absent(),
                Value<int> kitchenId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DependentKitchensCompanion(
                dependentId: dependentId,
                kitchenId: kitchenId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int dependentId,
                required int kitchenId,
                Value<int> rowid = const Value.absent(),
              }) => DependentKitchensCompanion.insert(
                dependentId: dependentId,
                kitchenId: kitchenId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DependentKitchensTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DependentKitchensTable,
      DependentKitchen,
      $$DependentKitchensTableFilterComposer,
      $$DependentKitchensTableOrderingComposer,
      $$DependentKitchensTableAnnotationComposer,
      $$DependentKitchensTableCreateCompanionBuilder,
      $$DependentKitchensTableUpdateCompanionBuilder,
      (
        DependentKitchen,
        BaseReferences<
          _$AppDatabase,
          $DependentKitchensTable,
          DependentKitchen
        >,
      ),
      DependentKitchen,
      PrefetchHooks Function()
    >;
typedef $$CardsTableCreateCompanionBuilder =
    CardsCompanion Function({
      Value<int> id,
      Value<String?> tagId,
      required double code,
      Value<double?> reversedCode,
      required String status,
      Value<bool?> isAssigned,
      Value<int?> assignedToId,
      Value<String?> assignedToType,
      Value<String?> issuedDate,
      Value<String?> createdAt,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
    });
typedef $$CardsTableUpdateCompanionBuilder =
    CardsCompanion Function({
      Value<int> id,
      Value<String?> tagId,
      Value<double> code,
      Value<double?> reversedCode,
      Value<String> status,
      Value<bool?> isAssigned,
      Value<int?> assignedToId,
      Value<String?> assignedToType,
      Value<String?> issuedDate,
      Value<String?> createdAt,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
    });

class $$CardsTableFilterComposer extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagId => $composableBuilder(
    column: $table.tagId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get reversedCode => $composableBuilder(
    column: $table.reversedCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAssigned => $composableBuilder(
    column: $table.isAssigned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get assignedToId => $composableBuilder(
    column: $table.assignedToId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assignedToType => $composableBuilder(
    column: $table.assignedToType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get issuedDate => $composableBuilder(
    column: $table.issuedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CardsTableOrderingComposer
    extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagId => $composableBuilder(
    column: $table.tagId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get reversedCode => $composableBuilder(
    column: $table.reversedCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAssigned => $composableBuilder(
    column: $table.isAssigned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get assignedToId => $composableBuilder(
    column: $table.assignedToId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assignedToType => $composableBuilder(
    column: $table.assignedToType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get issuedDate => $composableBuilder(
    column: $table.issuedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tagId =>
      $composableBuilder(column: $table.tagId, builder: (column) => column);

  GeneratedColumn<double> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<double> get reversedCode => $composableBuilder(
    column: $table.reversedCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isAssigned => $composableBuilder(
    column: $table.isAssigned,
    builder: (column) => column,
  );

  GeneratedColumn<int> get assignedToId => $composableBuilder(
    column: $table.assignedToId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get assignedToType => $composableBuilder(
    column: $table.assignedToType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get issuedDate => $composableBuilder(
    column: $table.issuedDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => column,
  );
}

class $$CardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardsTable,
          Card,
          $$CardsTableFilterComposer,
          $$CardsTableOrderingComposer,
          $$CardsTableAnnotationComposer,
          $$CardsTableCreateCompanionBuilder,
          $$CardsTableUpdateCompanionBuilder,
          (Card, BaseReferences<_$AppDatabase, $CardsTable, Card>),
          Card,
          PrefetchHooks Function()
        > {
  $$CardsTableTableManager(_$AppDatabase db, $CardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> tagId = const Value.absent(),
                Value<double> code = const Value.absent(),
                Value<double?> reversedCode = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool?> isAssigned = const Value.absent(),
                Value<int?> assignedToId = const Value.absent(),
                Value<String?> assignedToType = const Value.absent(),
                Value<String?> issuedDate = const Value.absent(),
                Value<String?> createdAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
              }) => CardsCompanion(
                id: id,
                tagId: tagId,
                code: code,
                reversedCode: reversedCode,
                status: status,
                isAssigned: isAssigned,
                assignedToId: assignedToId,
                assignedToType: assignedToType,
                issuedDate: issuedDate,
                createdAt: createdAt,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> tagId = const Value.absent(),
                required double code,
                Value<double?> reversedCode = const Value.absent(),
                required String status,
                Value<bool?> isAssigned = const Value.absent(),
                Value<int?> assignedToId = const Value.absent(),
                Value<String?> assignedToType = const Value.absent(),
                Value<String?> issuedDate = const Value.absent(),
                Value<String?> createdAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
              }) => CardsCompanion.insert(
                id: id,
                tagId: tagId,
                code: code,
                reversedCode: reversedCode,
                status: status,
                isAssigned: isAssigned,
                assignedToId: assignedToId,
                assignedToType: assignedToType,
                issuedDate: issuedDate,
                createdAt: createdAt,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardsTable,
      Card,
      $$CardsTableFilterComposer,
      $$CardsTableOrderingComposer,
      $$CardsTableAnnotationComposer,
      $$CardsTableCreateCompanionBuilder,
      $$CardsTableUpdateCompanionBuilder,
      (Card, BaseReferences<_$AppDatabase, $CardsTable, Card>),
      Card,
      PrefetchHooks Function()
    >;
typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      required String firstName,
      required String lastName,
      Value<String?> email,
      Value<String?> phone,
      required String role,
      Value<bool> isActive,
      Value<String?> lastLoginAt,
      Value<String?> actStartDate,
      Value<String?> actEndDate,
      required String createdAt,
      required String updatedAt,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      Value<String> firstName,
      Value<String> lastName,
      Value<String?> email,
      Value<String?> phone,
      Value<String> role,
      Value<bool> isActive,
      Value<String?> lastLoginAt,
      Value<String?> actStartDate,
      Value<String?> actEndDate,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
    });

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastLoginAt => $composableBuilder(
    column: $table.lastLoginAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actStartDate => $composableBuilder(
    column: $table.actStartDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actEndDate => $composableBuilder(
    column: $table.actEndDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastLoginAt => $composableBuilder(
    column: $table.lastLoginAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actStartDate => $composableBuilder(
    column: $table.actStartDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actEndDate => $composableBuilder(
    column: $table.actEndDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get lastLoginAt => $composableBuilder(
    column: $table.lastLoginAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get actStartDate => $composableBuilder(
    column: $table.actStartDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get actEndDate => $composableBuilder(
    column: $table.actEndDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => column,
  );
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
          User,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String> lastName = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String?> lastLoginAt = const Value.absent(),
                Value<String?> actStartDate = const Value.absent(),
                Value<String?> actEndDate = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                firstName: firstName,
                lastName: lastName,
                email: email,
                phone: phone,
                role: role,
                isActive: isActive,
                lastLoginAt: lastLoginAt,
                actStartDate: actStartDate,
                actEndDate: actEndDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String firstName,
                required String lastName,
                Value<String?> email = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                required String role,
                Value<bool> isActive = const Value.absent(),
                Value<String?> lastLoginAt = const Value.absent(),
                Value<String?> actStartDate = const Value.absent(),
                Value<String?> actEndDate = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                firstName: firstName,
                lastName: lastName,
                email: email,
                phone: phone,
                role: role,
                isActive: isActive,
                lastLoginAt: lastLoginAt,
                actStartDate: actStartDate,
                actEndDate: actEndDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
      User,
      PrefetchHooks Function()
    >;
typedef $$UserKitchensTableCreateCompanionBuilder =
    UserKitchensCompanion Function({
      required int userId,
      required int kitchenId,
      Value<int> rowid,
    });
typedef $$UserKitchensTableUpdateCompanionBuilder =
    UserKitchensCompanion Function({
      Value<int> userId,
      Value<int> kitchenId,
      Value<int> rowid,
    });

class $$UserKitchensTableFilterComposer
    extends Composer<_$AppDatabase, $UserKitchensTable> {
  $$UserKitchensTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get kitchenId => $composableBuilder(
    column: $table.kitchenId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserKitchensTableOrderingComposer
    extends Composer<_$AppDatabase, $UserKitchensTable> {
  $$UserKitchensTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get kitchenId => $composableBuilder(
    column: $table.kitchenId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserKitchensTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserKitchensTable> {
  $$UserKitchensTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get kitchenId =>
      $composableBuilder(column: $table.kitchenId, builder: (column) => column);
}

class $$UserKitchensTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserKitchensTable,
          UserKitchen,
          $$UserKitchensTableFilterComposer,
          $$UserKitchensTableOrderingComposer,
          $$UserKitchensTableAnnotationComposer,
          $$UserKitchensTableCreateCompanionBuilder,
          $$UserKitchensTableUpdateCompanionBuilder,
          (
            UserKitchen,
            BaseReferences<_$AppDatabase, $UserKitchensTable, UserKitchen>,
          ),
          UserKitchen,
          PrefetchHooks Function()
        > {
  $$UserKitchensTableTableManager(_$AppDatabase db, $UserKitchensTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserKitchensTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserKitchensTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserKitchensTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> userId = const Value.absent(),
                Value<int> kitchenId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserKitchensCompanion(
                userId: userId,
                kitchenId: kitchenId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int userId,
                required int kitchenId,
                Value<int> rowid = const Value.absent(),
              }) => UserKitchensCompanion.insert(
                userId: userId,
                kitchenId: kitchenId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserKitchensTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserKitchensTable,
      UserKitchen,
      $$UserKitchensTableFilterComposer,
      $$UserKitchensTableOrderingComposer,
      $$UserKitchensTableAnnotationComposer,
      $$UserKitchensTableCreateCompanionBuilder,
      $$UserKitchensTableUpdateCompanionBuilder,
      (
        UserKitchen,
        BaseReferences<_$AppDatabase, $UserKitchensTable, UserKitchen>,
      ),
      UserKitchen,
      PrefetchHooks Function()
    >;
typedef $$OrdersTableCreateCompanionBuilder =
    OrdersCompanion Function({
      Value<int> id,
      required String uuid,
      required String orderCode,
      required String status,
      required String orderType,
      required String mealType,
      required double total,
      required int groupCount,
      Value<String?> description,
      required int orderedById,
      required String employeeType,
      required String createdAt,
      required String updatedAt,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
    });
typedef $$OrdersTableUpdateCompanionBuilder =
    OrdersCompanion Function({
      Value<int> id,
      Value<String> uuid,
      Value<String> orderCode,
      Value<String> status,
      Value<String> orderType,
      Value<String> mealType,
      Value<double> total,
      Value<int> groupCount,
      Value<String?> description,
      Value<int> orderedById,
      Value<String> employeeType,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
    });

class $$OrdersTableFilterComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orderCode => $composableBuilder(
    column: $table.orderCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orderType => $composableBuilder(
    column: $table.orderType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get groupCount => $composableBuilder(
    column: $table.groupCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderedById => $composableBuilder(
    column: $table.orderedById,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get employeeType => $composableBuilder(
    column: $table.employeeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OrdersTableOrderingComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orderCode => $composableBuilder(
    column: $table.orderCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orderType => $composableBuilder(
    column: $table.orderType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get groupCount => $composableBuilder(
    column: $table.groupCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderedById => $composableBuilder(
    column: $table.orderedById,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get employeeType => $composableBuilder(
    column: $table.employeeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OrdersTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get orderCode =>
      $composableBuilder(column: $table.orderCode, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get orderType =>
      $composableBuilder(column: $table.orderType, builder: (column) => column);

  GeneratedColumn<String> get mealType =>
      $composableBuilder(column: $table.mealType, builder: (column) => column);

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<int> get groupCount => $composableBuilder(
    column: $table.groupCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get orderedById => $composableBuilder(
    column: $table.orderedById,
    builder: (column) => column,
  );

  GeneratedColumn<String> get employeeType => $composableBuilder(
    column: $table.employeeType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => column,
  );
}

class $$OrdersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrdersTable,
          Order,
          $$OrdersTableFilterComposer,
          $$OrdersTableOrderingComposer,
          $$OrdersTableAnnotationComposer,
          $$OrdersTableCreateCompanionBuilder,
          $$OrdersTableUpdateCompanionBuilder,
          (Order, BaseReferences<_$AppDatabase, $OrdersTable, Order>),
          Order,
          PrefetchHooks Function()
        > {
  $$OrdersTableTableManager(_$AppDatabase db, $OrdersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrdersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrdersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrdersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<String> orderCode = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> orderType = const Value.absent(),
                Value<String> mealType = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<int> groupCount = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> orderedById = const Value.absent(),
                Value<String> employeeType = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
              }) => OrdersCompanion(
                id: id,
                uuid: uuid,
                orderCode: orderCode,
                status: status,
                orderType: orderType,
                mealType: mealType,
                total: total,
                groupCount: groupCount,
                description: description,
                orderedById: orderedById,
                employeeType: employeeType,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String uuid,
                required String orderCode,
                required String status,
                required String orderType,
                required String mealType,
                required double total,
                required int groupCount,
                Value<String?> description = const Value.absent(),
                required int orderedById,
                required String employeeType,
                required String createdAt,
                required String updatedAt,
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
              }) => OrdersCompanion.insert(
                id: id,
                uuid: uuid,
                orderCode: orderCode,
                status: status,
                orderType: orderType,
                mealType: mealType,
                total: total,
                groupCount: groupCount,
                description: description,
                orderedById: orderedById,
                employeeType: employeeType,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OrdersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrdersTable,
      Order,
      $$OrdersTableFilterComposer,
      $$OrdersTableOrderingComposer,
      $$OrdersTableAnnotationComposer,
      $$OrdersTableCreateCompanionBuilder,
      $$OrdersTableUpdateCompanionBuilder,
      (Order, BaseReferences<_$AppDatabase, $OrdersTable, Order>),
      Order,
      PrefetchHooks Function()
    >;
typedef $$PosDevicesTableCreateCompanionBuilder =
    PosDevicesCompanion Function({
      Value<int> id,
      required String name,
      required String serialNumber,
      Value<String?> model,
      required String status,
      Value<String?> macAddress,
      Value<int?> kitchenId,
      Value<String?> kitchenName,
      required String createdAt,
      required String updatedAt,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
    });
typedef $$PosDevicesTableUpdateCompanionBuilder =
    PosDevicesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> serialNumber,
      Value<String?> model,
      Value<String> status,
      Value<String?> macAddress,
      Value<int?> kitchenId,
      Value<String?> kitchenName,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
    });

class $$PosDevicesTableFilterComposer
    extends Composer<_$AppDatabase, $PosDevicesTable> {
  $$PosDevicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serialNumber => $composableBuilder(
    column: $table.serialNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get macAddress => $composableBuilder(
    column: $table.macAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get kitchenId => $composableBuilder(
    column: $table.kitchenId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kitchenName => $composableBuilder(
    column: $table.kitchenName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PosDevicesTableOrderingComposer
    extends Composer<_$AppDatabase, $PosDevicesTable> {
  $$PosDevicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serialNumber => $composableBuilder(
    column: $table.serialNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get macAddress => $composableBuilder(
    column: $table.macAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get kitchenId => $composableBuilder(
    column: $table.kitchenId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kitchenName => $composableBuilder(
    column: $table.kitchenName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PosDevicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PosDevicesTable> {
  $$PosDevicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get serialNumber => $composableBuilder(
    column: $table.serialNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get macAddress => $composableBuilder(
    column: $table.macAddress,
    builder: (column) => column,
  );

  GeneratedColumn<int> get kitchenId =>
      $composableBuilder(column: $table.kitchenId, builder: (column) => column);

  GeneratedColumn<String> get kitchenName => $composableBuilder(
    column: $table.kitchenName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => column,
  );
}

class $$PosDevicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PosDevicesTable,
          PosDevice,
          $$PosDevicesTableFilterComposer,
          $$PosDevicesTableOrderingComposer,
          $$PosDevicesTableAnnotationComposer,
          $$PosDevicesTableCreateCompanionBuilder,
          $$PosDevicesTableUpdateCompanionBuilder,
          (
            PosDevice,
            BaseReferences<_$AppDatabase, $PosDevicesTable, PosDevice>,
          ),
          PosDevice,
          PrefetchHooks Function()
        > {
  $$PosDevicesTableTableManager(_$AppDatabase db, $PosDevicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PosDevicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PosDevicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PosDevicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> serialNumber = const Value.absent(),
                Value<String?> model = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> macAddress = const Value.absent(),
                Value<int?> kitchenId = const Value.absent(),
                Value<String?> kitchenName = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
              }) => PosDevicesCompanion(
                id: id,
                name: name,
                serialNumber: serialNumber,
                model: model,
                status: status,
                macAddress: macAddress,
                kitchenId: kitchenId,
                kitchenName: kitchenName,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String serialNumber,
                Value<String?> model = const Value.absent(),
                required String status,
                Value<String?> macAddress = const Value.absent(),
                Value<int?> kitchenId = const Value.absent(),
                Value<String?> kitchenName = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
              }) => PosDevicesCompanion.insert(
                id: id,
                name: name,
                serialNumber: serialNumber,
                model: model,
                status: status,
                macAddress: macAddress,
                kitchenId: kitchenId,
                kitchenName: kitchenName,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PosDevicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PosDevicesTable,
      PosDevice,
      $$PosDevicesTableFilterComposer,
      $$PosDevicesTableOrderingComposer,
      $$PosDevicesTableAnnotationComposer,
      $$PosDevicesTableCreateCompanionBuilder,
      $$PosDevicesTableUpdateCompanionBuilder,
      (PosDevice, BaseReferences<_$AppDatabase, $PosDevicesTable, PosDevice>),
      PosDevice,
      PrefetchHooks Function()
    >;
typedef $$ActivityLogsTableCreateCompanionBuilder =
    ActivityLogsCompanion Function({
      Value<int> id,
      required String type,
      required String message,
      Value<String?> actorType,
      Value<int?> actorId,
      Value<String?> actorName,
      Value<String?> sourceTable,
      Value<String?> recordId,
      Value<String?> metadata,
      required String createdAt,
    });
typedef $$ActivityLogsTableUpdateCompanionBuilder =
    ActivityLogsCompanion Function({
      Value<int> id,
      Value<String> type,
      Value<String> message,
      Value<String?> actorType,
      Value<int?> actorId,
      Value<String?> actorName,
      Value<String?> sourceTable,
      Value<String?> recordId,
      Value<String?> metadata,
      Value<String> createdAt,
    });

class $$ActivityLogsTableFilterComposer
    extends Composer<_$AppDatabase, $ActivityLogsTable> {
  $$ActivityLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actorType => $composableBuilder(
    column: $table.actorType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get actorId => $composableBuilder(
    column: $table.actorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actorName => $composableBuilder(
    column: $table.actorName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceTable => $composableBuilder(
    column: $table.sourceTable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActivityLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivityLogsTable> {
  $$ActivityLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actorType => $composableBuilder(
    column: $table.actorType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get actorId => $composableBuilder(
    column: $table.actorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actorName => $composableBuilder(
    column: $table.actorName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceTable => $composableBuilder(
    column: $table.sourceTable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActivityLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivityLogsTable> {
  $$ActivityLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<String> get actorType =>
      $composableBuilder(column: $table.actorType, builder: (column) => column);

  GeneratedColumn<int> get actorId =>
      $composableBuilder(column: $table.actorId, builder: (column) => column);

  GeneratedColumn<String> get actorName =>
      $composableBuilder(column: $table.actorName, builder: (column) => column);

  GeneratedColumn<String> get sourceTable => $composableBuilder(
    column: $table.sourceTable,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ActivityLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivityLogsTable,
          ActivityLog,
          $$ActivityLogsTableFilterComposer,
          $$ActivityLogsTableOrderingComposer,
          $$ActivityLogsTableAnnotationComposer,
          $$ActivityLogsTableCreateCompanionBuilder,
          $$ActivityLogsTableUpdateCompanionBuilder,
          (
            ActivityLog,
            BaseReferences<_$AppDatabase, $ActivityLogsTable, ActivityLog>,
          ),
          ActivityLog,
          PrefetchHooks Function()
        > {
  $$ActivityLogsTableTableManager(_$AppDatabase db, $ActivityLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivityLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivityLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> message = const Value.absent(),
                Value<String?> actorType = const Value.absent(),
                Value<int?> actorId = const Value.absent(),
                Value<String?> actorName = const Value.absent(),
                Value<String?> sourceTable = const Value.absent(),
                Value<String?> recordId = const Value.absent(),
                Value<String?> metadata = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
              }) => ActivityLogsCompanion(
                id: id,
                type: type,
                message: message,
                actorType: actorType,
                actorId: actorId,
                actorName: actorName,
                sourceTable: sourceTable,
                recordId: recordId,
                metadata: metadata,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String type,
                required String message,
                Value<String?> actorType = const Value.absent(),
                Value<int?> actorId = const Value.absent(),
                Value<String?> actorName = const Value.absent(),
                Value<String?> sourceTable = const Value.absent(),
                Value<String?> recordId = const Value.absent(),
                Value<String?> metadata = const Value.absent(),
                required String createdAt,
              }) => ActivityLogsCompanion.insert(
                id: id,
                type: type,
                message: message,
                actorType: actorType,
                actorId: actorId,
                actorName: actorName,
                sourceTable: sourceTable,
                recordId: recordId,
                metadata: metadata,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActivityLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivityLogsTable,
      ActivityLog,
      $$ActivityLogsTableFilterComposer,
      $$ActivityLogsTableOrderingComposer,
      $$ActivityLogsTableAnnotationComposer,
      $$ActivityLogsTableCreateCompanionBuilder,
      $$ActivityLogsTableUpdateCompanionBuilder,
      (
        ActivityLog,
        BaseReferences<_$AppDatabase, $ActivityLogsTable, ActivityLog>,
      ),
      ActivityLog,
      PrefetchHooks Function()
    >;
typedef $$GroupOrdersTableCreateCompanionBuilder =
    GroupOrdersCompanion Function({
      Value<int> id,
      required String uuid,
      required String orderCode,
      required String status,
      required String orderType,
      required String mealType,
      required double total,
      required int groupCount,
      Value<String?> description,
      required String createdAt,
      required String updatedAt,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
    });
typedef $$GroupOrdersTableUpdateCompanionBuilder =
    GroupOrdersCompanion Function({
      Value<int> id,
      Value<String> uuid,
      Value<String> orderCode,
      Value<String> status,
      Value<String> orderType,
      Value<String> mealType,
      Value<double> total,
      Value<int> groupCount,
      Value<String?> description,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
    });

class $$GroupOrdersTableFilterComposer
    extends Composer<_$AppDatabase, $GroupOrdersTable> {
  $$GroupOrdersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orderCode => $composableBuilder(
    column: $table.orderCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orderType => $composableBuilder(
    column: $table.orderType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get groupCount => $composableBuilder(
    column: $table.groupCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GroupOrdersTableOrderingComposer
    extends Composer<_$AppDatabase, $GroupOrdersTable> {
  $$GroupOrdersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orderCode => $composableBuilder(
    column: $table.orderCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orderType => $composableBuilder(
    column: $table.orderType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get groupCount => $composableBuilder(
    column: $table.groupCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GroupOrdersTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroupOrdersTable> {
  $$GroupOrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get orderCode =>
      $composableBuilder(column: $table.orderCode, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get orderType =>
      $composableBuilder(column: $table.orderType, builder: (column) => column);

  GeneratedColumn<String> get mealType =>
      $composableBuilder(column: $table.mealType, builder: (column) => column);

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<int> get groupCount => $composableBuilder(
    column: $table.groupCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => column,
  );
}

class $$GroupOrdersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GroupOrdersTable,
          GroupOrder,
          $$GroupOrdersTableFilterComposer,
          $$GroupOrdersTableOrderingComposer,
          $$GroupOrdersTableAnnotationComposer,
          $$GroupOrdersTableCreateCompanionBuilder,
          $$GroupOrdersTableUpdateCompanionBuilder,
          (
            GroupOrder,
            BaseReferences<_$AppDatabase, $GroupOrdersTable, GroupOrder>,
          ),
          GroupOrder,
          PrefetchHooks Function()
        > {
  $$GroupOrdersTableTableManager(_$AppDatabase db, $GroupOrdersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupOrdersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupOrdersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupOrdersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<String> orderCode = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> orderType = const Value.absent(),
                Value<String> mealType = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<int> groupCount = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
              }) => GroupOrdersCompanion(
                id: id,
                uuid: uuid,
                orderCode: orderCode,
                status: status,
                orderType: orderType,
                mealType: mealType,
                total: total,
                groupCount: groupCount,
                description: description,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String uuid,
                required String orderCode,
                required String status,
                required String orderType,
                required String mealType,
                required double total,
                required int groupCount,
                Value<String?> description = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
              }) => GroupOrdersCompanion.insert(
                id: id,
                uuid: uuid,
                orderCode: orderCode,
                status: status,
                orderType: orderType,
                mealType: mealType,
                total: total,
                groupCount: groupCount,
                description: description,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GroupOrdersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GroupOrdersTable,
      GroupOrder,
      $$GroupOrdersTableFilterComposer,
      $$GroupOrdersTableOrderingComposer,
      $$GroupOrdersTableAnnotationComposer,
      $$GroupOrdersTableCreateCompanionBuilder,
      $$GroupOrdersTableUpdateCompanionBuilder,
      (
        GroupOrder,
        BaseReferences<_$AppDatabase, $GroupOrdersTable, GroupOrder>,
      ),
      GroupOrder,
      PrefetchHooks Function()
    >;
typedef $$ContractorsTableCreateCompanionBuilder =
    ContractorsCompanion Function({
      Value<int> id,
      required String name,
      required String status,
      Value<int> noOfStaffs,
      Value<int?> companyId,
      Value<int?> departmentId,
      Value<String?> company,
      Value<String?> department,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
    });
typedef $$ContractorsTableUpdateCompanionBuilder =
    ContractorsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> status,
      Value<int> noOfStaffs,
      Value<int?> companyId,
      Value<int?> departmentId,
      Value<String?> company,
      Value<String?> department,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
    });

class $$ContractorsTableFilterComposer
    extends Composer<_$AppDatabase, $ContractorsTable> {
  $$ContractorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get noOfStaffs => $composableBuilder(
    column: $table.noOfStaffs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get companyId => $composableBuilder(
    column: $table.companyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get departmentId => $composableBuilder(
    column: $table.departmentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get company => $composableBuilder(
    column: $table.company,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ContractorsTableOrderingComposer
    extends Composer<_$AppDatabase, $ContractorsTable> {
  $$ContractorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get noOfStaffs => $composableBuilder(
    column: $table.noOfStaffs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get companyId => $composableBuilder(
    column: $table.companyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get departmentId => $composableBuilder(
    column: $table.departmentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get company => $composableBuilder(
    column: $table.company,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ContractorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContractorsTable> {
  $$ContractorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get noOfStaffs => $composableBuilder(
    column: $table.noOfStaffs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get companyId =>
      $composableBuilder(column: $table.companyId, builder: (column) => column);

  GeneratedColumn<int> get departmentId => $composableBuilder(
    column: $table.departmentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get company =>
      $composableBuilder(column: $table.company, builder: (column) => column);

  GeneratedColumn<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => column,
  );
}

class $$ContractorsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContractorsTable,
          Contractor,
          $$ContractorsTableFilterComposer,
          $$ContractorsTableOrderingComposer,
          $$ContractorsTableAnnotationComposer,
          $$ContractorsTableCreateCompanionBuilder,
          $$ContractorsTableUpdateCompanionBuilder,
          (
            Contractor,
            BaseReferences<_$AppDatabase, $ContractorsTable, Contractor>,
          ),
          Contractor,
          PrefetchHooks Function()
        > {
  $$ContractorsTableTableManager(_$AppDatabase db, $ContractorsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContractorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContractorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContractorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> noOfStaffs = const Value.absent(),
                Value<int?> companyId = const Value.absent(),
                Value<int?> departmentId = const Value.absent(),
                Value<String?> company = const Value.absent(),
                Value<String?> department = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
              }) => ContractorsCompanion(
                id: id,
                name: name,
                status: status,
                noOfStaffs: noOfStaffs,
                companyId: companyId,
                departmentId: departmentId,
                company: company,
                department: department,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String status,
                Value<int> noOfStaffs = const Value.absent(),
                Value<int?> companyId = const Value.absent(),
                Value<int?> departmentId = const Value.absent(),
                Value<String?> company = const Value.absent(),
                Value<String?> department = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
              }) => ContractorsCompanion.insert(
                id: id,
                name: name,
                status: status,
                noOfStaffs: noOfStaffs,
                companyId: companyId,
                departmentId: departmentId,
                company: company,
                department: department,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ContractorsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContractorsTable,
      Contractor,
      $$ContractorsTableFilterComposer,
      $$ContractorsTableOrderingComposer,
      $$ContractorsTableAnnotationComposer,
      $$ContractorsTableCreateCompanionBuilder,
      $$ContractorsTableUpdateCompanionBuilder,
      (
        Contractor,
        BaseReferences<_$AppDatabase, $ContractorsTable, Contractor>,
      ),
      Contractor,
      PrefetchHooks Function()
    >;
typedef $$ContractorStaffTableTableCreateCompanionBuilder =
    ContractorStaffTableCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> gender,
      Value<int?> contractorId,
      Value<String?> contractorName,
      Value<int?> companyId,
      Value<String?> company,
      Value<int?> departmentId,
      Value<String?> department,
      required String startDate,
      required String endDate,
      Value<bool> isCharged,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
    });
typedef $$ContractorStaffTableTableUpdateCompanionBuilder =
    ContractorStaffTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> gender,
      Value<int?> contractorId,
      Value<String?> contractorName,
      Value<int?> companyId,
      Value<String?> company,
      Value<int?> departmentId,
      Value<String?> department,
      Value<String> startDate,
      Value<String> endDate,
      Value<bool> isCharged,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
    });

final class $$ContractorStaffTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ContractorStaffTableTable,
          ContractorStaffTableData
        > {
  $$ContractorStaffTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$BioDataEntriesTable, List<BioDataEntry>>
  _bioDataEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.bioDataEntries,
    aliasName: $_aliasNameGenerator(
      db.contractorStaffTable.id,
      db.bioDataEntries.contractorStaffId,
    ),
  );

  $$BioDataEntriesTableProcessedTableManager get bioDataEntriesRefs {
    final manager = $$BioDataEntriesTableTableManager(
      $_db,
      $_db.bioDataEntries,
    ).filter((f) => f.contractorStaffId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_bioDataEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ContractorStaffTableTableFilterComposer
    extends Composer<_$AppDatabase, $ContractorStaffTableTable> {
  $$ContractorStaffTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get contractorId => $composableBuilder(
    column: $table.contractorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contractorName => $composableBuilder(
    column: $table.contractorName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get companyId => $composableBuilder(
    column: $table.companyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get company => $composableBuilder(
    column: $table.company,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get departmentId => $composableBuilder(
    column: $table.departmentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCharged => $composableBuilder(
    column: $table.isCharged,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> bioDataEntriesRefs(
    Expression<bool> Function($$BioDataEntriesTableFilterComposer f) f,
  ) {
    final $$BioDataEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bioDataEntries,
      getReferencedColumn: (t) => t.contractorStaffId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BioDataEntriesTableFilterComposer(
            $db: $db,
            $table: $db.bioDataEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ContractorStaffTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ContractorStaffTableTable> {
  $$ContractorStaffTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get contractorId => $composableBuilder(
    column: $table.contractorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contractorName => $composableBuilder(
    column: $table.contractorName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get companyId => $composableBuilder(
    column: $table.companyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get company => $composableBuilder(
    column: $table.company,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get departmentId => $composableBuilder(
    column: $table.departmentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCharged => $composableBuilder(
    column: $table.isCharged,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ContractorStaffTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContractorStaffTableTable> {
  $$ContractorStaffTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<int> get contractorId => $composableBuilder(
    column: $table.contractorId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contractorName => $composableBuilder(
    column: $table.contractorName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get companyId =>
      $composableBuilder(column: $table.companyId, builder: (column) => column);

  GeneratedColumn<String> get company =>
      $composableBuilder(column: $table.company, builder: (column) => column);

  GeneratedColumn<int> get departmentId => $composableBuilder(
    column: $table.departmentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => column,
  );

  GeneratedColumn<String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<bool> get isCharged =>
      $composableBuilder(column: $table.isCharged, builder: (column) => column);

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => column,
  );

  Expression<T> bioDataEntriesRefs<T extends Object>(
    Expression<T> Function($$BioDataEntriesTableAnnotationComposer a) f,
  ) {
    final $$BioDataEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bioDataEntries,
      getReferencedColumn: (t) => t.contractorStaffId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BioDataEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.bioDataEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ContractorStaffTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContractorStaffTableTable,
          ContractorStaffTableData,
          $$ContractorStaffTableTableFilterComposer,
          $$ContractorStaffTableTableOrderingComposer,
          $$ContractorStaffTableTableAnnotationComposer,
          $$ContractorStaffTableTableCreateCompanionBuilder,
          $$ContractorStaffTableTableUpdateCompanionBuilder,
          (ContractorStaffTableData, $$ContractorStaffTableTableReferences),
          ContractorStaffTableData,
          PrefetchHooks Function({bool bioDataEntriesRefs})
        > {
  $$ContractorStaffTableTableTableManager(
    _$AppDatabase db,
    $ContractorStaffTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContractorStaffTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContractorStaffTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ContractorStaffTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<int?> contractorId = const Value.absent(),
                Value<String?> contractorName = const Value.absent(),
                Value<int?> companyId = const Value.absent(),
                Value<String?> company = const Value.absent(),
                Value<int?> departmentId = const Value.absent(),
                Value<String?> department = const Value.absent(),
                Value<String> startDate = const Value.absent(),
                Value<String> endDate = const Value.absent(),
                Value<bool> isCharged = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
              }) => ContractorStaffTableCompanion(
                id: id,
                name: name,
                gender: gender,
                contractorId: contractorId,
                contractorName: contractorName,
                companyId: companyId,
                company: company,
                departmentId: departmentId,
                department: department,
                startDate: startDate,
                endDate: endDate,
                isCharged: isCharged,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> gender = const Value.absent(),
                Value<int?> contractorId = const Value.absent(),
                Value<String?> contractorName = const Value.absent(),
                Value<int?> companyId = const Value.absent(),
                Value<String?> company = const Value.absent(),
                Value<int?> departmentId = const Value.absent(),
                Value<String?> department = const Value.absent(),
                required String startDate,
                required String endDate,
                Value<bool> isCharged = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
              }) => ContractorStaffTableCompanion.insert(
                id: id,
                name: name,
                gender: gender,
                contractorId: contractorId,
                contractorName: contractorName,
                companyId: companyId,
                company: company,
                departmentId: departmentId,
                department: department,
                startDate: startDate,
                endDate: endDate,
                isCharged: isCharged,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ContractorStaffTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bioDataEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (bioDataEntriesRefs) db.bioDataEntries,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (bioDataEntriesRefs)
                    await $_getPrefetchedData<
                      ContractorStaffTableData,
                      $ContractorStaffTableTable,
                      BioDataEntry
                    >(
                      currentTable: table,
                      referencedTable: $$ContractorStaffTableTableReferences
                          ._bioDataEntriesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ContractorStaffTableTableReferences(
                            db,
                            table,
                            p0,
                          ).bioDataEntriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.contractorStaffId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ContractorStaffTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContractorStaffTableTable,
      ContractorStaffTableData,
      $$ContractorStaffTableTableFilterComposer,
      $$ContractorStaffTableTableOrderingComposer,
      $$ContractorStaffTableTableAnnotationComposer,
      $$ContractorStaffTableTableCreateCompanionBuilder,
      $$ContractorStaffTableTableUpdateCompanionBuilder,
      (ContractorStaffTableData, $$ContractorStaffTableTableReferences),
      ContractorStaffTableData,
      PrefetchHooks Function({bool bioDataEntriesRefs})
    >;
typedef $$ContractorStaffKitchensTableCreateCompanionBuilder =
    ContractorStaffKitchensCompanion Function({
      required int contractorStaffId,
      required int kitchenId,
      Value<int> rowid,
    });
typedef $$ContractorStaffKitchensTableUpdateCompanionBuilder =
    ContractorStaffKitchensCompanion Function({
      Value<int> contractorStaffId,
      Value<int> kitchenId,
      Value<int> rowid,
    });

class $$ContractorStaffKitchensTableFilterComposer
    extends Composer<_$AppDatabase, $ContractorStaffKitchensTable> {
  $$ContractorStaffKitchensTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get contractorStaffId => $composableBuilder(
    column: $table.contractorStaffId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get kitchenId => $composableBuilder(
    column: $table.kitchenId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ContractorStaffKitchensTableOrderingComposer
    extends Composer<_$AppDatabase, $ContractorStaffKitchensTable> {
  $$ContractorStaffKitchensTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get contractorStaffId => $composableBuilder(
    column: $table.contractorStaffId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get kitchenId => $composableBuilder(
    column: $table.kitchenId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ContractorStaffKitchensTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContractorStaffKitchensTable> {
  $$ContractorStaffKitchensTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get contractorStaffId => $composableBuilder(
    column: $table.contractorStaffId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get kitchenId =>
      $composableBuilder(column: $table.kitchenId, builder: (column) => column);
}

class $$ContractorStaffKitchensTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContractorStaffKitchensTable,
          ContractorStaffKitchen,
          $$ContractorStaffKitchensTableFilterComposer,
          $$ContractorStaffKitchensTableOrderingComposer,
          $$ContractorStaffKitchensTableAnnotationComposer,
          $$ContractorStaffKitchensTableCreateCompanionBuilder,
          $$ContractorStaffKitchensTableUpdateCompanionBuilder,
          (
            ContractorStaffKitchen,
            BaseReferences<
              _$AppDatabase,
              $ContractorStaffKitchensTable,
              ContractorStaffKitchen
            >,
          ),
          ContractorStaffKitchen,
          PrefetchHooks Function()
        > {
  $$ContractorStaffKitchensTableTableManager(
    _$AppDatabase db,
    $ContractorStaffKitchensTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContractorStaffKitchensTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ContractorStaffKitchensTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ContractorStaffKitchensTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> contractorStaffId = const Value.absent(),
                Value<int> kitchenId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContractorStaffKitchensCompanion(
                contractorStaffId: contractorStaffId,
                kitchenId: kitchenId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int contractorStaffId,
                required int kitchenId,
                Value<int> rowid = const Value.absent(),
              }) => ContractorStaffKitchensCompanion.insert(
                contractorStaffId: contractorStaffId,
                kitchenId: kitchenId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ContractorStaffKitchensTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContractorStaffKitchensTable,
      ContractorStaffKitchen,
      $$ContractorStaffKitchensTableFilterComposer,
      $$ContractorStaffKitchensTableOrderingComposer,
      $$ContractorStaffKitchensTableAnnotationComposer,
      $$ContractorStaffKitchensTableCreateCompanionBuilder,
      $$ContractorStaffKitchensTableUpdateCompanionBuilder,
      (
        ContractorStaffKitchen,
        BaseReferences<
          _$AppDatabase,
          $ContractorStaffKitchensTable,
          ContractorStaffKitchen
        >,
      ),
      ContractorStaffKitchen,
      PrefetchHooks Function()
    >;
typedef $$VisitorsTableCreateCompanionBuilder =
    VisitorsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> gender,
      Value<String?> startDate,
      Value<String?> endTime,
      Value<int?> companyId,
      Value<String?> company,
      Value<int?> departmentId,
      Value<String?> department,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
    });
typedef $$VisitorsTableUpdateCompanionBuilder =
    VisitorsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> gender,
      Value<String?> startDate,
      Value<String?> endTime,
      Value<int?> companyId,
      Value<String?> company,
      Value<int?> departmentId,
      Value<String?> department,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
    });

final class $$VisitorsTableReferences
    extends BaseReferences<_$AppDatabase, $VisitorsTable, Visitor> {
  $$VisitorsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BioDataEntriesTable, List<BioDataEntry>>
  _bioDataEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.bioDataEntries,
    aliasName: $_aliasNameGenerator(
      db.visitors.id,
      db.bioDataEntries.visitorId,
    ),
  );

  $$BioDataEntriesTableProcessedTableManager get bioDataEntriesRefs {
    final manager = $$BioDataEntriesTableTableManager(
      $_db,
      $_db.bioDataEntries,
    ).filter((f) => f.visitorId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_bioDataEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$VisitorsTableFilterComposer
    extends Composer<_$AppDatabase, $VisitorsTable> {
  $$VisitorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get companyId => $composableBuilder(
    column: $table.companyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get company => $composableBuilder(
    column: $table.company,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get departmentId => $composableBuilder(
    column: $table.departmentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> bioDataEntriesRefs(
    Expression<bool> Function($$BioDataEntriesTableFilterComposer f) f,
  ) {
    final $$BioDataEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bioDataEntries,
      getReferencedColumn: (t) => t.visitorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BioDataEntriesTableFilterComposer(
            $db: $db,
            $table: $db.bioDataEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VisitorsTableOrderingComposer
    extends Composer<_$AppDatabase, $VisitorsTable> {
  $$VisitorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get companyId => $composableBuilder(
    column: $table.companyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get company => $composableBuilder(
    column: $table.company,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get departmentId => $composableBuilder(
    column: $table.departmentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VisitorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VisitorsTable> {
  $$VisitorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<int> get companyId =>
      $composableBuilder(column: $table.companyId, builder: (column) => column);

  GeneratedColumn<String> get company =>
      $composableBuilder(column: $table.company, builder: (column) => column);

  GeneratedColumn<int> get departmentId => $composableBuilder(
    column: $table.departmentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => column,
  );

  Expression<T> bioDataEntriesRefs<T extends Object>(
    Expression<T> Function($$BioDataEntriesTableAnnotationComposer a) f,
  ) {
    final $$BioDataEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bioDataEntries,
      getReferencedColumn: (t) => t.visitorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BioDataEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.bioDataEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VisitorsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VisitorsTable,
          Visitor,
          $$VisitorsTableFilterComposer,
          $$VisitorsTableOrderingComposer,
          $$VisitorsTableAnnotationComposer,
          $$VisitorsTableCreateCompanionBuilder,
          $$VisitorsTableUpdateCompanionBuilder,
          (Visitor, $$VisitorsTableReferences),
          Visitor,
          PrefetchHooks Function({bool bioDataEntriesRefs})
        > {
  $$VisitorsTableTableManager(_$AppDatabase db, $VisitorsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VisitorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VisitorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VisitorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<String?> startDate = const Value.absent(),
                Value<String?> endTime = const Value.absent(),
                Value<int?> companyId = const Value.absent(),
                Value<String?> company = const Value.absent(),
                Value<int?> departmentId = const Value.absent(),
                Value<String?> department = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
              }) => VisitorsCompanion(
                id: id,
                name: name,
                gender: gender,
                startDate: startDate,
                endTime: endTime,
                companyId: companyId,
                company: company,
                departmentId: departmentId,
                department: department,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> gender = const Value.absent(),
                Value<String?> startDate = const Value.absent(),
                Value<String?> endTime = const Value.absent(),
                Value<int?> companyId = const Value.absent(),
                Value<String?> company = const Value.absent(),
                Value<int?> departmentId = const Value.absent(),
                Value<String?> department = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
              }) => VisitorsCompanion.insert(
                id: id,
                name: name,
                gender: gender,
                startDate: startDate,
                endTime: endTime,
                companyId: companyId,
                company: company,
                departmentId: departmentId,
                department: department,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$VisitorsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bioDataEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (bioDataEntriesRefs) db.bioDataEntries,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (bioDataEntriesRefs)
                    await $_getPrefetchedData<
                      Visitor,
                      $VisitorsTable,
                      BioDataEntry
                    >(
                      currentTable: table,
                      referencedTable: $$VisitorsTableReferences
                          ._bioDataEntriesRefsTable(db),
                      managerFromTypedResult: (p0) => $$VisitorsTableReferences(
                        db,
                        table,
                        p0,
                      ).bioDataEntriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.visitorId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$VisitorsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VisitorsTable,
      Visitor,
      $$VisitorsTableFilterComposer,
      $$VisitorsTableOrderingComposer,
      $$VisitorsTableAnnotationComposer,
      $$VisitorsTableCreateCompanionBuilder,
      $$VisitorsTableUpdateCompanionBuilder,
      (Visitor, $$VisitorsTableReferences),
      Visitor,
      PrefetchHooks Function({bool bioDataEntriesRefs})
    >;
typedef $$VisitorKitchensTableCreateCompanionBuilder =
    VisitorKitchensCompanion Function({
      required int visitorId,
      required int kitchenId,
      Value<int> rowid,
    });
typedef $$VisitorKitchensTableUpdateCompanionBuilder =
    VisitorKitchensCompanion Function({
      Value<int> visitorId,
      Value<int> kitchenId,
      Value<int> rowid,
    });

class $$VisitorKitchensTableFilterComposer
    extends Composer<_$AppDatabase, $VisitorKitchensTable> {
  $$VisitorKitchensTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get visitorId => $composableBuilder(
    column: $table.visitorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get kitchenId => $composableBuilder(
    column: $table.kitchenId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VisitorKitchensTableOrderingComposer
    extends Composer<_$AppDatabase, $VisitorKitchensTable> {
  $$VisitorKitchensTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get visitorId => $composableBuilder(
    column: $table.visitorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get kitchenId => $composableBuilder(
    column: $table.kitchenId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VisitorKitchensTableAnnotationComposer
    extends Composer<_$AppDatabase, $VisitorKitchensTable> {
  $$VisitorKitchensTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get visitorId =>
      $composableBuilder(column: $table.visitorId, builder: (column) => column);

  GeneratedColumn<int> get kitchenId =>
      $composableBuilder(column: $table.kitchenId, builder: (column) => column);
}

class $$VisitorKitchensTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VisitorKitchensTable,
          VisitorKitchen,
          $$VisitorKitchensTableFilterComposer,
          $$VisitorKitchensTableOrderingComposer,
          $$VisitorKitchensTableAnnotationComposer,
          $$VisitorKitchensTableCreateCompanionBuilder,
          $$VisitorKitchensTableUpdateCompanionBuilder,
          (
            VisitorKitchen,
            BaseReferences<
              _$AppDatabase,
              $VisitorKitchensTable,
              VisitorKitchen
            >,
          ),
          VisitorKitchen,
          PrefetchHooks Function()
        > {
  $$VisitorKitchensTableTableManager(
    _$AppDatabase db,
    $VisitorKitchensTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VisitorKitchensTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VisitorKitchensTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VisitorKitchensTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> visitorId = const Value.absent(),
                Value<int> kitchenId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VisitorKitchensCompanion(
                visitorId: visitorId,
                kitchenId: kitchenId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int visitorId,
                required int kitchenId,
                Value<int> rowid = const Value.absent(),
              }) => VisitorKitchensCompanion.insert(
                visitorId: visitorId,
                kitchenId: kitchenId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VisitorKitchensTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VisitorKitchensTable,
      VisitorKitchen,
      $$VisitorKitchensTableFilterComposer,
      $$VisitorKitchensTableOrderingComposer,
      $$VisitorKitchensTableAnnotationComposer,
      $$VisitorKitchensTableCreateCompanionBuilder,
      $$VisitorKitchensTableUpdateCompanionBuilder,
      (
        VisitorKitchen,
        BaseReferences<_$AppDatabase, $VisitorKitchensTable, VisitorKitchen>,
      ),
      VisitorKitchen,
      PrefetchHooks Function()
    >;
typedef $$BioDataEntriesTableCreateCompanionBuilder =
    BioDataEntriesCompanion Function({
      Value<int> id,
      Value<int?> staffId,
      Value<int?> dependentId,
      Value<int?> contractorStaffId,
      Value<int?> visitorId,
      required String finger,
      required String dataBase64,
      Value<bool> isActive,
      required String createdAt,
      required String updatedAt,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
    });
typedef $$BioDataEntriesTableUpdateCompanionBuilder =
    BioDataEntriesCompanion Function({
      Value<int> id,
      Value<int?> staffId,
      Value<int?> dependentId,
      Value<int?> contractorStaffId,
      Value<int?> visitorId,
      Value<String> finger,
      Value<String> dataBase64,
      Value<bool> isActive,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
    });

final class $$BioDataEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $BioDataEntriesTable, BioDataEntry> {
  $$BioDataEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StaffTable _staffIdTable(_$AppDatabase db) => db.staff.createAlias(
    $_aliasNameGenerator(db.bioDataEntries.staffId, db.staff.id),
  );

  $$StaffTableProcessedTableManager? get staffId {
    final $_column = $_itemColumn<int>('staff_id');
    if ($_column == null) return null;
    final manager = $$StaffTableTableManager(
      $_db,
      $_db.staff,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_staffIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $DependentsTable _dependentIdTable(_$AppDatabase db) =>
      db.dependents.createAlias(
        $_aliasNameGenerator(db.bioDataEntries.dependentId, db.dependents.id),
      );

  $$DependentsTableProcessedTableManager? get dependentId {
    final $_column = $_itemColumn<int>('dependent_id');
    if ($_column == null) return null;
    final manager = $$DependentsTableTableManager(
      $_db,
      $_db.dependents,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_dependentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ContractorStaffTableTable _contractorStaffIdTable(_$AppDatabase db) =>
      db.contractorStaffTable.createAlias(
        $_aliasNameGenerator(
          db.bioDataEntries.contractorStaffId,
          db.contractorStaffTable.id,
        ),
      );

  $$ContractorStaffTableTableProcessedTableManager? get contractorStaffId {
    final $_column = $_itemColumn<int>('contractor_staff_id');
    if ($_column == null) return null;
    final manager = $$ContractorStaffTableTableTableManager(
      $_db,
      $_db.contractorStaffTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_contractorStaffIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $VisitorsTable _visitorIdTable(_$AppDatabase db) =>
      db.visitors.createAlias(
        $_aliasNameGenerator(db.bioDataEntries.visitorId, db.visitors.id),
      );

  $$VisitorsTableProcessedTableManager? get visitorId {
    final $_column = $_itemColumn<int>('visitor_id');
    if ($_column == null) return null;
    final manager = $$VisitorsTableTableManager(
      $_db,
      $_db.visitors,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_visitorIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BioDataEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $BioDataEntriesTable> {
  $$BioDataEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get finger => $composableBuilder(
    column: $table.finger,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dataBase64 => $composableBuilder(
    column: $table.dataBase64,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$StaffTableFilterComposer get staffId {
    final $$StaffTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.staffId,
      referencedTable: $db.staff,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StaffTableFilterComposer(
            $db: $db,
            $table: $db.staff,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DependentsTableFilterComposer get dependentId {
    final $$DependentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dependentId,
      referencedTable: $db.dependents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DependentsTableFilterComposer(
            $db: $db,
            $table: $db.dependents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ContractorStaffTableTableFilterComposer get contractorStaffId {
    final $$ContractorStaffTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contractorStaffId,
      referencedTable: $db.contractorStaffTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractorStaffTableTableFilterComposer(
            $db: $db,
            $table: $db.contractorStaffTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VisitorsTableFilterComposer get visitorId {
    final $$VisitorsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.visitorId,
      referencedTable: $db.visitors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisitorsTableFilterComposer(
            $db: $db,
            $table: $db.visitors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BioDataEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $BioDataEntriesTable> {
  $$BioDataEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get finger => $composableBuilder(
    column: $table.finger,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dataBase64 => $composableBuilder(
    column: $table.dataBase64,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$StaffTableOrderingComposer get staffId {
    final $$StaffTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.staffId,
      referencedTable: $db.staff,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StaffTableOrderingComposer(
            $db: $db,
            $table: $db.staff,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DependentsTableOrderingComposer get dependentId {
    final $$DependentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dependentId,
      referencedTable: $db.dependents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DependentsTableOrderingComposer(
            $db: $db,
            $table: $db.dependents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ContractorStaffTableTableOrderingComposer get contractorStaffId {
    final $$ContractorStaffTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.contractorStaffId,
          referencedTable: $db.contractorStaffTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ContractorStaffTableTableOrderingComposer(
                $db: $db,
                $table: $db.contractorStaffTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$VisitorsTableOrderingComposer get visitorId {
    final $$VisitorsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.visitorId,
      referencedTable: $db.visitors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisitorsTableOrderingComposer(
            $db: $db,
            $table: $db.visitors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BioDataEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BioDataEntriesTable> {
  $$BioDataEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get finger =>
      $composableBuilder(column: $table.finger, builder: (column) => column);

  GeneratedColumn<String> get dataBase64 => $composableBuilder(
    column: $table.dataBase64,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => column,
  );

  $$StaffTableAnnotationComposer get staffId {
    final $$StaffTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.staffId,
      referencedTable: $db.staff,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StaffTableAnnotationComposer(
            $db: $db,
            $table: $db.staff,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DependentsTableAnnotationComposer get dependentId {
    final $$DependentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dependentId,
      referencedTable: $db.dependents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DependentsTableAnnotationComposer(
            $db: $db,
            $table: $db.dependents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ContractorStaffTableTableAnnotationComposer get contractorStaffId {
    final $$ContractorStaffTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.contractorStaffId,
          referencedTable: $db.contractorStaffTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ContractorStaffTableTableAnnotationComposer(
                $db: $db,
                $table: $db.contractorStaffTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$VisitorsTableAnnotationComposer get visitorId {
    final $$VisitorsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.visitorId,
      referencedTable: $db.visitors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisitorsTableAnnotationComposer(
            $db: $db,
            $table: $db.visitors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BioDataEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BioDataEntriesTable,
          BioDataEntry,
          $$BioDataEntriesTableFilterComposer,
          $$BioDataEntriesTableOrderingComposer,
          $$BioDataEntriesTableAnnotationComposer,
          $$BioDataEntriesTableCreateCompanionBuilder,
          $$BioDataEntriesTableUpdateCompanionBuilder,
          (BioDataEntry, $$BioDataEntriesTableReferences),
          BioDataEntry,
          PrefetchHooks Function({
            bool staffId,
            bool dependentId,
            bool contractorStaffId,
            bool visitorId,
          })
        > {
  $$BioDataEntriesTableTableManager(
    _$AppDatabase db,
    $BioDataEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BioDataEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BioDataEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BioDataEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> staffId = const Value.absent(),
                Value<int?> dependentId = const Value.absent(),
                Value<int?> contractorStaffId = const Value.absent(),
                Value<int?> visitorId = const Value.absent(),
                Value<String> finger = const Value.absent(),
                Value<String> dataBase64 = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
              }) => BioDataEntriesCompanion(
                id: id,
                staffId: staffId,
                dependentId: dependentId,
                contractorStaffId: contractorStaffId,
                visitorId: visitorId,
                finger: finger,
                dataBase64: dataBase64,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> staffId = const Value.absent(),
                Value<int?> dependentId = const Value.absent(),
                Value<int?> contractorStaffId = const Value.absent(),
                Value<int?> visitorId = const Value.absent(),
                required String finger,
                required String dataBase64,
                Value<bool> isActive = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
              }) => BioDataEntriesCompanion.insert(
                id: id,
                staffId: staffId,
                dependentId: dependentId,
                contractorStaffId: contractorStaffId,
                visitorId: visitorId,
                finger: finger,
                dataBase64: dataBase64,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BioDataEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                staffId = false,
                dependentId = false,
                contractorStaffId = false,
                visitorId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (staffId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.staffId,
                                    referencedTable:
                                        $$BioDataEntriesTableReferences
                                            ._staffIdTable(db),
                                    referencedColumn:
                                        $$BioDataEntriesTableReferences
                                            ._staffIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (dependentId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.dependentId,
                                    referencedTable:
                                        $$BioDataEntriesTableReferences
                                            ._dependentIdTable(db),
                                    referencedColumn:
                                        $$BioDataEntriesTableReferences
                                            ._dependentIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (contractorStaffId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.contractorStaffId,
                                    referencedTable:
                                        $$BioDataEntriesTableReferences
                                            ._contractorStaffIdTable(db),
                                    referencedColumn:
                                        $$BioDataEntriesTableReferences
                                            ._contractorStaffIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (visitorId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.visitorId,
                                    referencedTable:
                                        $$BioDataEntriesTableReferences
                                            ._visitorIdTable(db),
                                    referencedColumn:
                                        $$BioDataEntriesTableReferences
                                            ._visitorIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$BioDataEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BioDataEntriesTable,
      BioDataEntry,
      $$BioDataEntriesTableFilterComposer,
      $$BioDataEntriesTableOrderingComposer,
      $$BioDataEntriesTableAnnotationComposer,
      $$BioDataEntriesTableCreateCompanionBuilder,
      $$BioDataEntriesTableUpdateCompanionBuilder,
      (BioDataEntry, $$BioDataEntriesTableReferences),
      BioDataEntry,
      PrefetchHooks Function({
        bool staffId,
        bool dependentId,
        bool contractorStaffId,
        bool visitorId,
      })
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SitesTableTableManager get sites =>
      $$SitesTableTableManager(_db, _db.sites);
  $$DepartmentsTableTableManager get departments =>
      $$DepartmentsTableTableManager(_db, _db.departments);
  $$ShiftsTableTableManager get shifts =>
      $$ShiftsTableTableManager(_db, _db.shifts);
  $$ShiftMealTypesTableTableManager get shiftMealTypes =>
      $$ShiftMealTypesTableTableManager(_db, _db.shiftMealTypes);
  $$KitchensTableTableManager get kitchens =>
      $$KitchensTableTableManager(_db, _db.kitchens);
  $$MenuTypesTableTableManager get menuTypes =>
      $$MenuTypesTableTableManager(_db, _db.menuTypes);
  $$MealTypesTableTableManager get mealTypes =>
      $$MealTypesTableTableManager(_db, _db.mealTypes);
  $$StaffTableTableManager get staff =>
      $$StaffTableTableManager(_db, _db.staff);
  $$StaffKitchensTableTableManager get staffKitchens =>
      $$StaffKitchensTableTableManager(_db, _db.staffKitchens);
  $$DependentsTableTableManager get dependents =>
      $$DependentsTableTableManager(_db, _db.dependents);
  $$DependentKitchensTableTableManager get dependentKitchens =>
      $$DependentKitchensTableTableManager(_db, _db.dependentKitchens);
  $$CardsTableTableManager get cards =>
      $$CardsTableTableManager(_db, _db.cards);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$UserKitchensTableTableManager get userKitchens =>
      $$UserKitchensTableTableManager(_db, _db.userKitchens);
  $$OrdersTableTableManager get orders =>
      $$OrdersTableTableManager(_db, _db.orders);
  $$PosDevicesTableTableManager get posDevices =>
      $$PosDevicesTableTableManager(_db, _db.posDevices);
  $$ActivityLogsTableTableManager get activityLogs =>
      $$ActivityLogsTableTableManager(_db, _db.activityLogs);
  $$GroupOrdersTableTableManager get groupOrders =>
      $$GroupOrdersTableTableManager(_db, _db.groupOrders);
  $$ContractorsTableTableManager get contractors =>
      $$ContractorsTableTableManager(_db, _db.contractors);
  $$ContractorStaffTableTableTableManager get contractorStaffTable =>
      $$ContractorStaffTableTableTableManager(_db, _db.contractorStaffTable);
  $$ContractorStaffKitchensTableTableManager get contractorStaffKitchens =>
      $$ContractorStaffKitchensTableTableManager(
        _db,
        _db.contractorStaffKitchens,
      );
  $$VisitorsTableTableManager get visitors =>
      $$VisitorsTableTableManager(_db, _db.visitors);
  $$VisitorKitchensTableTableManager get visitorKitchens =>
      $$VisitorKitchensTableTableManager(_db, _db.visitorKitchens);
  $$BioDataEntriesTableTableManager get bioDataEntries =>
      $$BioDataEntriesTableTableManager(_db, _db.bioDataEntries);
}
