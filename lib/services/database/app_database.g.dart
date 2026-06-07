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
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
    location,
    noOfEmployees,
    isActive,
    startDate,
    endDate,
    createdAt,
    updatedAt,
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
    } else if (isInserting) {
      context.missing(_idMeta);
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
  Site map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Site(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
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
  $SitesTable createAlias(String alias) {
    return $SitesTable(attachedDatabase, alias);
  }
}

class Site extends DataClass implements Insertable<Site> {
  final String id;
  final String name;
  final String? location;
  final int noOfEmployees;
  final bool isActive;
  final String? startDate;
  final String? endDate;
  final String createdAt;
  final String updatedAt;
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
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    this.syncUpdatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
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
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
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
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
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
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      location: serializer.fromJson<String?>(json['location']),
      noOfEmployees: serializer.fromJson<int>(json['noOfEmployees']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      startDate: serializer.fromJson<String?>(json['startDate']),
      endDate: serializer.fromJson<String?>(json['endDate']),
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
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'location': serializer.toJson<String?>(location),
      'noOfEmployees': serializer.toJson<int>(noOfEmployees),
      'isActive': serializer.toJson<bool>(isActive),
      'startDate': serializer.toJson<String?>(startDate),
      'endDate': serializer.toJson<String?>(endDate),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'syncUpdatedAt': serializer.toJson<String?>(syncUpdatedAt),
    };
  }

  Site copyWith({
    String? id,
    String? name,
    Value<String?> location = const Value.absent(),
    int? noOfEmployees,
    bool? isActive,
    Value<String?> startDate = const Value.absent(),
    Value<String?> endDate = const Value.absent(),
    String? createdAt,
    String? updatedAt,
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
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
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
    return (StringBuffer('Site(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('location: $location, ')
          ..write('noOfEmployees: $noOfEmployees, ')
          ..write('isActive: $isActive, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
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
    location,
    noOfEmployees,
    isActive,
    startDate,
    endDate,
    createdAt,
    updatedAt,
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
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.syncUpdatedAt == this.syncUpdatedAt);
}

class SitesCompanion extends UpdateCompanion<Site> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> location;
  final Value<int> noOfEmployees;
  final Value<bool> isActive;
  final Value<String?> startDate;
  final Value<String?> endDate;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> syncStatus;
  final Value<String?> syncUpdatedAt;
  final Value<int> rowid;
  const SitesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.location = const Value.absent(),
    this.noOfEmployees = const Value.absent(),
    this.isActive = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SitesCompanion.insert({
    required String id,
    required String name,
    this.location = const Value.absent(),
    this.noOfEmployees = const Value.absent(),
    this.isActive = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Site> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? location,
    Expression<int>? noOfEmployees,
    Expression<bool>? isActive,
    Expression<String>? startDate,
    Expression<String>? endDate,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? syncStatus,
    Expression<String>? syncUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (location != null) 'location': location,
      if (noOfEmployees != null) 'no_of_employees': noOfEmployees,
      if (isActive != null) 'is_active': isActive,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncUpdatedAt != null) 'sync_updated_at': syncUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SitesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? location,
    Value<int>? noOfEmployees,
    Value<bool>? isActive,
    Value<String?>? startDate,
    Value<String?>? endDate,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? syncStatus,
    Value<String?>? syncUpdatedAt,
    Value<int>? rowid,
  }) {
    return SitesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      noOfEmployees: noOfEmployees ?? this.noOfEmployees,
      isActive: isActive ?? this.isActive,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncUpdatedAt: syncUpdatedAt ?? this.syncUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
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
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt, ')
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
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  late final GeneratedColumn<String> companyId = GeneratedColumn<String>(
    'company_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sites (id)',
    ),
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
    minTierRequired,
    status,
    companyId,
    createdAt,
    updatedAt,
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
    } else if (isInserting) {
      context.missing(_idMeta);
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
    } else if (isInserting) {
      context.missing(_companyIdMeta);
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
  Kitchen map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Kitchen(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
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
        DriftSqlType.string,
        data['${effectivePrefix}company_id'],
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
  $KitchensTable createAlias(String alias) {
    return $KitchensTable(attachedDatabase, alias);
  }
}

class Kitchen extends DataClass implements Insertable<Kitchen> {
  final String id;
  final String name;
  final int minTierRequired;
  final String status;
  final String companyId;
  final String createdAt;
  final String updatedAt;
  final int syncStatus;
  final String? syncUpdatedAt;
  const Kitchen({
    required this.id,
    required this.name,
    required this.minTierRequired,
    required this.status,
    required this.companyId,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    this.syncUpdatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['min_tier_required'] = Variable<int>(minTierRequired);
    map['status'] = Variable<String>(status);
    map['company_id'] = Variable<String>(companyId);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
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
      companyId: Value(companyId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
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
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      minTierRequired: serializer.fromJson<int>(json['minTierRequired']),
      status: serializer.fromJson<String>(json['status']),
      companyId: serializer.fromJson<String>(json['companyId']),
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
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'minTierRequired': serializer.toJson<int>(minTierRequired),
      'status': serializer.toJson<String>(status),
      'companyId': serializer.toJson<String>(companyId),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'syncUpdatedAt': serializer.toJson<String?>(syncUpdatedAt),
    };
  }

  Kitchen copyWith({
    String? id,
    String? name,
    int? minTierRequired,
    String? status,
    String? companyId,
    String? createdAt,
    String? updatedAt,
    int? syncStatus,
    Value<String?> syncUpdatedAt = const Value.absent(),
  }) => Kitchen(
    id: id ?? this.id,
    name: name ?? this.name,
    minTierRequired: minTierRequired ?? this.minTierRequired,
    status: status ?? this.status,
    companyId: companyId ?? this.companyId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
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
    return (StringBuffer('Kitchen(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('minTierRequired: $minTierRequired, ')
          ..write('status: $status, ')
          ..write('companyId: $companyId, ')
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
    minTierRequired,
    status,
    companyId,
    createdAt,
    updatedAt,
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
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.syncUpdatedAt == this.syncUpdatedAt);
}

class KitchensCompanion extends UpdateCompanion<Kitchen> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> minTierRequired;
  final Value<String> status;
  final Value<String> companyId;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> syncStatus;
  final Value<String?> syncUpdatedAt;
  final Value<int> rowid;
  const KitchensCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.minTierRequired = const Value.absent(),
    this.status = const Value.absent(),
    this.companyId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KitchensCompanion.insert({
    required String id,
    required String name,
    required int minTierRequired,
    required String status,
    required String companyId,
    required String createdAt,
    required String updatedAt,
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       minTierRequired = Value(minTierRequired),
       status = Value(status),
       companyId = Value(companyId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Kitchen> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? minTierRequired,
    Expression<String>? status,
    Expression<String>? companyId,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? syncStatus,
    Expression<String>? syncUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (minTierRequired != null) 'min_tier_required': minTierRequired,
      if (status != null) 'status': status,
      if (companyId != null) 'company_id': companyId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncUpdatedAt != null) 'sync_updated_at': syncUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KitchensCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? minTierRequired,
    Value<String>? status,
    Value<String>? companyId,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? syncStatus,
    Value<String?>? syncUpdatedAt,
    Value<int>? rowid,
  }) {
    return KitchensCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      minTierRequired: minTierRequired ?? this.minTierRequired,
      status: status ?? this.status,
      companyId: companyId ?? this.companyId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncUpdatedAt: syncUpdatedAt ?? this.syncUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
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
      map['company_id'] = Variable<String>(companyId.value);
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
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
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt, ')
          ..write('rowid: $rowid')
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
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
    } else if (isInserting) {
      context.missing(_idMeta);
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
        DriftSqlType.string,
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
  final String id;
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
    map['id'] = Variable<String>(id);
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
      id: serializer.fromJson<String>(json['id']),
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
      'id': serializer.toJson<String>(id),
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
    String? id,
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
  final Value<String> id;
  final Value<String> name;
  final Value<String?> remarks;
  final Value<String> status;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> syncStatus;
  final Value<String?> syncUpdatedAt;
  final Value<int> rowid;
  const MenuTypesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.remarks = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MenuTypesCompanion.insert({
    required String id,
    required String name,
    this.remarks = const Value.absent(),
    required String status,
    required String createdAt,
    required String updatedAt,
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<MenuType> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? remarks,
    Expression<String>? status,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? syncStatus,
    Expression<String>? syncUpdatedAt,
    Expression<int>? rowid,
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
      if (rowid != null) 'rowid': rowid,
    });
  }

  MenuTypesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? remarks,
    Value<String>? status,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? syncStatus,
    Value<String?>? syncUpdatedAt,
    Value<int>? rowid,
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
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
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
          ..write('syncUpdatedAt: $syncUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MealsTable extends Meals with TableInfo<$MealsTable, Meal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _photoUrlMeta = const VerificationMeta(
    'photoUrl',
  );
  @override
  late final GeneratedColumn<String> photoUrl = GeneratedColumn<String>(
    'photo_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _menuTypeIdMeta = const VerificationMeta(
    'menuTypeId',
  );
  @override
  late final GeneratedColumn<String> menuTypeId = GeneratedColumn<String>(
    'menu_type_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES menu_types (id)',
    ),
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
    mealType,
    remarks,
    price,
    photoUrl,
    menuTypeId,
    createdAt,
    updatedAt,
    syncStatus,
    syncUpdatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meals';
  @override
  VerificationContext validateIntegrity(
    Insertable<Meal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
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
    if (data.containsKey('meal_type')) {
      context.handle(
        _mealTypeMeta,
        mealType.isAcceptableOrUnknown(data['meal_type']!, _mealTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mealTypeMeta);
    }
    if (data.containsKey('remarks')) {
      context.handle(
        _remarksMeta,
        remarks.isAcceptableOrUnknown(data['remarks']!, _remarksMeta),
      );
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('photo_url')) {
      context.handle(
        _photoUrlMeta,
        photoUrl.isAcceptableOrUnknown(data['photo_url']!, _photoUrlMeta),
      );
    }
    if (data.containsKey('menu_type_id')) {
      context.handle(
        _menuTypeIdMeta,
        menuTypeId.isAcceptableOrUnknown(
          data['menu_type_id']!,
          _menuTypeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_menuTypeIdMeta);
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
  Meal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Meal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
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
      mealType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_type'],
      )!,
      remarks: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remarks'],
      ),
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      photoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_url'],
      ),
      menuTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}menu_type_id'],
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
  $MealsTable createAlias(String alias) {
    return $MealsTable(attachedDatabase, alias);
  }
}

class Meal extends DataClass implements Insertable<Meal> {
  final String id;
  final String name;
  final String status;
  final String mealType;
  final String? remarks;
  final double price;
  final String? photoUrl;
  final String menuTypeId;
  final String createdAt;
  final String updatedAt;
  final int syncStatus;
  final String? syncUpdatedAt;
  const Meal({
    required this.id,
    required this.name,
    required this.status,
    required this.mealType,
    this.remarks,
    required this.price,
    this.photoUrl,
    required this.menuTypeId,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    this.syncUpdatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['status'] = Variable<String>(status);
    map['meal_type'] = Variable<String>(mealType);
    if (!nullToAbsent || remarks != null) {
      map['remarks'] = Variable<String>(remarks);
    }
    map['price'] = Variable<double>(price);
    if (!nullToAbsent || photoUrl != null) {
      map['photo_url'] = Variable<String>(photoUrl);
    }
    map['menu_type_id'] = Variable<String>(menuTypeId);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    map['sync_status'] = Variable<int>(syncStatus);
    if (!nullToAbsent || syncUpdatedAt != null) {
      map['sync_updated_at'] = Variable<String>(syncUpdatedAt);
    }
    return map;
  }

  MealsCompanion toCompanion(bool nullToAbsent) {
    return MealsCompanion(
      id: Value(id),
      name: Value(name),
      status: Value(status),
      mealType: Value(mealType),
      remarks: remarks == null && nullToAbsent
          ? const Value.absent()
          : Value(remarks),
      price: Value(price),
      photoUrl: photoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(photoUrl),
      menuTypeId: Value(menuTypeId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      syncUpdatedAt: syncUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdatedAt),
    );
  }

  factory Meal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Meal(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      status: serializer.fromJson<String>(json['status']),
      mealType: serializer.fromJson<String>(json['mealType']),
      remarks: serializer.fromJson<String?>(json['remarks']),
      price: serializer.fromJson<double>(json['price']),
      photoUrl: serializer.fromJson<String?>(json['photoUrl']),
      menuTypeId: serializer.fromJson<String>(json['menuTypeId']),
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
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'status': serializer.toJson<String>(status),
      'mealType': serializer.toJson<String>(mealType),
      'remarks': serializer.toJson<String?>(remarks),
      'price': serializer.toJson<double>(price),
      'photoUrl': serializer.toJson<String?>(photoUrl),
      'menuTypeId': serializer.toJson<String>(menuTypeId),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'syncUpdatedAt': serializer.toJson<String?>(syncUpdatedAt),
    };
  }

  Meal copyWith({
    String? id,
    String? name,
    String? status,
    String? mealType,
    Value<String?> remarks = const Value.absent(),
    double? price,
    Value<String?> photoUrl = const Value.absent(),
    String? menuTypeId,
    String? createdAt,
    String? updatedAt,
    int? syncStatus,
    Value<String?> syncUpdatedAt = const Value.absent(),
  }) => Meal(
    id: id ?? this.id,
    name: name ?? this.name,
    status: status ?? this.status,
    mealType: mealType ?? this.mealType,
    remarks: remarks.present ? remarks.value : this.remarks,
    price: price ?? this.price,
    photoUrl: photoUrl.present ? photoUrl.value : this.photoUrl,
    menuTypeId: menuTypeId ?? this.menuTypeId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    syncUpdatedAt: syncUpdatedAt.present
        ? syncUpdatedAt.value
        : this.syncUpdatedAt,
  );
  Meal copyWithCompanion(MealsCompanion data) {
    return Meal(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      status: data.status.present ? data.status.value : this.status,
      mealType: data.mealType.present ? data.mealType.value : this.mealType,
      remarks: data.remarks.present ? data.remarks.value : this.remarks,
      price: data.price.present ? data.price.value : this.price,
      photoUrl: data.photoUrl.present ? data.photoUrl.value : this.photoUrl,
      menuTypeId: data.menuTypeId.present
          ? data.menuTypeId.value
          : this.menuTypeId,
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
    return (StringBuffer('Meal(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('status: $status, ')
          ..write('mealType: $mealType, ')
          ..write('remarks: $remarks, ')
          ..write('price: $price, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('menuTypeId: $menuTypeId, ')
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
    mealType,
    remarks,
    price,
    photoUrl,
    menuTypeId,
    createdAt,
    updatedAt,
    syncStatus,
    syncUpdatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Meal &&
          other.id == this.id &&
          other.name == this.name &&
          other.status == this.status &&
          other.mealType == this.mealType &&
          other.remarks == this.remarks &&
          other.price == this.price &&
          other.photoUrl == this.photoUrl &&
          other.menuTypeId == this.menuTypeId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.syncUpdatedAt == this.syncUpdatedAt);
}

class MealsCompanion extends UpdateCompanion<Meal> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> status;
  final Value<String> mealType;
  final Value<String?> remarks;
  final Value<double> price;
  final Value<String?> photoUrl;
  final Value<String> menuTypeId;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> syncStatus;
  final Value<String?> syncUpdatedAt;
  final Value<int> rowid;
  const MealsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.status = const Value.absent(),
    this.mealType = const Value.absent(),
    this.remarks = const Value.absent(),
    this.price = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.menuTypeId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MealsCompanion.insert({
    required String id,
    required String name,
    required String status,
    required String mealType,
    this.remarks = const Value.absent(),
    required double price,
    this.photoUrl = const Value.absent(),
    required String menuTypeId,
    required String createdAt,
    required String updatedAt,
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       status = Value(status),
       mealType = Value(mealType),
       price = Value(price),
       menuTypeId = Value(menuTypeId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Meal> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? status,
    Expression<String>? mealType,
    Expression<String>? remarks,
    Expression<double>? price,
    Expression<String>? photoUrl,
    Expression<String>? menuTypeId,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? syncStatus,
    Expression<String>? syncUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (status != null) 'status': status,
      if (mealType != null) 'meal_type': mealType,
      if (remarks != null) 'remarks': remarks,
      if (price != null) 'price': price,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (menuTypeId != null) 'menu_type_id': menuTypeId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncUpdatedAt != null) 'sync_updated_at': syncUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MealsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? status,
    Value<String>? mealType,
    Value<String?>? remarks,
    Value<double>? price,
    Value<String?>? photoUrl,
    Value<String>? menuTypeId,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? syncStatus,
    Value<String?>? syncUpdatedAt,
    Value<int>? rowid,
  }) {
    return MealsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      mealType: mealType ?? this.mealType,
      remarks: remarks ?? this.remarks,
      price: price ?? this.price,
      photoUrl: photoUrl ?? this.photoUrl,
      menuTypeId: menuTypeId ?? this.menuTypeId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncUpdatedAt: syncUpdatedAt ?? this.syncUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (mealType.present) {
      map['meal_type'] = Variable<String>(mealType.value);
    }
    if (remarks.present) {
      map['remarks'] = Variable<String>(remarks.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (photoUrl.present) {
      map['photo_url'] = Variable<String>(photoUrl.value);
    }
    if (menuTypeId.present) {
      map['menu_type_id'] = Variable<String>(menuTypeId.value);
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('status: $status, ')
          ..write('mealType: $mealType, ')
          ..write('remarks: $remarks, ')
          ..write('price: $price, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('menuTypeId: $menuTypeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MealKitchensTable extends MealKitchens
    with TableInfo<$MealKitchensTable, MealKitchen> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealKitchensTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _mealIdMeta = const VerificationMeta('mealId');
  @override
  late final GeneratedColumn<String> mealId = GeneratedColumn<String>(
    'meal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES meals (id)',
    ),
  );
  static const VerificationMeta _kitchenIdMeta = const VerificationMeta(
    'kitchenId',
  );
  @override
  late final GeneratedColumn<String> kitchenId = GeneratedColumn<String>(
    'kitchen_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES kitchens (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [mealId, kitchenId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_kitchens';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealKitchen> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('meal_id')) {
      context.handle(
        _mealIdMeta,
        mealId.isAcceptableOrUnknown(data['meal_id']!, _mealIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mealIdMeta);
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
  Set<GeneratedColumn> get $primaryKey => {mealId, kitchenId};
  @override
  MealKitchen map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealKitchen(
      mealId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_id'],
      )!,
      kitchenId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kitchen_id'],
      )!,
    );
  }

  @override
  $MealKitchensTable createAlias(String alias) {
    return $MealKitchensTable(attachedDatabase, alias);
  }
}

class MealKitchen extends DataClass implements Insertable<MealKitchen> {
  final String mealId;
  final String kitchenId;
  const MealKitchen({required this.mealId, required this.kitchenId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['meal_id'] = Variable<String>(mealId);
    map['kitchen_id'] = Variable<String>(kitchenId);
    return map;
  }

  MealKitchensCompanion toCompanion(bool nullToAbsent) {
    return MealKitchensCompanion(
      mealId: Value(mealId),
      kitchenId: Value(kitchenId),
    );
  }

  factory MealKitchen.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealKitchen(
      mealId: serializer.fromJson<String>(json['mealId']),
      kitchenId: serializer.fromJson<String>(json['kitchenId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'mealId': serializer.toJson<String>(mealId),
      'kitchenId': serializer.toJson<String>(kitchenId),
    };
  }

  MealKitchen copyWith({String? mealId, String? kitchenId}) => MealKitchen(
    mealId: mealId ?? this.mealId,
    kitchenId: kitchenId ?? this.kitchenId,
  );
  MealKitchen copyWithCompanion(MealKitchensCompanion data) {
    return MealKitchen(
      mealId: data.mealId.present ? data.mealId.value : this.mealId,
      kitchenId: data.kitchenId.present ? data.kitchenId.value : this.kitchenId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealKitchen(')
          ..write('mealId: $mealId, ')
          ..write('kitchenId: $kitchenId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(mealId, kitchenId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealKitchen &&
          other.mealId == this.mealId &&
          other.kitchenId == this.kitchenId);
}

class MealKitchensCompanion extends UpdateCompanion<MealKitchen> {
  final Value<String> mealId;
  final Value<String> kitchenId;
  final Value<int> rowid;
  const MealKitchensCompanion({
    this.mealId = const Value.absent(),
    this.kitchenId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MealKitchensCompanion.insert({
    required String mealId,
    required String kitchenId,
    this.rowid = const Value.absent(),
  }) : mealId = Value(mealId),
       kitchenId = Value(kitchenId);
  static Insertable<MealKitchen> custom({
    Expression<String>? mealId,
    Expression<String>? kitchenId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (mealId != null) 'meal_id': mealId,
      if (kitchenId != null) 'kitchen_id': kitchenId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MealKitchensCompanion copyWith({
    Value<String>? mealId,
    Value<String>? kitchenId,
    Value<int>? rowid,
  }) {
    return MealKitchensCompanion(
      mealId: mealId ?? this.mealId,
      kitchenId: kitchenId ?? this.kitchenId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (mealId.present) {
      map['meal_id'] = Variable<String>(mealId.value);
    }
    if (kitchenId.present) {
      map['kitchen_id'] = Variable<String>(kitchenId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealKitchensCompanion(')
          ..write('mealId: $mealId, ')
          ..write('kitchenId: $kitchenId, ')
          ..write('rowid: $rowid')
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
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    phone,
    email,
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
    } else if (isInserting) {
      context.missing(_idMeta);
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
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
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
        DriftSqlType.string,
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
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
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
  final String id;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? email;
  final int syncStatus;
  final String? syncUpdatedAt;
  const StaffData({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.email,
    required this.syncStatus,
    this.syncUpdatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
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
      firstName: Value(firstName),
      lastName: Value(lastName),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
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
      id: serializer.fromJson<String>(json['id']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      syncUpdatedAt: serializer.fromJson<String?>(json['syncUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'syncUpdatedAt': serializer.toJson<String?>(syncUpdatedAt),
    };
  }

  StaffData copyWith({
    String? id,
    String? firstName,
    String? lastName,
    Value<String?> phone = const Value.absent(),
    Value<String?> email = const Value.absent(),
    int? syncStatus,
    Value<String?> syncUpdatedAt = const Value.absent(),
  }) => StaffData(
    id: id ?? this.id,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    phone: phone.present ? phone.value : this.phone,
    email: email.present ? email.value : this.email,
    syncStatus: syncStatus ?? this.syncStatus,
    syncUpdatedAt: syncUpdatedAt.present
        ? syncUpdatedAt.value
        : this.syncUpdatedAt,
  );
  StaffData copyWithCompanion(StaffCompanion data) {
    return StaffData(
      id: data.id.present ? data.id.value : this.id,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
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
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
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
    phone,
    email,
    syncStatus,
    syncUpdatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StaffData &&
          other.id == this.id &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.syncStatus == this.syncStatus &&
          other.syncUpdatedAt == this.syncUpdatedAt);
}

class StaffCompanion extends UpdateCompanion<StaffData> {
  final Value<String> id;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<int> syncStatus;
  final Value<String?> syncUpdatedAt;
  final Value<int> rowid;
  const StaffCompanion({
    this.id = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StaffCompanion.insert({
    required String id,
    required String firstName,
    required String lastName,
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       firstName = Value(firstName),
       lastName = Value(lastName);
  static Insertable<StaffData> custom({
    Expression<String>? id,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<int>? syncStatus,
    Expression<String>? syncUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncUpdatedAt != null) 'sync_updated_at': syncUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StaffCompanion copyWith({
    Value<String>? id,
    Value<String>? firstName,
    Value<String>? lastName,
    Value<String?>? phone,
    Value<String?>? email,
    Value<int>? syncStatus,
    Value<String?>? syncUpdatedAt,
    Value<int>? rowid,
  }) {
    return StaffCompanion(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      syncStatus: syncStatus ?? this.syncStatus,
      syncUpdatedAt: syncUpdatedAt ?? this.syncUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (syncUpdatedAt.present) {
      map['sync_updated_at'] = Variable<String>(syncUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StaffCompanion(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt, ')
          ..write('rowid: $rowid')
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
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
    } else if (isInserting) {
      context.missing(_idMeta);
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
        DriftSqlType.string,
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
  final String id;
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
    map['id'] = Variable<String>(id);
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
      id: serializer.fromJson<String>(json['id']),
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
      'id': serializer.toJson<String>(id),
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
    String? id,
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
  final Value<String> id;
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
  final Value<int> rowid;
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
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
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
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       firstName = Value(firstName),
       lastName = Value(lastName),
       role = Value(role),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<User> custom({
    Expression<String>? id,
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
    Expression<int>? rowid,
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
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
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
    Value<int>? rowid,
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
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
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
          ..write('syncUpdatedAt: $syncUpdatedAt, ')
          ..write('rowid: $rowid')
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
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _kitchenIdMeta = const VerificationMeta(
    'kitchenId',
  );
  @override
  late final GeneratedColumn<String> kitchenId = GeneratedColumn<String>(
    'kitchen_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES kitchens (id)',
    ),
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
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      kitchenId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
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
  final String userId;
  final String kitchenId;
  const UserKitchen({required this.userId, required this.kitchenId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['kitchen_id'] = Variable<String>(kitchenId);
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
      userId: serializer.fromJson<String>(json['userId']),
      kitchenId: serializer.fromJson<String>(json['kitchenId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'kitchenId': serializer.toJson<String>(kitchenId),
    };
  }

  UserKitchen copyWith({String? userId, String? kitchenId}) => UserKitchen(
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
  final Value<String> userId;
  final Value<String> kitchenId;
  final Value<int> rowid;
  const UserKitchensCompanion({
    this.userId = const Value.absent(),
    this.kitchenId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserKitchensCompanion.insert({
    required String userId,
    required String kitchenId,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       kitchenId = Value(kitchenId);
  static Insertable<UserKitchen> custom({
    Expression<String>? userId,
    Expression<String>? kitchenId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (kitchenId != null) 'kitchen_id': kitchenId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserKitchensCompanion copyWith({
    Value<String>? userId,
    Value<String>? kitchenId,
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
      map['user_id'] = Variable<String>(userId.value);
    }
    if (kitchenId.present) {
      map['kitchen_id'] = Variable<String>(kitchenId.value);
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
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  late final GeneratedColumn<String> orderedById = GeneratedColumn<String>(
    'ordered_by_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES staff (id)',
    ),
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
    orderCode,
    status,
    orderType,
    mealType,
    total,
    groupCount,
    description,
    orderedById,
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
    } else if (isInserting) {
      context.missing(_idMeta);
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
        DriftSqlType.string,
        data['${effectivePrefix}id'],
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
        DriftSqlType.string,
        data['${effectivePrefix}ordered_by_id'],
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
  final String id;
  final String orderCode;
  final String status;
  final String orderType;
  final String mealType;
  final double total;
  final int groupCount;
  final String? description;
  final String orderedById;
  final String createdAt;
  final String updatedAt;
  final int syncStatus;
  final String? syncUpdatedAt;
  const Order({
    required this.id,
    required this.orderCode,
    required this.status,
    required this.orderType,
    required this.mealType,
    required this.total,
    required this.groupCount,
    this.description,
    required this.orderedById,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    this.syncUpdatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['order_code'] = Variable<String>(orderCode);
    map['status'] = Variable<String>(status);
    map['order_type'] = Variable<String>(orderType);
    map['meal_type'] = Variable<String>(mealType);
    map['total'] = Variable<double>(total);
    map['group_count'] = Variable<int>(groupCount);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['ordered_by_id'] = Variable<String>(orderedById);
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
      id: serializer.fromJson<String>(json['id']),
      orderCode: serializer.fromJson<String>(json['orderCode']),
      status: serializer.fromJson<String>(json['status']),
      orderType: serializer.fromJson<String>(json['orderType']),
      mealType: serializer.fromJson<String>(json['mealType']),
      total: serializer.fromJson<double>(json['total']),
      groupCount: serializer.fromJson<int>(json['groupCount']),
      description: serializer.fromJson<String?>(json['description']),
      orderedById: serializer.fromJson<String>(json['orderedById']),
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
      'id': serializer.toJson<String>(id),
      'orderCode': serializer.toJson<String>(orderCode),
      'status': serializer.toJson<String>(status),
      'orderType': serializer.toJson<String>(orderType),
      'mealType': serializer.toJson<String>(mealType),
      'total': serializer.toJson<double>(total),
      'groupCount': serializer.toJson<int>(groupCount),
      'description': serializer.toJson<String?>(description),
      'orderedById': serializer.toJson<String>(orderedById),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'syncUpdatedAt': serializer.toJson<String?>(syncUpdatedAt),
    };
  }

  Order copyWith({
    String? id,
    String? orderCode,
    String? status,
    String? orderType,
    String? mealType,
    double? total,
    int? groupCount,
    Value<String?> description = const Value.absent(),
    String? orderedById,
    String? createdAt,
    String? updatedAt,
    int? syncStatus,
    Value<String?> syncUpdatedAt = const Value.absent(),
  }) => Order(
    id: id ?? this.id,
    orderCode: orderCode ?? this.orderCode,
    status: status ?? this.status,
    orderType: orderType ?? this.orderType,
    mealType: mealType ?? this.mealType,
    total: total ?? this.total,
    groupCount: groupCount ?? this.groupCount,
    description: description.present ? description.value : this.description,
    orderedById: orderedById ?? this.orderedById,
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
          ..write('orderCode: $orderCode, ')
          ..write('status: $status, ')
          ..write('orderType: $orderType, ')
          ..write('mealType: $mealType, ')
          ..write('total: $total, ')
          ..write('groupCount: $groupCount, ')
          ..write('description: $description, ')
          ..write('orderedById: $orderedById, ')
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
    orderCode,
    status,
    orderType,
    mealType,
    total,
    groupCount,
    description,
    orderedById,
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
          other.orderCode == this.orderCode &&
          other.status == this.status &&
          other.orderType == this.orderType &&
          other.mealType == this.mealType &&
          other.total == this.total &&
          other.groupCount == this.groupCount &&
          other.description == this.description &&
          other.orderedById == this.orderedById &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.syncUpdatedAt == this.syncUpdatedAt);
}

class OrdersCompanion extends UpdateCompanion<Order> {
  final Value<String> id;
  final Value<String> orderCode;
  final Value<String> status;
  final Value<String> orderType;
  final Value<String> mealType;
  final Value<double> total;
  final Value<int> groupCount;
  final Value<String?> description;
  final Value<String> orderedById;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> syncStatus;
  final Value<String?> syncUpdatedAt;
  final Value<int> rowid;
  const OrdersCompanion({
    this.id = const Value.absent(),
    this.orderCode = const Value.absent(),
    this.status = const Value.absent(),
    this.orderType = const Value.absent(),
    this.mealType = const Value.absent(),
    this.total = const Value.absent(),
    this.groupCount = const Value.absent(),
    this.description = const Value.absent(),
    this.orderedById = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrdersCompanion.insert({
    required String id,
    required String orderCode,
    required String status,
    required String orderType,
    required String mealType,
    required double total,
    required int groupCount,
    this.description = const Value.absent(),
    required String orderedById,
    required String createdAt,
    required String updatedAt,
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       orderCode = Value(orderCode),
       status = Value(status),
       orderType = Value(orderType),
       mealType = Value(mealType),
       total = Value(total),
       groupCount = Value(groupCount),
       orderedById = Value(orderedById),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Order> custom({
    Expression<String>? id,
    Expression<String>? orderCode,
    Expression<String>? status,
    Expression<String>? orderType,
    Expression<String>? mealType,
    Expression<double>? total,
    Expression<int>? groupCount,
    Expression<String>? description,
    Expression<String>? orderedById,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? syncStatus,
    Expression<String>? syncUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderCode != null) 'order_code': orderCode,
      if (status != null) 'status': status,
      if (orderType != null) 'order_type': orderType,
      if (mealType != null) 'meal_type': mealType,
      if (total != null) 'total': total,
      if (groupCount != null) 'group_count': groupCount,
      if (description != null) 'description': description,
      if (orderedById != null) 'ordered_by_id': orderedById,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncUpdatedAt != null) 'sync_updated_at': syncUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrdersCompanion copyWith({
    Value<String>? id,
    Value<String>? orderCode,
    Value<String>? status,
    Value<String>? orderType,
    Value<String>? mealType,
    Value<double>? total,
    Value<int>? groupCount,
    Value<String?>? description,
    Value<String>? orderedById,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? syncStatus,
    Value<String?>? syncUpdatedAt,
    Value<int>? rowid,
  }) {
    return OrdersCompanion(
      id: id ?? this.id,
      orderCode: orderCode ?? this.orderCode,
      status: status ?? this.status,
      orderType: orderType ?? this.orderType,
      mealType: mealType ?? this.mealType,
      total: total ?? this.total,
      groupCount: groupCount ?? this.groupCount,
      description: description ?? this.description,
      orderedById: orderedById ?? this.orderedById,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncUpdatedAt: syncUpdatedAt ?? this.syncUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
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
      map['ordered_by_id'] = Variable<String>(orderedById.value);
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdersCompanion(')
          ..write('id: $id, ')
          ..write('orderCode: $orderCode, ')
          ..write('status: $status, ')
          ..write('orderType: $orderType, ')
          ..write('mealType: $mealType, ')
          ..write('total: $total, ')
          ..write('groupCount: $groupCount, ')
          ..write('description: $description, ')
          ..write('orderedById: $orderedById, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrderItemsTable extends OrderItems
    with TableInfo<$OrderItemsTable, OrderItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qtyMeta = const VerificationMeta('qty');
  @override
  late final GeneratedColumn<int> qty = GeneratedColumn<int>(
    'qty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mealIdMeta = const VerificationMeta('mealId');
  @override
  late final GeneratedColumn<String> mealId = GeneratedColumn<String>(
    'meal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES meals (id)',
    ),
  );
  static const VerificationMeta _orderIdMeta = const VerificationMeta(
    'orderId',
  );
  @override
  late final GeneratedColumn<String> orderId = GeneratedColumn<String>(
    'order_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES orders (id)',
    ),
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
    price,
    qty,
    mealId,
    orderId,
    createdAt,
    updatedAt,
    syncStatus,
    syncUpdatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrderItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('qty')) {
      context.handle(
        _qtyMeta,
        qty.isAcceptableOrUnknown(data['qty']!, _qtyMeta),
      );
    } else if (isInserting) {
      context.missing(_qtyMeta);
    }
    if (data.containsKey('meal_id')) {
      context.handle(
        _mealIdMeta,
        mealId.isAcceptableOrUnknown(data['meal_id']!, _mealIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mealIdMeta);
    }
    if (data.containsKey('order_id')) {
      context.handle(
        _orderIdMeta,
        orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIdMeta);
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
  OrderItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      qty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}qty'],
      )!,
      mealId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_id'],
      )!,
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_id'],
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
  $OrderItemsTable createAlias(String alias) {
    return $OrderItemsTable(attachedDatabase, alias);
  }
}

class OrderItem extends DataClass implements Insertable<OrderItem> {
  final String id;
  final double price;
  final int qty;
  final String mealId;
  final String orderId;
  final String createdAt;
  final String updatedAt;
  final int syncStatus;
  final String? syncUpdatedAt;
  const OrderItem({
    required this.id,
    required this.price,
    required this.qty,
    required this.mealId,
    required this.orderId,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    this.syncUpdatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['price'] = Variable<double>(price);
    map['qty'] = Variable<int>(qty);
    map['meal_id'] = Variable<String>(mealId);
    map['order_id'] = Variable<String>(orderId);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    map['sync_status'] = Variable<int>(syncStatus);
    if (!nullToAbsent || syncUpdatedAt != null) {
      map['sync_updated_at'] = Variable<String>(syncUpdatedAt);
    }
    return map;
  }

  OrderItemsCompanion toCompanion(bool nullToAbsent) {
    return OrderItemsCompanion(
      id: Value(id),
      price: Value(price),
      qty: Value(qty),
      mealId: Value(mealId),
      orderId: Value(orderId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      syncUpdatedAt: syncUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdatedAt),
    );
  }

  factory OrderItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderItem(
      id: serializer.fromJson<String>(json['id']),
      price: serializer.fromJson<double>(json['price']),
      qty: serializer.fromJson<int>(json['qty']),
      mealId: serializer.fromJson<String>(json['mealId']),
      orderId: serializer.fromJson<String>(json['orderId']),
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
      'id': serializer.toJson<String>(id),
      'price': serializer.toJson<double>(price),
      'qty': serializer.toJson<int>(qty),
      'mealId': serializer.toJson<String>(mealId),
      'orderId': serializer.toJson<String>(orderId),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'syncUpdatedAt': serializer.toJson<String?>(syncUpdatedAt),
    };
  }

  OrderItem copyWith({
    String? id,
    double? price,
    int? qty,
    String? mealId,
    String? orderId,
    String? createdAt,
    String? updatedAt,
    int? syncStatus,
    Value<String?> syncUpdatedAt = const Value.absent(),
  }) => OrderItem(
    id: id ?? this.id,
    price: price ?? this.price,
    qty: qty ?? this.qty,
    mealId: mealId ?? this.mealId,
    orderId: orderId ?? this.orderId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    syncUpdatedAt: syncUpdatedAt.present
        ? syncUpdatedAt.value
        : this.syncUpdatedAt,
  );
  OrderItem copyWithCompanion(OrderItemsCompanion data) {
    return OrderItem(
      id: data.id.present ? data.id.value : this.id,
      price: data.price.present ? data.price.value : this.price,
      qty: data.qty.present ? data.qty.value : this.qty,
      mealId: data.mealId.present ? data.mealId.value : this.mealId,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
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
    return (StringBuffer('OrderItem(')
          ..write('id: $id, ')
          ..write('price: $price, ')
          ..write('qty: $qty, ')
          ..write('mealId: $mealId, ')
          ..write('orderId: $orderId, ')
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
    price,
    qty,
    mealId,
    orderId,
    createdAt,
    updatedAt,
    syncStatus,
    syncUpdatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderItem &&
          other.id == this.id &&
          other.price == this.price &&
          other.qty == this.qty &&
          other.mealId == this.mealId &&
          other.orderId == this.orderId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.syncUpdatedAt == this.syncUpdatedAt);
}

class OrderItemsCompanion extends UpdateCompanion<OrderItem> {
  final Value<String> id;
  final Value<double> price;
  final Value<int> qty;
  final Value<String> mealId;
  final Value<String> orderId;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> syncStatus;
  final Value<String?> syncUpdatedAt;
  final Value<int> rowid;
  const OrderItemsCompanion({
    this.id = const Value.absent(),
    this.price = const Value.absent(),
    this.qty = const Value.absent(),
    this.mealId = const Value.absent(),
    this.orderId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrderItemsCompanion.insert({
    required String id,
    required double price,
    required int qty,
    required String mealId,
    required String orderId,
    required String createdAt,
    required String updatedAt,
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       price = Value(price),
       qty = Value(qty),
       mealId = Value(mealId),
       orderId = Value(orderId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<OrderItem> custom({
    Expression<String>? id,
    Expression<double>? price,
    Expression<int>? qty,
    Expression<String>? mealId,
    Expression<String>? orderId,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? syncStatus,
    Expression<String>? syncUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (price != null) 'price': price,
      if (qty != null) 'qty': qty,
      if (mealId != null) 'meal_id': mealId,
      if (orderId != null) 'order_id': orderId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncUpdatedAt != null) 'sync_updated_at': syncUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrderItemsCompanion copyWith({
    Value<String>? id,
    Value<double>? price,
    Value<int>? qty,
    Value<String>? mealId,
    Value<String>? orderId,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? syncStatus,
    Value<String?>? syncUpdatedAt,
    Value<int>? rowid,
  }) {
    return OrderItemsCompanion(
      id: id ?? this.id,
      price: price ?? this.price,
      qty: qty ?? this.qty,
      mealId: mealId ?? this.mealId,
      orderId: orderId ?? this.orderId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncUpdatedAt: syncUpdatedAt ?? this.syncUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (qty.present) {
      map['qty'] = Variable<int>(qty.value);
    }
    if (mealId.present) {
      map['meal_id'] = Variable<String>(mealId.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<String>(orderId.value);
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemsCompanion(')
          ..write('id: $id, ')
          ..write('price: $price, ')
          ..write('qty: $qty, ')
          ..write('mealId: $mealId, ')
          ..write('orderId: $orderId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OverchargesTable extends Overcharges
    with TableInfo<$OverchargesTable, Overcharge> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OverchargesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _staffIdMeta = const VerificationMeta(
    'staffId',
  );
  @override
  late final GeneratedColumn<String> staffId = GeneratedColumn<String>(
    'staff_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES staff (id)',
    ),
  );
  static const VerificationMeta _mealIdMeta = const VerificationMeta('mealId');
  @override
  late final GeneratedColumn<String> mealId = GeneratedColumn<String>(
    'meal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES meals (id)',
    ),
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
    mealType,
    orderCode,
    price,
    staffId,
    mealId,
    createdAt,
    updatedAt,
    syncStatus,
    syncUpdatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'overcharges';
  @override
  VerificationContext validateIntegrity(
    Insertable<Overcharge> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('meal_type')) {
      context.handle(
        _mealTypeMeta,
        mealType.isAcceptableOrUnknown(data['meal_type']!, _mealTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mealTypeMeta);
    }
    if (data.containsKey('order_code')) {
      context.handle(
        _orderCodeMeta,
        orderCode.isAcceptableOrUnknown(data['order_code']!, _orderCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_orderCodeMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('staff_id')) {
      context.handle(
        _staffIdMeta,
        staffId.isAcceptableOrUnknown(data['staff_id']!, _staffIdMeta),
      );
    } else if (isInserting) {
      context.missing(_staffIdMeta);
    }
    if (data.containsKey('meal_id')) {
      context.handle(
        _mealIdMeta,
        mealId.isAcceptableOrUnknown(data['meal_id']!, _mealIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mealIdMeta);
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
  Overcharge map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Overcharge(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      mealType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_type'],
      )!,
      orderCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_code'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      staffId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}staff_id'],
      )!,
      mealId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_id'],
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
  $OverchargesTable createAlias(String alias) {
    return $OverchargesTable(attachedDatabase, alias);
  }
}

class Overcharge extends DataClass implements Insertable<Overcharge> {
  final String id;
  final String mealType;
  final String orderCode;
  final double price;
  final String staffId;
  final String mealId;
  final String createdAt;
  final String updatedAt;
  final int syncStatus;
  final String? syncUpdatedAt;
  const Overcharge({
    required this.id,
    required this.mealType,
    required this.orderCode,
    required this.price,
    required this.staffId,
    required this.mealId,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    this.syncUpdatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['meal_type'] = Variable<String>(mealType);
    map['order_code'] = Variable<String>(orderCode);
    map['price'] = Variable<double>(price);
    map['staff_id'] = Variable<String>(staffId);
    map['meal_id'] = Variable<String>(mealId);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    map['sync_status'] = Variable<int>(syncStatus);
    if (!nullToAbsent || syncUpdatedAt != null) {
      map['sync_updated_at'] = Variable<String>(syncUpdatedAt);
    }
    return map;
  }

  OverchargesCompanion toCompanion(bool nullToAbsent) {
    return OverchargesCompanion(
      id: Value(id),
      mealType: Value(mealType),
      orderCode: Value(orderCode),
      price: Value(price),
      staffId: Value(staffId),
      mealId: Value(mealId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      syncUpdatedAt: syncUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdatedAt),
    );
  }

  factory Overcharge.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Overcharge(
      id: serializer.fromJson<String>(json['id']),
      mealType: serializer.fromJson<String>(json['mealType']),
      orderCode: serializer.fromJson<String>(json['orderCode']),
      price: serializer.fromJson<double>(json['price']),
      staffId: serializer.fromJson<String>(json['staffId']),
      mealId: serializer.fromJson<String>(json['mealId']),
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
      'id': serializer.toJson<String>(id),
      'mealType': serializer.toJson<String>(mealType),
      'orderCode': serializer.toJson<String>(orderCode),
      'price': serializer.toJson<double>(price),
      'staffId': serializer.toJson<String>(staffId),
      'mealId': serializer.toJson<String>(mealId),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'syncUpdatedAt': serializer.toJson<String?>(syncUpdatedAt),
    };
  }

  Overcharge copyWith({
    String? id,
    String? mealType,
    String? orderCode,
    double? price,
    String? staffId,
    String? mealId,
    String? createdAt,
    String? updatedAt,
    int? syncStatus,
    Value<String?> syncUpdatedAt = const Value.absent(),
  }) => Overcharge(
    id: id ?? this.id,
    mealType: mealType ?? this.mealType,
    orderCode: orderCode ?? this.orderCode,
    price: price ?? this.price,
    staffId: staffId ?? this.staffId,
    mealId: mealId ?? this.mealId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    syncUpdatedAt: syncUpdatedAt.present
        ? syncUpdatedAt.value
        : this.syncUpdatedAt,
  );
  Overcharge copyWithCompanion(OverchargesCompanion data) {
    return Overcharge(
      id: data.id.present ? data.id.value : this.id,
      mealType: data.mealType.present ? data.mealType.value : this.mealType,
      orderCode: data.orderCode.present ? data.orderCode.value : this.orderCode,
      price: data.price.present ? data.price.value : this.price,
      staffId: data.staffId.present ? data.staffId.value : this.staffId,
      mealId: data.mealId.present ? data.mealId.value : this.mealId,
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
    return (StringBuffer('Overcharge(')
          ..write('id: $id, ')
          ..write('mealType: $mealType, ')
          ..write('orderCode: $orderCode, ')
          ..write('price: $price, ')
          ..write('staffId: $staffId, ')
          ..write('mealId: $mealId, ')
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
    mealType,
    orderCode,
    price,
    staffId,
    mealId,
    createdAt,
    updatedAt,
    syncStatus,
    syncUpdatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Overcharge &&
          other.id == this.id &&
          other.mealType == this.mealType &&
          other.orderCode == this.orderCode &&
          other.price == this.price &&
          other.staffId == this.staffId &&
          other.mealId == this.mealId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.syncUpdatedAt == this.syncUpdatedAt);
}

class OverchargesCompanion extends UpdateCompanion<Overcharge> {
  final Value<String> id;
  final Value<String> mealType;
  final Value<String> orderCode;
  final Value<double> price;
  final Value<String> staffId;
  final Value<String> mealId;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> syncStatus;
  final Value<String?> syncUpdatedAt;
  final Value<int> rowid;
  const OverchargesCompanion({
    this.id = const Value.absent(),
    this.mealType = const Value.absent(),
    this.orderCode = const Value.absent(),
    this.price = const Value.absent(),
    this.staffId = const Value.absent(),
    this.mealId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OverchargesCompanion.insert({
    required String id,
    required String mealType,
    required String orderCode,
    required double price,
    required String staffId,
    required String mealId,
    required String createdAt,
    required String updatedAt,
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       mealType = Value(mealType),
       orderCode = Value(orderCode),
       price = Value(price),
       staffId = Value(staffId),
       mealId = Value(mealId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Overcharge> custom({
    Expression<String>? id,
    Expression<String>? mealType,
    Expression<String>? orderCode,
    Expression<double>? price,
    Expression<String>? staffId,
    Expression<String>? mealId,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? syncStatus,
    Expression<String>? syncUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mealType != null) 'meal_type': mealType,
      if (orderCode != null) 'order_code': orderCode,
      if (price != null) 'price': price,
      if (staffId != null) 'staff_id': staffId,
      if (mealId != null) 'meal_id': mealId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncUpdatedAt != null) 'sync_updated_at': syncUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OverchargesCompanion copyWith({
    Value<String>? id,
    Value<String>? mealType,
    Value<String>? orderCode,
    Value<double>? price,
    Value<String>? staffId,
    Value<String>? mealId,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? syncStatus,
    Value<String?>? syncUpdatedAt,
    Value<int>? rowid,
  }) {
    return OverchargesCompanion(
      id: id ?? this.id,
      mealType: mealType ?? this.mealType,
      orderCode: orderCode ?? this.orderCode,
      price: price ?? this.price,
      staffId: staffId ?? this.staffId,
      mealId: mealId ?? this.mealId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncUpdatedAt: syncUpdatedAt ?? this.syncUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (mealType.present) {
      map['meal_type'] = Variable<String>(mealType.value);
    }
    if (orderCode.present) {
      map['order_code'] = Variable<String>(orderCode.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (staffId.present) {
      map['staff_id'] = Variable<String>(staffId.value);
    }
    if (mealId.present) {
      map['meal_id'] = Variable<String>(mealId.value);
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OverchargesCompanion(')
          ..write('id: $id, ')
          ..write('mealType: $mealType, ')
          ..write('orderCode: $orderCode, ')
          ..write('price: $price, ')
          ..write('staffId: $staffId, ')
          ..write('mealId: $mealId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt, ')
          ..write('rowid: $rowid')
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
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
    } else if (isInserting) {
      context.missing(_idMeta);
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
        DriftSqlType.string,
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
  final String id;
  final String name;
  final String serialNumber;
  final String? model;
  final String status;
  final String? macAddress;
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
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    this.syncUpdatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['serial_number'] = Variable<String>(serialNumber);
    if (!nullToAbsent || model != null) {
      map['model'] = Variable<String>(model);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || macAddress != null) {
      map['mac_address'] = Variable<String>(macAddress);
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
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      serialNumber: serializer.fromJson<String>(json['serialNumber']),
      model: serializer.fromJson<String?>(json['model']),
      status: serializer.fromJson<String>(json['status']),
      macAddress: serializer.fromJson<String?>(json['macAddress']),
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
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'serialNumber': serializer.toJson<String>(serialNumber),
      'model': serializer.toJson<String?>(model),
      'status': serializer.toJson<String>(status),
      'macAddress': serializer.toJson<String?>(macAddress),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'syncUpdatedAt': serializer.toJson<String?>(syncUpdatedAt),
    };
  }

  PosDevice copyWith({
    String? id,
    String? name,
    String? serialNumber,
    Value<String?> model = const Value.absent(),
    String? status,
    Value<String?> macAddress = const Value.absent(),
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
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.syncUpdatedAt == this.syncUpdatedAt);
}

class PosDevicesCompanion extends UpdateCompanion<PosDevice> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> serialNumber;
  final Value<String?> model;
  final Value<String> status;
  final Value<String?> macAddress;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> syncStatus;
  final Value<String?> syncUpdatedAt;
  final Value<int> rowid;
  const PosDevicesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.serialNumber = const Value.absent(),
    this.model = const Value.absent(),
    this.status = const Value.absent(),
    this.macAddress = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PosDevicesCompanion.insert({
    required String id,
    required String name,
    required String serialNumber,
    this.model = const Value.absent(),
    required String status,
    this.macAddress = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       serialNumber = Value(serialNumber),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PosDevice> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? serialNumber,
    Expression<String>? model,
    Expression<String>? status,
    Expression<String>? macAddress,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? syncStatus,
    Expression<String>? syncUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (serialNumber != null) 'serial_number': serialNumber,
      if (model != null) 'model': model,
      if (status != null) 'status': status,
      if (macAddress != null) 'mac_address': macAddress,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncUpdatedAt != null) 'sync_updated_at': syncUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PosDevicesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? serialNumber,
    Value<String?>? model,
    Value<String>? status,
    Value<String?>? macAddress,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? syncStatus,
    Value<String?>? syncUpdatedAt,
    Value<int>? rowid,
  }) {
    return PosDevicesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      serialNumber: serialNumber ?? this.serialNumber,
      model: model ?? this.model,
      status: status ?? this.status,
      macAddress: macAddress ?? this.macAddress,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncUpdatedAt: syncUpdatedAt ?? this.syncUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
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
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt, ')
          ..write('rowid: $rowid')
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
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  late final GeneratedColumn<String> actorId = GeneratedColumn<String>(
    'actor_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
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
    } else if (isInserting) {
      context.missing(_idMeta);
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
        DriftSqlType.string,
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
        DriftSqlType.string,
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
  final String id;
  final String type;
  final String message;
  final String? actorType;
  final String? actorId;
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
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['message'] = Variable<String>(message);
    if (!nullToAbsent || actorType != null) {
      map['actor_type'] = Variable<String>(actorType);
    }
    if (!nullToAbsent || actorId != null) {
      map['actor_id'] = Variable<String>(actorId);
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
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      message: serializer.fromJson<String>(json['message']),
      actorType: serializer.fromJson<String?>(json['actorType']),
      actorId: serializer.fromJson<String?>(json['actorId']),
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
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'message': serializer.toJson<String>(message),
      'actorType': serializer.toJson<String?>(actorType),
      'actorId': serializer.toJson<String?>(actorId),
      'actorName': serializer.toJson<String?>(actorName),
      'sourceTable': serializer.toJson<String?>(sourceTable),
      'recordId': serializer.toJson<String?>(recordId),
      'metadata': serializer.toJson<String?>(metadata),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  ActivityLog copyWith({
    String? id,
    String? type,
    String? message,
    Value<String?> actorType = const Value.absent(),
    Value<String?> actorId = const Value.absent(),
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
  final Value<String> id;
  final Value<String> type;
  final Value<String> message;
  final Value<String?> actorType;
  final Value<String?> actorId;
  final Value<String?> actorName;
  final Value<String?> sourceTable;
  final Value<String?> recordId;
  final Value<String?> metadata;
  final Value<String> createdAt;
  final Value<int> rowid;
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
    this.rowid = const Value.absent(),
  });
  ActivityLogsCompanion.insert({
    required String id,
    required String type,
    required String message,
    this.actorType = const Value.absent(),
    this.actorId = const Value.absent(),
    this.actorName = const Value.absent(),
    this.sourceTable = const Value.absent(),
    this.recordId = const Value.absent(),
    this.metadata = const Value.absent(),
    required String createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       message = Value(message),
       createdAt = Value(createdAt);
  static Insertable<ActivityLog> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? message,
    Expression<String>? actorType,
    Expression<String>? actorId,
    Expression<String>? actorName,
    Expression<String>? sourceTable,
    Expression<String>? recordId,
    Expression<String>? metadata,
    Expression<String>? createdAt,
    Expression<int>? rowid,
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
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivityLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? type,
    Value<String>? message,
    Value<String?>? actorType,
    Value<String?>? actorId,
    Value<String?>? actorName,
    Value<String?>? sourceTable,
    Value<String?>? recordId,
    Value<String?>? metadata,
    Value<String>? createdAt,
    Value<int>? rowid,
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
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
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
      map['actor_id'] = Variable<String>(actorId.value);
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
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
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
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
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
    } else if (isInserting) {
      context.missing(_idMeta);
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
        DriftSqlType.string,
        data['${effectivePrefix}id'],
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
  final String id;
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
    map['id'] = Variable<String>(id);
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
      id: serializer.fromJson<String>(json['id']),
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
      'id': serializer.toJson<String>(id),
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
    String? id,
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
  final Value<String> id;
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
  final Value<int> rowid;
  const GroupOrdersCompanion({
    this.id = const Value.absent(),
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
    this.rowid = const Value.absent(),
  });
  GroupOrdersCompanion.insert({
    required String id,
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
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       orderCode = Value(orderCode),
       status = Value(status),
       orderType = Value(orderType),
       mealType = Value(mealType),
       total = Value(total),
       groupCount = Value(groupCount),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<GroupOrder> custom({
    Expression<String>? id,
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
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
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
      if (rowid != null) 'rowid': rowid,
    });
  }

  GroupOrdersCompanion copyWith({
    Value<String>? id,
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
    Value<int>? rowid,
  }) {
    return GroupOrdersCompanion(
      id: id ?? this.id,
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
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupOrdersCompanion(')
          ..write('id: $id, ')
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
          ..write('syncUpdatedAt: $syncUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GroupOrderItemsTable extends GroupOrderItems
    with TableInfo<$GroupOrderItemsTable, GroupOrderItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupOrderItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qtyMeta = const VerificationMeta('qty');
  @override
  late final GeneratedColumn<int> qty = GeneratedColumn<int>(
    'qty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mealIdMeta = const VerificationMeta('mealId');
  @override
  late final GeneratedColumn<String> mealId = GeneratedColumn<String>(
    'meal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES meals (id)',
    ),
  );
  static const VerificationMeta _groupOrderIdMeta = const VerificationMeta(
    'groupOrderId',
  );
  @override
  late final GeneratedColumn<String> groupOrderId = GeneratedColumn<String>(
    'group_order_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES group_orders (id)',
    ),
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
    price,
    qty,
    mealId,
    groupOrderId,
    createdAt,
    updatedAt,
    syncStatus,
    syncUpdatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'group_order_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<GroupOrderItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('qty')) {
      context.handle(
        _qtyMeta,
        qty.isAcceptableOrUnknown(data['qty']!, _qtyMeta),
      );
    } else if (isInserting) {
      context.missing(_qtyMeta);
    }
    if (data.containsKey('meal_id')) {
      context.handle(
        _mealIdMeta,
        mealId.isAcceptableOrUnknown(data['meal_id']!, _mealIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mealIdMeta);
    }
    if (data.containsKey('group_order_id')) {
      context.handle(
        _groupOrderIdMeta,
        groupOrderId.isAcceptableOrUnknown(
          data['group_order_id']!,
          _groupOrderIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_groupOrderIdMeta);
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
  GroupOrderItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupOrderItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      qty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}qty'],
      )!,
      mealId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_id'],
      )!,
      groupOrderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_order_id'],
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
  $GroupOrderItemsTable createAlias(String alias) {
    return $GroupOrderItemsTable(attachedDatabase, alias);
  }
}

class GroupOrderItem extends DataClass implements Insertable<GroupOrderItem> {
  final String id;
  final double price;
  final int qty;
  final String mealId;
  final String groupOrderId;
  final String createdAt;
  final String updatedAt;
  final int syncStatus;
  final String? syncUpdatedAt;
  const GroupOrderItem({
    required this.id,
    required this.price,
    required this.qty,
    required this.mealId,
    required this.groupOrderId,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    this.syncUpdatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['price'] = Variable<double>(price);
    map['qty'] = Variable<int>(qty);
    map['meal_id'] = Variable<String>(mealId);
    map['group_order_id'] = Variable<String>(groupOrderId);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    map['sync_status'] = Variable<int>(syncStatus);
    if (!nullToAbsent || syncUpdatedAt != null) {
      map['sync_updated_at'] = Variable<String>(syncUpdatedAt);
    }
    return map;
  }

  GroupOrderItemsCompanion toCompanion(bool nullToAbsent) {
    return GroupOrderItemsCompanion(
      id: Value(id),
      price: Value(price),
      qty: Value(qty),
      mealId: Value(mealId),
      groupOrderId: Value(groupOrderId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      syncUpdatedAt: syncUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdatedAt),
    );
  }

  factory GroupOrderItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupOrderItem(
      id: serializer.fromJson<String>(json['id']),
      price: serializer.fromJson<double>(json['price']),
      qty: serializer.fromJson<int>(json['qty']),
      mealId: serializer.fromJson<String>(json['mealId']),
      groupOrderId: serializer.fromJson<String>(json['groupOrderId']),
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
      'id': serializer.toJson<String>(id),
      'price': serializer.toJson<double>(price),
      'qty': serializer.toJson<int>(qty),
      'mealId': serializer.toJson<String>(mealId),
      'groupOrderId': serializer.toJson<String>(groupOrderId),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'syncUpdatedAt': serializer.toJson<String?>(syncUpdatedAt),
    };
  }

  GroupOrderItem copyWith({
    String? id,
    double? price,
    int? qty,
    String? mealId,
    String? groupOrderId,
    String? createdAt,
    String? updatedAt,
    int? syncStatus,
    Value<String?> syncUpdatedAt = const Value.absent(),
  }) => GroupOrderItem(
    id: id ?? this.id,
    price: price ?? this.price,
    qty: qty ?? this.qty,
    mealId: mealId ?? this.mealId,
    groupOrderId: groupOrderId ?? this.groupOrderId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    syncUpdatedAt: syncUpdatedAt.present
        ? syncUpdatedAt.value
        : this.syncUpdatedAt,
  );
  GroupOrderItem copyWithCompanion(GroupOrderItemsCompanion data) {
    return GroupOrderItem(
      id: data.id.present ? data.id.value : this.id,
      price: data.price.present ? data.price.value : this.price,
      qty: data.qty.present ? data.qty.value : this.qty,
      mealId: data.mealId.present ? data.mealId.value : this.mealId,
      groupOrderId: data.groupOrderId.present
          ? data.groupOrderId.value
          : this.groupOrderId,
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
    return (StringBuffer('GroupOrderItem(')
          ..write('id: $id, ')
          ..write('price: $price, ')
          ..write('qty: $qty, ')
          ..write('mealId: $mealId, ')
          ..write('groupOrderId: $groupOrderId, ')
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
    price,
    qty,
    mealId,
    groupOrderId,
    createdAt,
    updatedAt,
    syncStatus,
    syncUpdatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupOrderItem &&
          other.id == this.id &&
          other.price == this.price &&
          other.qty == this.qty &&
          other.mealId == this.mealId &&
          other.groupOrderId == this.groupOrderId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.syncUpdatedAt == this.syncUpdatedAt);
}

class GroupOrderItemsCompanion extends UpdateCompanion<GroupOrderItem> {
  final Value<String> id;
  final Value<double> price;
  final Value<int> qty;
  final Value<String> mealId;
  final Value<String> groupOrderId;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> syncStatus;
  final Value<String?> syncUpdatedAt;
  final Value<int> rowid;
  const GroupOrderItemsCompanion({
    this.id = const Value.absent(),
    this.price = const Value.absent(),
    this.qty = const Value.absent(),
    this.mealId = const Value.absent(),
    this.groupOrderId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GroupOrderItemsCompanion.insert({
    required String id,
    required double price,
    required int qty,
    required String mealId,
    required String groupOrderId,
    required String createdAt,
    required String updatedAt,
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       price = Value(price),
       qty = Value(qty),
       mealId = Value(mealId),
       groupOrderId = Value(groupOrderId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<GroupOrderItem> custom({
    Expression<String>? id,
    Expression<double>? price,
    Expression<int>? qty,
    Expression<String>? mealId,
    Expression<String>? groupOrderId,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? syncStatus,
    Expression<String>? syncUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (price != null) 'price': price,
      if (qty != null) 'qty': qty,
      if (mealId != null) 'meal_id': mealId,
      if (groupOrderId != null) 'group_order_id': groupOrderId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncUpdatedAt != null) 'sync_updated_at': syncUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GroupOrderItemsCompanion copyWith({
    Value<String>? id,
    Value<double>? price,
    Value<int>? qty,
    Value<String>? mealId,
    Value<String>? groupOrderId,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? syncStatus,
    Value<String?>? syncUpdatedAt,
    Value<int>? rowid,
  }) {
    return GroupOrderItemsCompanion(
      id: id ?? this.id,
      price: price ?? this.price,
      qty: qty ?? this.qty,
      mealId: mealId ?? this.mealId,
      groupOrderId: groupOrderId ?? this.groupOrderId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncUpdatedAt: syncUpdatedAt ?? this.syncUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (qty.present) {
      map['qty'] = Variable<int>(qty.value);
    }
    if (mealId.present) {
      map['meal_id'] = Variable<String>(mealId.value);
    }
    if (groupOrderId.present) {
      map['group_order_id'] = Variable<String>(groupOrderId.value);
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupOrderItemsCompanion(')
          ..write('id: $id, ')
          ..write('price: $price, ')
          ..write('qty: $qty, ')
          ..write('mealId: $mealId, ')
          ..write('groupOrderId: $groupOrderId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncUpdatedAt: $syncUpdatedAt, ')
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
  late final GeneratedColumn<String> staffId = GeneratedColumn<String>(
    'staff_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES staff (id)',
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
    } else if (isInserting) {
      context.missing(_staffIdMeta);
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
        DriftSqlType.string,
        data['${effectivePrefix}staff_id'],
      )!,
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
  /// Remote API integer ID.
  final int id;
  final String staffId;

  /// Which finger this template belongs to (e.g. 'left_thumb', 'right_index').
  final String finger;

  /// Raw biometric template stored as a Base64 string.
  final String dataBase64;
  final bool isActive;
  final String createdAt;
  final String updatedAt;
  final int syncStatus;
  final String? syncUpdatedAt;
  const BioDataEntry({
    required this.id,
    required this.staffId,
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
    map['staff_id'] = Variable<String>(staffId);
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
      staffId: Value(staffId),
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
      staffId: serializer.fromJson<String>(json['staffId']),
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
      'staffId': serializer.toJson<String>(staffId),
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
    String? staffId,
    String? finger,
    String? dataBase64,
    bool? isActive,
    String? createdAt,
    String? updatedAt,
    int? syncStatus,
    Value<String?> syncUpdatedAt = const Value.absent(),
  }) => BioDataEntry(
    id: id ?? this.id,
    staffId: staffId ?? this.staffId,
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
  final Value<String> staffId;
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
    required String staffId,
    required String finger,
    required String dataBase64,
    this.isActive = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.syncStatus = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
  }) : staffId = Value(staffId),
       finger = Value(finger),
       dataBase64 = Value(dataBase64),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<BioDataEntry> custom({
    Expression<int>? id,
    Expression<String>? staffId,
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
    Value<String>? staffId,
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
      map['staff_id'] = Variable<String>(staffId.value);
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
  late final $KitchensTable kitchens = $KitchensTable(this);
  late final $MenuTypesTable menuTypes = $MenuTypesTable(this);
  late final $MealsTable meals = $MealsTable(this);
  late final $MealKitchensTable mealKitchens = $MealKitchensTable(this);
  late final $StaffTable staff = $StaffTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $UserKitchensTable userKitchens = $UserKitchensTable(this);
  late final $OrdersTable orders = $OrdersTable(this);
  late final $OrderItemsTable orderItems = $OrderItemsTable(this);
  late final $OverchargesTable overcharges = $OverchargesTable(this);
  late final $PosDevicesTable posDevices = $PosDevicesTable(this);
  late final $ActivityLogsTable activityLogs = $ActivityLogsTable(this);
  late final $GroupOrdersTable groupOrders = $GroupOrdersTable(this);
  late final $GroupOrderItemsTable groupOrderItems = $GroupOrderItemsTable(
    this,
  );
  late final $BioDataEntriesTable bioDataEntries = $BioDataEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    sites,
    kitchens,
    menuTypes,
    meals,
    mealKitchens,
    staff,
    users,
    userKitchens,
    orders,
    orderItems,
    overcharges,
    posDevices,
    activityLogs,
    groupOrders,
    groupOrderItems,
    bioDataEntries,
  ];
}

typedef $$SitesTableCreateCompanionBuilder =
    SitesCompanion Function({
      required String id,
      required String name,
      Value<String?> location,
      Value<int> noOfEmployees,
      Value<bool> isActive,
      Value<String?> startDate,
      Value<String?> endDate,
      required String createdAt,
      required String updatedAt,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
      Value<int> rowid,
    });
typedef $$SitesTableUpdateCompanionBuilder =
    SitesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> location,
      Value<int> noOfEmployees,
      Value<bool> isActive,
      Value<String?> startDate,
      Value<String?> endDate,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
      Value<int> rowid,
    });

final class $$SitesTableReferences
    extends BaseReferences<_$AppDatabase, $SitesTable, Site> {
  $$SitesTableReferences(super.$_db, super.$_table, super.$_typedResult);

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
    ).filter((f) => f.companyId.id.sqlEquals($_itemColumn<String>('id')!));

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
  ColumnFilters<String> get id => $composableBuilder(
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
  ColumnOrderings<String> get id => $composableBuilder(
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

class $$SitesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SitesTable> {
  $$SitesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
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
          PrefetchHooks Function({bool kitchensRefs})
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
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<int> noOfEmployees = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String?> startDate = const Value.absent(),
                Value<String?> endDate = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SitesCompanion(
                id: id,
                name: name,
                location: location,
                noOfEmployees: noOfEmployees,
                isActive: isActive,
                startDate: startDate,
                endDate: endDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> location = const Value.absent(),
                Value<int> noOfEmployees = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String?> startDate = const Value.absent(),
                Value<String?> endDate = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SitesCompanion.insert(
                id: id,
                name: name,
                location: location,
                noOfEmployees: noOfEmployees,
                isActive: isActive,
                startDate: startDate,
                endDate: endDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$SitesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({kitchensRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (kitchensRefs) db.kitchens],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (kitchensRefs)
                    await $_getPrefetchedData<Site, $SitesTable, Kitchen>(
                      currentTable: table,
                      referencedTable: $$SitesTableReferences
                          ._kitchensRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SitesTableReferences(db, table, p0).kitchensRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.companyId == item.id),
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
      PrefetchHooks Function({bool kitchensRefs})
    >;
typedef $$KitchensTableCreateCompanionBuilder =
    KitchensCompanion Function({
      required String id,
      required String name,
      required int minTierRequired,
      required String status,
      required String companyId,
      required String createdAt,
      required String updatedAt,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
      Value<int> rowid,
    });
typedef $$KitchensTableUpdateCompanionBuilder =
    KitchensCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> minTierRequired,
      Value<String> status,
      Value<String> companyId,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
      Value<int> rowid,
    });

final class $$KitchensTableReferences
    extends BaseReferences<_$AppDatabase, $KitchensTable, Kitchen> {
  $$KitchensTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SitesTable _companyIdTable(_$AppDatabase db) => db.sites.createAlias(
    $_aliasNameGenerator(db.kitchens.companyId, db.sites.id),
  );

  $$SitesTableProcessedTableManager get companyId {
    final $_column = $_itemColumn<String>('company_id')!;

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

  static MultiTypedResultKey<$MealKitchensTable, List<MealKitchen>>
  _mealKitchensRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.mealKitchens,
    aliasName: $_aliasNameGenerator(db.kitchens.id, db.mealKitchens.kitchenId),
  );

  $$MealKitchensTableProcessedTableManager get mealKitchensRefs {
    final manager = $$MealKitchensTableTableManager(
      $_db,
      $_db.mealKitchens,
    ).filter((f) => f.kitchenId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_mealKitchensRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$UserKitchensTable, List<UserKitchen>>
  _userKitchensRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.userKitchens,
    aliasName: $_aliasNameGenerator(db.kitchens.id, db.userKitchens.kitchenId),
  );

  $$UserKitchensTableProcessedTableManager get userKitchensRefs {
    final manager = $$UserKitchensTableTableManager(
      $_db,
      $_db.userKitchens,
    ).filter((f) => f.kitchenId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_userKitchensRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
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
  ColumnFilters<String> get id => $composableBuilder(
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

  Expression<bool> mealKitchensRefs(
    Expression<bool> Function($$MealKitchensTableFilterComposer f) f,
  ) {
    final $$MealKitchensTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealKitchens,
      getReferencedColumn: (t) => t.kitchenId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealKitchensTableFilterComposer(
            $db: $db,
            $table: $db.mealKitchens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> userKitchensRefs(
    Expression<bool> Function($$UserKitchensTableFilterComposer f) f,
  ) {
    final $$UserKitchensTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userKitchens,
      getReferencedColumn: (t) => t.kitchenId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserKitchensTableFilterComposer(
            $db: $db,
            $table: $db.userKitchens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
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
  ColumnOrderings<String> get id => $composableBuilder(
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
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get minTierRequired => $composableBuilder(
    column: $table.minTierRequired,
    builder: (column) => column,
  );

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

  Expression<T> mealKitchensRefs<T extends Object>(
    Expression<T> Function($$MealKitchensTableAnnotationComposer a) f,
  ) {
    final $$MealKitchensTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealKitchens,
      getReferencedColumn: (t) => t.kitchenId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealKitchensTableAnnotationComposer(
            $db: $db,
            $table: $db.mealKitchens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> userKitchensRefs<T extends Object>(
    Expression<T> Function($$UserKitchensTableAnnotationComposer a) f,
  ) {
    final $$UserKitchensTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userKitchens,
      getReferencedColumn: (t) => t.kitchenId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserKitchensTableAnnotationComposer(
            $db: $db,
            $table: $db.userKitchens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
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
          PrefetchHooks Function({
            bool companyId,
            bool mealKitchensRefs,
            bool userKitchensRefs,
          })
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
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> minTierRequired = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> companyId = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KitchensCompanion(
                id: id,
                name: name,
                minTierRequired: minTierRequired,
                status: status,
                companyId: companyId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int minTierRequired,
                required String status,
                required String companyId,
                required String createdAt,
                required String updatedAt,
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KitchensCompanion.insert(
                id: id,
                name: name,
                minTierRequired: minTierRequired,
                status: status,
                companyId: companyId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$KitchensTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                companyId = false,
                mealKitchensRefs = false,
                userKitchensRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (mealKitchensRefs) db.mealKitchens,
                    if (userKitchensRefs) db.userKitchens,
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
                    return [
                      if (mealKitchensRefs)
                        await $_getPrefetchedData<
                          Kitchen,
                          $KitchensTable,
                          MealKitchen
                        >(
                          currentTable: table,
                          referencedTable: $$KitchensTableReferences
                              ._mealKitchensRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$KitchensTableReferences(
                                db,
                                table,
                                p0,
                              ).mealKitchensRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.kitchenId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (userKitchensRefs)
                        await $_getPrefetchedData<
                          Kitchen,
                          $KitchensTable,
                          UserKitchen
                        >(
                          currentTable: table,
                          referencedTable: $$KitchensTableReferences
                              ._userKitchensRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$KitchensTableReferences(
                                db,
                                table,
                                p0,
                              ).userKitchensRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.kitchenId == item.id,
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
      PrefetchHooks Function({
        bool companyId,
        bool mealKitchensRefs,
        bool userKitchensRefs,
      })
    >;
typedef $$MenuTypesTableCreateCompanionBuilder =
    MenuTypesCompanion Function({
      required String id,
      required String name,
      Value<String?> remarks,
      required String status,
      required String createdAt,
      required String updatedAt,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
      Value<int> rowid,
    });
typedef $$MenuTypesTableUpdateCompanionBuilder =
    MenuTypesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> remarks,
      Value<String> status,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
      Value<int> rowid,
    });

final class $$MenuTypesTableReferences
    extends BaseReferences<_$AppDatabase, $MenuTypesTable, MenuType> {
  $$MenuTypesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MealsTable, List<Meal>> _mealsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.meals,
    aliasName: $_aliasNameGenerator(db.menuTypes.id, db.meals.menuTypeId),
  );

  $$MealsTableProcessedTableManager get mealsRefs {
    final manager = $$MealsTableTableManager(
      $_db,
      $_db.meals,
    ).filter((f) => f.menuTypeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_mealsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MenuTypesTableFilterComposer
    extends Composer<_$AppDatabase, $MenuTypesTable> {
  $$MenuTypesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
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

  Expression<bool> mealsRefs(
    Expression<bool> Function($$MealsTableFilterComposer f) f,
  ) {
    final $$MealsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.menuTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealsTableFilterComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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
  ColumnOrderings<String> get id => $composableBuilder(
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
  GeneratedColumn<String> get id =>
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

  Expression<T> mealsRefs<T extends Object>(
    Expression<T> Function($$MealsTableAnnotationComposer a) f,
  ) {
    final $$MealsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.menuTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealsTableAnnotationComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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
          (MenuType, $$MenuTypesTableReferences),
          MenuType,
          PrefetchHooks Function({bool mealsRefs})
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
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> remarks = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MenuTypesCompanion(
                id: id,
                name: name,
                remarks: remarks,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> remarks = const Value.absent(),
                required String status,
                required String createdAt,
                required String updatedAt,
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MenuTypesCompanion.insert(
                id: id,
                name: name,
                remarks: remarks,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MenuTypesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({mealsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (mealsRefs) db.meals],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (mealsRefs)
                    await $_getPrefetchedData<MenuType, $MenuTypesTable, Meal>(
                      currentTable: table,
                      referencedTable: $$MenuTypesTableReferences
                          ._mealsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$MenuTypesTableReferences(db, table, p0).mealsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.menuTypeId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
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
      (MenuType, $$MenuTypesTableReferences),
      MenuType,
      PrefetchHooks Function({bool mealsRefs})
    >;
typedef $$MealsTableCreateCompanionBuilder =
    MealsCompanion Function({
      required String id,
      required String name,
      required String status,
      required String mealType,
      Value<String?> remarks,
      required double price,
      Value<String?> photoUrl,
      required String menuTypeId,
      required String createdAt,
      required String updatedAt,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
      Value<int> rowid,
    });
typedef $$MealsTableUpdateCompanionBuilder =
    MealsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> status,
      Value<String> mealType,
      Value<String?> remarks,
      Value<double> price,
      Value<String?> photoUrl,
      Value<String> menuTypeId,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
      Value<int> rowid,
    });

final class $$MealsTableReferences
    extends BaseReferences<_$AppDatabase, $MealsTable, Meal> {
  $$MealsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MenuTypesTable _menuTypeIdTable(_$AppDatabase db) => db.menuTypes
      .createAlias($_aliasNameGenerator(db.meals.menuTypeId, db.menuTypes.id));

  $$MenuTypesTableProcessedTableManager get menuTypeId {
    final $_column = $_itemColumn<String>('menu_type_id')!;

    final manager = $$MenuTypesTableTableManager(
      $_db,
      $_db.menuTypes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_menuTypeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MealKitchensTable, List<MealKitchen>>
  _mealKitchensRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.mealKitchens,
    aliasName: $_aliasNameGenerator(db.meals.id, db.mealKitchens.mealId),
  );

  $$MealKitchensTableProcessedTableManager get mealKitchensRefs {
    final manager = $$MealKitchensTableTableManager(
      $_db,
      $_db.mealKitchens,
    ).filter((f) => f.mealId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_mealKitchensRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OrderItemsTable, List<OrderItem>>
  _orderItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.orderItems,
    aliasName: $_aliasNameGenerator(db.meals.id, db.orderItems.mealId),
  );

  $$OrderItemsTableProcessedTableManager get orderItemsRefs {
    final manager = $$OrderItemsTableTableManager(
      $_db,
      $_db.orderItems,
    ).filter((f) => f.mealId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_orderItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OverchargesTable, List<Overcharge>>
  _overchargesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.overcharges,
    aliasName: $_aliasNameGenerator(db.meals.id, db.overcharges.mealId),
  );

  $$OverchargesTableProcessedTableManager get overchargesRefs {
    final manager = $$OverchargesTableTableManager(
      $_db,
      $_db.overcharges,
    ).filter((f) => f.mealId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_overchargesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GroupOrderItemsTable, List<GroupOrderItem>>
  _groupOrderItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.groupOrderItems,
    aliasName: $_aliasNameGenerator(db.meals.id, db.groupOrderItems.mealId),
  );

  $$GroupOrderItemsTableProcessedTableManager get groupOrderItemsRefs {
    final manager = $$GroupOrderItemsTableTableManager(
      $_db,
      $_db.groupOrderItems,
    ).filter((f) => f.mealId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _groupOrderItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MealsTableFilterComposer extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
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

  ColumnFilters<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remarks => $composableBuilder(
    column: $table.remarks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoUrl => $composableBuilder(
    column: $table.photoUrl,
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

  $$MenuTypesTableFilterComposer get menuTypeId {
    final $$MenuTypesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.menuTypeId,
      referencedTable: $db.menuTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MenuTypesTableFilterComposer(
            $db: $db,
            $table: $db.menuTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> mealKitchensRefs(
    Expression<bool> Function($$MealKitchensTableFilterComposer f) f,
  ) {
    final $$MealKitchensTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealKitchens,
      getReferencedColumn: (t) => t.mealId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealKitchensTableFilterComposer(
            $db: $db,
            $table: $db.mealKitchens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> orderItemsRefs(
    Expression<bool> Function($$OrderItemsTableFilterComposer f) f,
  ) {
    final $$OrderItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItems,
      getReferencedColumn: (t) => t.mealId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableFilterComposer(
            $db: $db,
            $table: $db.orderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> overchargesRefs(
    Expression<bool> Function($$OverchargesTableFilterComposer f) f,
  ) {
    final $$OverchargesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.overcharges,
      getReferencedColumn: (t) => t.mealId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OverchargesTableFilterComposer(
            $db: $db,
            $table: $db.overcharges,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> groupOrderItemsRefs(
    Expression<bool> Function($$GroupOrderItemsTableFilterComposer f) f,
  ) {
    final $$GroupOrderItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupOrderItems,
      getReferencedColumn: (t) => t.mealId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupOrderItemsTableFilterComposer(
            $db: $db,
            $table: $db.groupOrderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MealsTableOrderingComposer
    extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
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

  ColumnOrderings<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remarks => $composableBuilder(
    column: $table.remarks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoUrl => $composableBuilder(
    column: $table.photoUrl,
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

  $$MenuTypesTableOrderingComposer get menuTypeId {
    final $$MenuTypesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.menuTypeId,
      referencedTable: $db.menuTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MenuTypesTableOrderingComposer(
            $db: $db,
            $table: $db.menuTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get mealType =>
      $composableBuilder(column: $table.mealType, builder: (column) => column);

  GeneratedColumn<String> get remarks =>
      $composableBuilder(column: $table.remarks, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get photoUrl =>
      $composableBuilder(column: $table.photoUrl, builder: (column) => column);

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

  $$MenuTypesTableAnnotationComposer get menuTypeId {
    final $$MenuTypesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.menuTypeId,
      referencedTable: $db.menuTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MenuTypesTableAnnotationComposer(
            $db: $db,
            $table: $db.menuTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> mealKitchensRefs<T extends Object>(
    Expression<T> Function($$MealKitchensTableAnnotationComposer a) f,
  ) {
    final $$MealKitchensTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealKitchens,
      getReferencedColumn: (t) => t.mealId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealKitchensTableAnnotationComposer(
            $db: $db,
            $table: $db.mealKitchens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> orderItemsRefs<T extends Object>(
    Expression<T> Function($$OrderItemsTableAnnotationComposer a) f,
  ) {
    final $$OrderItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItems,
      getReferencedColumn: (t) => t.mealId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.orderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> overchargesRefs<T extends Object>(
    Expression<T> Function($$OverchargesTableAnnotationComposer a) f,
  ) {
    final $$OverchargesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.overcharges,
      getReferencedColumn: (t) => t.mealId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OverchargesTableAnnotationComposer(
            $db: $db,
            $table: $db.overcharges,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> groupOrderItemsRefs<T extends Object>(
    Expression<T> Function($$GroupOrderItemsTableAnnotationComposer a) f,
  ) {
    final $$GroupOrderItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupOrderItems,
      getReferencedColumn: (t) => t.mealId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupOrderItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.groupOrderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MealsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealsTable,
          Meal,
          $$MealsTableFilterComposer,
          $$MealsTableOrderingComposer,
          $$MealsTableAnnotationComposer,
          $$MealsTableCreateCompanionBuilder,
          $$MealsTableUpdateCompanionBuilder,
          (Meal, $$MealsTableReferences),
          Meal,
          PrefetchHooks Function({
            bool menuTypeId,
            bool mealKitchensRefs,
            bool orderItemsRefs,
            bool overchargesRefs,
            bool groupOrderItemsRefs,
          })
        > {
  $$MealsTableTableManager(_$AppDatabase db, $MealsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> mealType = const Value.absent(),
                Value<String?> remarks = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<String?> photoUrl = const Value.absent(),
                Value<String> menuTypeId = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MealsCompanion(
                id: id,
                name: name,
                status: status,
                mealType: mealType,
                remarks: remarks,
                price: price,
                photoUrl: photoUrl,
                menuTypeId: menuTypeId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String status,
                required String mealType,
                Value<String?> remarks = const Value.absent(),
                required double price,
                Value<String?> photoUrl = const Value.absent(),
                required String menuTypeId,
                required String createdAt,
                required String updatedAt,
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MealsCompanion.insert(
                id: id,
                name: name,
                status: status,
                mealType: mealType,
                remarks: remarks,
                price: price,
                photoUrl: photoUrl,
                menuTypeId: menuTypeId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$MealsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                menuTypeId = false,
                mealKitchensRefs = false,
                orderItemsRefs = false,
                overchargesRefs = false,
                groupOrderItemsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (mealKitchensRefs) db.mealKitchens,
                    if (orderItemsRefs) db.orderItems,
                    if (overchargesRefs) db.overcharges,
                    if (groupOrderItemsRefs) db.groupOrderItems,
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
                        if (menuTypeId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.menuTypeId,
                                    referencedTable: $$MealsTableReferences
                                        ._menuTypeIdTable(db),
                                    referencedColumn: $$MealsTableReferences
                                        ._menuTypeIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (mealKitchensRefs)
                        await $_getPrefetchedData<
                          Meal,
                          $MealsTable,
                          MealKitchen
                        >(
                          currentTable: table,
                          referencedTable: $$MealsTableReferences
                              ._mealKitchensRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MealsTableReferences(
                                db,
                                table,
                                p0,
                              ).mealKitchensRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.mealId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (orderItemsRefs)
                        await $_getPrefetchedData<Meal, $MealsTable, OrderItem>(
                          currentTable: table,
                          referencedTable: $$MealsTableReferences
                              ._orderItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MealsTableReferences(
                                db,
                                table,
                                p0,
                              ).orderItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.mealId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (overchargesRefs)
                        await $_getPrefetchedData<
                          Meal,
                          $MealsTable,
                          Overcharge
                        >(
                          currentTable: table,
                          referencedTable: $$MealsTableReferences
                              ._overchargesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MealsTableReferences(
                                db,
                                table,
                                p0,
                              ).overchargesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.mealId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (groupOrderItemsRefs)
                        await $_getPrefetchedData<
                          Meal,
                          $MealsTable,
                          GroupOrderItem
                        >(
                          currentTable: table,
                          referencedTable: $$MealsTableReferences
                              ._groupOrderItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MealsTableReferences(
                                db,
                                table,
                                p0,
                              ).groupOrderItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.mealId == item.id,
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

typedef $$MealsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealsTable,
      Meal,
      $$MealsTableFilterComposer,
      $$MealsTableOrderingComposer,
      $$MealsTableAnnotationComposer,
      $$MealsTableCreateCompanionBuilder,
      $$MealsTableUpdateCompanionBuilder,
      (Meal, $$MealsTableReferences),
      Meal,
      PrefetchHooks Function({
        bool menuTypeId,
        bool mealKitchensRefs,
        bool orderItemsRefs,
        bool overchargesRefs,
        bool groupOrderItemsRefs,
      })
    >;
typedef $$MealKitchensTableCreateCompanionBuilder =
    MealKitchensCompanion Function({
      required String mealId,
      required String kitchenId,
      Value<int> rowid,
    });
typedef $$MealKitchensTableUpdateCompanionBuilder =
    MealKitchensCompanion Function({
      Value<String> mealId,
      Value<String> kitchenId,
      Value<int> rowid,
    });

final class $$MealKitchensTableReferences
    extends BaseReferences<_$AppDatabase, $MealKitchensTable, MealKitchen> {
  $$MealKitchensTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MealsTable _mealIdTable(_$AppDatabase db) => db.meals.createAlias(
    $_aliasNameGenerator(db.mealKitchens.mealId, db.meals.id),
  );

  $$MealsTableProcessedTableManager get mealId {
    final $_column = $_itemColumn<String>('meal_id')!;

    final manager = $$MealsTableTableManager(
      $_db,
      $_db.meals,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mealIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $KitchensTable _kitchenIdTable(_$AppDatabase db) =>
      db.kitchens.createAlias(
        $_aliasNameGenerator(db.mealKitchens.kitchenId, db.kitchens.id),
      );

  $$KitchensTableProcessedTableManager get kitchenId {
    final $_column = $_itemColumn<String>('kitchen_id')!;

    final manager = $$KitchensTableTableManager(
      $_db,
      $_db.kitchens,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_kitchenIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MealKitchensTableFilterComposer
    extends Composer<_$AppDatabase, $MealKitchensTable> {
  $$MealKitchensTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$MealsTableFilterComposer get mealId {
    final $$MealsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealId,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealsTableFilterComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$KitchensTableFilterComposer get kitchenId {
    final $$KitchensTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kitchenId,
      referencedTable: $db.kitchens,
      getReferencedColumn: (t) => t.id,
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
    return composer;
  }
}

class $$MealKitchensTableOrderingComposer
    extends Composer<_$AppDatabase, $MealKitchensTable> {
  $$MealKitchensTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$MealsTableOrderingComposer get mealId {
    final $$MealsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealId,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealsTableOrderingComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$KitchensTableOrderingComposer get kitchenId {
    final $$KitchensTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kitchenId,
      referencedTable: $db.kitchens,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KitchensTableOrderingComposer(
            $db: $db,
            $table: $db.kitchens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealKitchensTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealKitchensTable> {
  $$MealKitchensTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$MealsTableAnnotationComposer get mealId {
    final $$MealsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealId,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealsTableAnnotationComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$KitchensTableAnnotationComposer get kitchenId {
    final $$KitchensTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kitchenId,
      referencedTable: $db.kitchens,
      getReferencedColumn: (t) => t.id,
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
    return composer;
  }
}

class $$MealKitchensTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealKitchensTable,
          MealKitchen,
          $$MealKitchensTableFilterComposer,
          $$MealKitchensTableOrderingComposer,
          $$MealKitchensTableAnnotationComposer,
          $$MealKitchensTableCreateCompanionBuilder,
          $$MealKitchensTableUpdateCompanionBuilder,
          (MealKitchen, $$MealKitchensTableReferences),
          MealKitchen,
          PrefetchHooks Function({bool mealId, bool kitchenId})
        > {
  $$MealKitchensTableTableManager(_$AppDatabase db, $MealKitchensTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealKitchensTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealKitchensTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealKitchensTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> mealId = const Value.absent(),
                Value<String> kitchenId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MealKitchensCompanion(
                mealId: mealId,
                kitchenId: kitchenId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String mealId,
                required String kitchenId,
                Value<int> rowid = const Value.absent(),
              }) => MealKitchensCompanion.insert(
                mealId: mealId,
                kitchenId: kitchenId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MealKitchensTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({mealId = false, kitchenId = false}) {
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
                    if (mealId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.mealId,
                                referencedTable: $$MealKitchensTableReferences
                                    ._mealIdTable(db),
                                referencedColumn: $$MealKitchensTableReferences
                                    ._mealIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (kitchenId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.kitchenId,
                                referencedTable: $$MealKitchensTableReferences
                                    ._kitchenIdTable(db),
                                referencedColumn: $$MealKitchensTableReferences
                                    ._kitchenIdTable(db)
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

typedef $$MealKitchensTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealKitchensTable,
      MealKitchen,
      $$MealKitchensTableFilterComposer,
      $$MealKitchensTableOrderingComposer,
      $$MealKitchensTableAnnotationComposer,
      $$MealKitchensTableCreateCompanionBuilder,
      $$MealKitchensTableUpdateCompanionBuilder,
      (MealKitchen, $$MealKitchensTableReferences),
      MealKitchen,
      PrefetchHooks Function({bool mealId, bool kitchenId})
    >;
typedef $$StaffTableCreateCompanionBuilder =
    StaffCompanion Function({
      required String id,
      required String firstName,
      required String lastName,
      Value<String?> phone,
      Value<String?> email,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
      Value<int> rowid,
    });
typedef $$StaffTableUpdateCompanionBuilder =
    StaffCompanion Function({
      Value<String> id,
      Value<String> firstName,
      Value<String> lastName,
      Value<String?> phone,
      Value<String?> email,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
      Value<int> rowid,
    });

final class $$StaffTableReferences
    extends BaseReferences<_$AppDatabase, $StaffTable, StaffData> {
  $$StaffTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$OrdersTable, List<Order>> _ordersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.orders,
    aliasName: $_aliasNameGenerator(db.staff.id, db.orders.orderedById),
  );

  $$OrdersTableProcessedTableManager get ordersRefs {
    final manager = $$OrdersTableTableManager(
      $_db,
      $_db.orders,
    ).filter((f) => f.orderedById.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_ordersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OverchargesTable, List<Overcharge>>
  _overchargesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.overcharges,
    aliasName: $_aliasNameGenerator(db.staff.id, db.overcharges.staffId),
  );

  $$OverchargesTableProcessedTableManager get overchargesRefs {
    final manager = $$OverchargesTableTableManager(
      $_db,
      $_db.overcharges,
    ).filter((f) => f.staffId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_overchargesRefsTable($_db));
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
    ).filter((f) => f.staffId.id.sqlEquals($_itemColumn<String>('id')!));

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
  ColumnFilters<String> get id => $composableBuilder(
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

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
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

  Expression<bool> ordersRefs(
    Expression<bool> Function($$OrdersTableFilterComposer f) f,
  ) {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.orderedById,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableFilterComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> overchargesRefs(
    Expression<bool> Function($$OverchargesTableFilterComposer f) f,
  ) {
    final $$OverchargesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.overcharges,
      getReferencedColumn: (t) => t.staffId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OverchargesTableFilterComposer(
            $db: $db,
            $table: $db.overcharges,
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
  ColumnOrderings<String> get id => $composableBuilder(
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

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
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
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => column,
  );

  Expression<T> ordersRefs<T extends Object>(
    Expression<T> Function($$OrdersTableAnnotationComposer a) f,
  ) {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.orderedById,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> overchargesRefs<T extends Object>(
    Expression<T> Function($$OverchargesTableAnnotationComposer a) f,
  ) {
    final $$OverchargesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.overcharges,
      getReferencedColumn: (t) => t.staffId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OverchargesTableAnnotationComposer(
            $db: $db,
            $table: $db.overcharges,
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
          PrefetchHooks Function({
            bool ordersRefs,
            bool overchargesRefs,
            bool bioDataEntriesRefs,
          })
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
                Value<String> id = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String> lastName = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StaffCompanion(
                id: id,
                firstName: firstName,
                lastName: lastName,
                phone: phone,
                email: email,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String firstName,
                required String lastName,
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StaffCompanion.insert(
                id: id,
                firstName: firstName,
                lastName: lastName,
                phone: phone,
                email: email,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$StaffTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                ordersRefs = false,
                overchargesRefs = false,
                bioDataEntriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (ordersRefs) db.orders,
                    if (overchargesRefs) db.overcharges,
                    if (bioDataEntriesRefs) db.bioDataEntries,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (ordersRefs)
                        await $_getPrefetchedData<
                          StaffData,
                          $StaffTable,
                          Order
                        >(
                          currentTable: table,
                          referencedTable: $$StaffTableReferences
                              ._ordersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StaffTableReferences(db, table, p0).ordersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.orderedById == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (overchargesRefs)
                        await $_getPrefetchedData<
                          StaffData,
                          $StaffTable,
                          Overcharge
                        >(
                          currentTable: table,
                          referencedTable: $$StaffTableReferences
                              ._overchargesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StaffTableReferences(
                                db,
                                table,
                                p0,
                              ).overchargesRefs,
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
      PrefetchHooks Function({
        bool ordersRefs,
        bool overchargesRefs,
        bool bioDataEntriesRefs,
      })
    >;
typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      required String id,
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
      Value<int> rowid,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<String> id,
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
      Value<int> rowid,
    });

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$UserKitchensTable, List<UserKitchen>>
  _userKitchensRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.userKitchens,
    aliasName: $_aliasNameGenerator(db.users.id, db.userKitchens.userId),
  );

  $$UserKitchensTableProcessedTableManager get userKitchensRefs {
    final manager = $$UserKitchensTableTableManager(
      $_db,
      $_db.userKitchens,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_userKitchensRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
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

  Expression<bool> userKitchensRefs(
    Expression<bool> Function($$UserKitchensTableFilterComposer f) f,
  ) {
    final $$UserKitchensTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userKitchens,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserKitchensTableFilterComposer(
            $db: $db,
            $table: $db.userKitchens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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
  ColumnOrderings<String> get id => $composableBuilder(
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
  GeneratedColumn<String> get id =>
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

  Expression<T> userKitchensRefs<T extends Object>(
    Expression<T> Function($$UserKitchensTableAnnotationComposer a) f,
  ) {
    final $$UserKitchensTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userKitchens,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserKitchensTableAnnotationComposer(
            $db: $db,
            $table: $db.userKitchens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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
          (User, $$UsersTableReferences),
          User,
          PrefetchHooks Function({bool userKitchensRefs})
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
                Value<String> id = const Value.absent(),
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
                Value<int> rowid = const Value.absent(),
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
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
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
                Value<int> rowid = const Value.absent(),
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
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$UsersTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({userKitchensRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (userKitchensRefs) db.userKitchens],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (userKitchensRefs)
                    await $_getPrefetchedData<User, $UsersTable, UserKitchen>(
                      currentTable: table,
                      referencedTable: $$UsersTableReferences
                          ._userKitchensRefsTable(db),
                      managerFromTypedResult: (p0) => $$UsersTableReferences(
                        db,
                        table,
                        p0,
                      ).userKitchensRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.userId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
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
      (User, $$UsersTableReferences),
      User,
      PrefetchHooks Function({bool userKitchensRefs})
    >;
typedef $$UserKitchensTableCreateCompanionBuilder =
    UserKitchensCompanion Function({
      required String userId,
      required String kitchenId,
      Value<int> rowid,
    });
typedef $$UserKitchensTableUpdateCompanionBuilder =
    UserKitchensCompanion Function({
      Value<String> userId,
      Value<String> kitchenId,
      Value<int> rowid,
    });

final class $$UserKitchensTableReferences
    extends BaseReferences<_$AppDatabase, $UserKitchensTable, UserKitchen> {
  $$UserKitchensTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users.createAlias(
    $_aliasNameGenerator(db.userKitchens.userId, db.users.id),
  );

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $KitchensTable _kitchenIdTable(_$AppDatabase db) =>
      db.kitchens.createAlias(
        $_aliasNameGenerator(db.userKitchens.kitchenId, db.kitchens.id),
      );

  $$KitchensTableProcessedTableManager get kitchenId {
    final $_column = $_itemColumn<String>('kitchen_id')!;

    final manager = $$KitchensTableTableManager(
      $_db,
      $_db.kitchens,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_kitchenIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$UserKitchensTableFilterComposer
    extends Composer<_$AppDatabase, $UserKitchensTable> {
  $$UserKitchensTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$KitchensTableFilterComposer get kitchenId {
    final $$KitchensTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kitchenId,
      referencedTable: $db.kitchens,
      getReferencedColumn: (t) => t.id,
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
    return composer;
  }
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
  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$KitchensTableOrderingComposer get kitchenId {
    final $$KitchensTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kitchenId,
      referencedTable: $db.kitchens,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KitchensTableOrderingComposer(
            $db: $db,
            $table: $db.kitchens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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
  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$KitchensTableAnnotationComposer get kitchenId {
    final $$KitchensTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kitchenId,
      referencedTable: $db.kitchens,
      getReferencedColumn: (t) => t.id,
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
    return composer;
  }
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
          (UserKitchen, $$UserKitchensTableReferences),
          UserKitchen,
          PrefetchHooks Function({bool userId, bool kitchenId})
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
                Value<String> userId = const Value.absent(),
                Value<String> kitchenId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserKitchensCompanion(
                userId: userId,
                kitchenId: kitchenId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String kitchenId,
                Value<int> rowid = const Value.absent(),
              }) => UserKitchensCompanion.insert(
                userId: userId,
                kitchenId: kitchenId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UserKitchensTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false, kitchenId = false}) {
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
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable: $$UserKitchensTableReferences
                                    ._userIdTable(db),
                                referencedColumn: $$UserKitchensTableReferences
                                    ._userIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (kitchenId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.kitchenId,
                                referencedTable: $$UserKitchensTableReferences
                                    ._kitchenIdTable(db),
                                referencedColumn: $$UserKitchensTableReferences
                                    ._kitchenIdTable(db)
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
      (UserKitchen, $$UserKitchensTableReferences),
      UserKitchen,
      PrefetchHooks Function({bool userId, bool kitchenId})
    >;
typedef $$OrdersTableCreateCompanionBuilder =
    OrdersCompanion Function({
      required String id,
      required String orderCode,
      required String status,
      required String orderType,
      required String mealType,
      required double total,
      required int groupCount,
      Value<String?> description,
      required String orderedById,
      required String createdAt,
      required String updatedAt,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
      Value<int> rowid,
    });
typedef $$OrdersTableUpdateCompanionBuilder =
    OrdersCompanion Function({
      Value<String> id,
      Value<String> orderCode,
      Value<String> status,
      Value<String> orderType,
      Value<String> mealType,
      Value<double> total,
      Value<int> groupCount,
      Value<String?> description,
      Value<String> orderedById,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
      Value<int> rowid,
    });

final class $$OrdersTableReferences
    extends BaseReferences<_$AppDatabase, $OrdersTable, Order> {
  $$OrdersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $StaffTable _orderedByIdTable(_$AppDatabase db) => db.staff
      .createAlias($_aliasNameGenerator(db.orders.orderedById, db.staff.id));

  $$StaffTableProcessedTableManager get orderedById {
    final $_column = $_itemColumn<String>('ordered_by_id')!;

    final manager = $$StaffTableTableManager(
      $_db,
      $_db.staff,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderedByIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$OrderItemsTable, List<OrderItem>>
  _orderItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.orderItems,
    aliasName: $_aliasNameGenerator(db.orders.id, db.orderItems.orderId),
  );

  $$OrderItemsTableProcessedTableManager get orderItemsRefs {
    final manager = $$OrderItemsTableTableManager(
      $_db,
      $_db.orderItems,
    ).filter((f) => f.orderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_orderItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OrdersTableFilterComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
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

  $$StaffTableFilterComposer get orderedById {
    final $$StaffTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderedById,
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

  Expression<bool> orderItemsRefs(
    Expression<bool> Function($$OrderItemsTableFilterComposer f) f,
  ) {
    final $$OrderItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItems,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableFilterComposer(
            $db: $db,
            $table: $db.orderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
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

  $$StaffTableOrderingComposer get orderedById {
    final $$StaffTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderedById,
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

class $$OrdersTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

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

  $$StaffTableAnnotationComposer get orderedById {
    final $$StaffTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderedById,
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

  Expression<T> orderItemsRefs<T extends Object>(
    Expression<T> Function($$OrderItemsTableAnnotationComposer a) f,
  ) {
    final $$OrderItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItems,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.orderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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
          (Order, $$OrdersTableReferences),
          Order,
          PrefetchHooks Function({bool orderedById, bool orderItemsRefs})
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
                Value<String> id = const Value.absent(),
                Value<String> orderCode = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> orderType = const Value.absent(),
                Value<String> mealType = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<int> groupCount = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> orderedById = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrdersCompanion(
                id: id,
                orderCode: orderCode,
                status: status,
                orderType: orderType,
                mealType: mealType,
                total: total,
                groupCount: groupCount,
                description: description,
                orderedById: orderedById,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String orderCode,
                required String status,
                required String orderType,
                required String mealType,
                required double total,
                required int groupCount,
                Value<String?> description = const Value.absent(),
                required String orderedById,
                required String createdAt,
                required String updatedAt,
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrdersCompanion.insert(
                id: id,
                orderCode: orderCode,
                status: status,
                orderType: orderType,
                mealType: mealType,
                total: total,
                groupCount: groupCount,
                description: description,
                orderedById: orderedById,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$OrdersTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({orderedById = false, orderItemsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (orderItemsRefs) db.orderItems],
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
                        if (orderedById) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.orderedById,
                                    referencedTable: $$OrdersTableReferences
                                        ._orderedByIdTable(db),
                                    referencedColumn: $$OrdersTableReferences
                                        ._orderedByIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (orderItemsRefs)
                        await $_getPrefetchedData<
                          Order,
                          $OrdersTable,
                          OrderItem
                        >(
                          currentTable: table,
                          referencedTable: $$OrdersTableReferences
                              ._orderItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrdersTableReferences(
                                db,
                                table,
                                p0,
                              ).orderItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.orderId == item.id,
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
      (Order, $$OrdersTableReferences),
      Order,
      PrefetchHooks Function({bool orderedById, bool orderItemsRefs})
    >;
typedef $$OrderItemsTableCreateCompanionBuilder =
    OrderItemsCompanion Function({
      required String id,
      required double price,
      required int qty,
      required String mealId,
      required String orderId,
      required String createdAt,
      required String updatedAt,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
      Value<int> rowid,
    });
typedef $$OrderItemsTableUpdateCompanionBuilder =
    OrderItemsCompanion Function({
      Value<String> id,
      Value<double> price,
      Value<int> qty,
      Value<String> mealId,
      Value<String> orderId,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
      Value<int> rowid,
    });

final class $$OrderItemsTableReferences
    extends BaseReferences<_$AppDatabase, $OrderItemsTable, OrderItem> {
  $$OrderItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MealsTable _mealIdTable(_$AppDatabase db) => db.meals.createAlias(
    $_aliasNameGenerator(db.orderItems.mealId, db.meals.id),
  );

  $$MealsTableProcessedTableManager get mealId {
    final $_column = $_itemColumn<String>('meal_id')!;

    final manager = $$MealsTableTableManager(
      $_db,
      $_db.meals,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mealIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $OrdersTable _orderIdTable(_$AppDatabase db) => db.orders.createAlias(
    $_aliasNameGenerator(db.orderItems.orderId, db.orders.id),
  );

  $$OrdersTableProcessedTableManager get orderId {
    final $_column = $_itemColumn<String>('order_id')!;

    final manager = $$OrdersTableTableManager(
      $_db,
      $_db.orders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$OrderItemsTableFilterComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qty => $composableBuilder(
    column: $table.qty,
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

  $$MealsTableFilterComposer get mealId {
    final $$MealsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealId,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealsTableFilterComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OrdersTableFilterComposer get orderId {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableFilterComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qty => $composableBuilder(
    column: $table.qty,
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

  $$MealsTableOrderingComposer get mealId {
    final $$MealsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealId,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealsTableOrderingComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OrdersTableOrderingComposer get orderId {
    final $$OrdersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableOrderingComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<int> get qty =>
      $composableBuilder(column: $table.qty, builder: (column) => column);

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

  $$MealsTableAnnotationComposer get mealId {
    final $$MealsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealId,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealsTableAnnotationComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OrdersTableAnnotationComposer get orderId {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrderItemsTable,
          OrderItem,
          $$OrderItemsTableFilterComposer,
          $$OrderItemsTableOrderingComposer,
          $$OrderItemsTableAnnotationComposer,
          $$OrderItemsTableCreateCompanionBuilder,
          $$OrderItemsTableUpdateCompanionBuilder,
          (OrderItem, $$OrderItemsTableReferences),
          OrderItem,
          PrefetchHooks Function({bool mealId, bool orderId})
        > {
  $$OrderItemsTableTableManager(_$AppDatabase db, $OrderItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<int> qty = const Value.absent(),
                Value<String> mealId = const Value.absent(),
                Value<String> orderId = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrderItemsCompanion(
                id: id,
                price: price,
                qty: qty,
                mealId: mealId,
                orderId: orderId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required double price,
                required int qty,
                required String mealId,
                required String orderId,
                required String createdAt,
                required String updatedAt,
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrderItemsCompanion.insert(
                id: id,
                price: price,
                qty: qty,
                mealId: mealId,
                orderId: orderId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OrderItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({mealId = false, orderId = false}) {
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
                    if (mealId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.mealId,
                                referencedTable: $$OrderItemsTableReferences
                                    ._mealIdTable(db),
                                referencedColumn: $$OrderItemsTableReferences
                                    ._mealIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (orderId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.orderId,
                                referencedTable: $$OrderItemsTableReferences
                                    ._orderIdTable(db),
                                referencedColumn: $$OrderItemsTableReferences
                                    ._orderIdTable(db)
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

typedef $$OrderItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrderItemsTable,
      OrderItem,
      $$OrderItemsTableFilterComposer,
      $$OrderItemsTableOrderingComposer,
      $$OrderItemsTableAnnotationComposer,
      $$OrderItemsTableCreateCompanionBuilder,
      $$OrderItemsTableUpdateCompanionBuilder,
      (OrderItem, $$OrderItemsTableReferences),
      OrderItem,
      PrefetchHooks Function({bool mealId, bool orderId})
    >;
typedef $$OverchargesTableCreateCompanionBuilder =
    OverchargesCompanion Function({
      required String id,
      required String mealType,
      required String orderCode,
      required double price,
      required String staffId,
      required String mealId,
      required String createdAt,
      required String updatedAt,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
      Value<int> rowid,
    });
typedef $$OverchargesTableUpdateCompanionBuilder =
    OverchargesCompanion Function({
      Value<String> id,
      Value<String> mealType,
      Value<String> orderCode,
      Value<double> price,
      Value<String> staffId,
      Value<String> mealId,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
      Value<int> rowid,
    });

final class $$OverchargesTableReferences
    extends BaseReferences<_$AppDatabase, $OverchargesTable, Overcharge> {
  $$OverchargesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $StaffTable _staffIdTable(_$AppDatabase db) => db.staff.createAlias(
    $_aliasNameGenerator(db.overcharges.staffId, db.staff.id),
  );

  $$StaffTableProcessedTableManager get staffId {
    final $_column = $_itemColumn<String>('staff_id')!;

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

  static $MealsTable _mealIdTable(_$AppDatabase db) => db.meals.createAlias(
    $_aliasNameGenerator(db.overcharges.mealId, db.meals.id),
  );

  $$MealsTableProcessedTableManager get mealId {
    final $_column = $_itemColumn<String>('meal_id')!;

    final manager = $$MealsTableTableManager(
      $_db,
      $_db.meals,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mealIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$OverchargesTableFilterComposer
    extends Composer<_$AppDatabase, $OverchargesTable> {
  $$OverchargesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orderCode => $composableBuilder(
    column: $table.orderCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
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

  $$MealsTableFilterComposer get mealId {
    final $$MealsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealId,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealsTableFilterComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OverchargesTableOrderingComposer
    extends Composer<_$AppDatabase, $OverchargesTable> {
  $$OverchargesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orderCode => $composableBuilder(
    column: $table.orderCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
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

  $$MealsTableOrderingComposer get mealId {
    final $$MealsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealId,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealsTableOrderingComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OverchargesTableAnnotationComposer
    extends Composer<_$AppDatabase, $OverchargesTable> {
  $$OverchargesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get mealType =>
      $composableBuilder(column: $table.mealType, builder: (column) => column);

  GeneratedColumn<String> get orderCode =>
      $composableBuilder(column: $table.orderCode, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

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

  $$MealsTableAnnotationComposer get mealId {
    final $$MealsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealId,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealsTableAnnotationComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OverchargesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OverchargesTable,
          Overcharge,
          $$OverchargesTableFilterComposer,
          $$OverchargesTableOrderingComposer,
          $$OverchargesTableAnnotationComposer,
          $$OverchargesTableCreateCompanionBuilder,
          $$OverchargesTableUpdateCompanionBuilder,
          (Overcharge, $$OverchargesTableReferences),
          Overcharge,
          PrefetchHooks Function({bool staffId, bool mealId})
        > {
  $$OverchargesTableTableManager(_$AppDatabase db, $OverchargesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OverchargesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OverchargesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OverchargesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> mealType = const Value.absent(),
                Value<String> orderCode = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<String> staffId = const Value.absent(),
                Value<String> mealId = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OverchargesCompanion(
                id: id,
                mealType: mealType,
                orderCode: orderCode,
                price: price,
                staffId: staffId,
                mealId: mealId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String mealType,
                required String orderCode,
                required double price,
                required String staffId,
                required String mealId,
                required String createdAt,
                required String updatedAt,
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OverchargesCompanion.insert(
                id: id,
                mealType: mealType,
                orderCode: orderCode,
                price: price,
                staffId: staffId,
                mealId: mealId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OverchargesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({staffId = false, mealId = false}) {
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
                                referencedTable: $$OverchargesTableReferences
                                    ._staffIdTable(db),
                                referencedColumn: $$OverchargesTableReferences
                                    ._staffIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (mealId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.mealId,
                                referencedTable: $$OverchargesTableReferences
                                    ._mealIdTable(db),
                                referencedColumn: $$OverchargesTableReferences
                                    ._mealIdTable(db)
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

typedef $$OverchargesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OverchargesTable,
      Overcharge,
      $$OverchargesTableFilterComposer,
      $$OverchargesTableOrderingComposer,
      $$OverchargesTableAnnotationComposer,
      $$OverchargesTableCreateCompanionBuilder,
      $$OverchargesTableUpdateCompanionBuilder,
      (Overcharge, $$OverchargesTableReferences),
      Overcharge,
      PrefetchHooks Function({bool staffId, bool mealId})
    >;
typedef $$PosDevicesTableCreateCompanionBuilder =
    PosDevicesCompanion Function({
      required String id,
      required String name,
      required String serialNumber,
      Value<String?> model,
      required String status,
      Value<String?> macAddress,
      required String createdAt,
      required String updatedAt,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
      Value<int> rowid,
    });
typedef $$PosDevicesTableUpdateCompanionBuilder =
    PosDevicesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> serialNumber,
      Value<String?> model,
      Value<String> status,
      Value<String?> macAddress,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
      Value<int> rowid,
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
  ColumnFilters<String> get id => $composableBuilder(
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
  ColumnOrderings<String> get id => $composableBuilder(
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
  GeneratedColumn<String> get id =>
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
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> serialNumber = const Value.absent(),
                Value<String?> model = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> macAddress = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PosDevicesCompanion(
                id: id,
                name: name,
                serialNumber: serialNumber,
                model: model,
                status: status,
                macAddress: macAddress,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String serialNumber,
                Value<String?> model = const Value.absent(),
                required String status,
                Value<String?> macAddress = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PosDevicesCompanion.insert(
                id: id,
                name: name,
                serialNumber: serialNumber,
                model: model,
                status: status,
                macAddress: macAddress,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
                rowid: rowid,
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
      required String id,
      required String type,
      required String message,
      Value<String?> actorType,
      Value<String?> actorId,
      Value<String?> actorName,
      Value<String?> sourceTable,
      Value<String?> recordId,
      Value<String?> metadata,
      required String createdAt,
      Value<int> rowid,
    });
typedef $$ActivityLogsTableUpdateCompanionBuilder =
    ActivityLogsCompanion Function({
      Value<String> id,
      Value<String> type,
      Value<String> message,
      Value<String?> actorType,
      Value<String?> actorId,
      Value<String?> actorName,
      Value<String?> sourceTable,
      Value<String?> recordId,
      Value<String?> metadata,
      Value<String> createdAt,
      Value<int> rowid,
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
  ColumnFilters<String> get id => $composableBuilder(
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

  ColumnFilters<String> get actorId => $composableBuilder(
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
  ColumnOrderings<String> get id => $composableBuilder(
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

  ColumnOrderings<String> get actorId => $composableBuilder(
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
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<String> get actorType =>
      $composableBuilder(column: $table.actorType, builder: (column) => column);

  GeneratedColumn<String> get actorId =>
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
                Value<String> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> message = const Value.absent(),
                Value<String?> actorType = const Value.absent(),
                Value<String?> actorId = const Value.absent(),
                Value<String?> actorName = const Value.absent(),
                Value<String?> sourceTable = const Value.absent(),
                Value<String?> recordId = const Value.absent(),
                Value<String?> metadata = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
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
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String type,
                required String message,
                Value<String?> actorType = const Value.absent(),
                Value<String?> actorId = const Value.absent(),
                Value<String?> actorName = const Value.absent(),
                Value<String?> sourceTable = const Value.absent(),
                Value<String?> recordId = const Value.absent(),
                Value<String?> metadata = const Value.absent(),
                required String createdAt,
                Value<int> rowid = const Value.absent(),
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
                rowid: rowid,
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
      required String id,
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
      Value<int> rowid,
    });
typedef $$GroupOrdersTableUpdateCompanionBuilder =
    GroupOrdersCompanion Function({
      Value<String> id,
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
      Value<int> rowid,
    });

final class $$GroupOrdersTableReferences
    extends BaseReferences<_$AppDatabase, $GroupOrdersTable, GroupOrder> {
  $$GroupOrdersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$GroupOrderItemsTable, List<GroupOrderItem>>
  _groupOrderItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.groupOrderItems,
    aliasName: $_aliasNameGenerator(
      db.groupOrders.id,
      db.groupOrderItems.groupOrderId,
    ),
  );

  $$GroupOrderItemsTableProcessedTableManager get groupOrderItemsRefs {
    final manager = $$GroupOrderItemsTableTableManager(
      $_db,
      $_db.groupOrderItems,
    ).filter((f) => f.groupOrderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _groupOrderItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GroupOrdersTableFilterComposer
    extends Composer<_$AppDatabase, $GroupOrdersTable> {
  $$GroupOrdersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
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

  Expression<bool> groupOrderItemsRefs(
    Expression<bool> Function($$GroupOrderItemsTableFilterComposer f) f,
  ) {
    final $$GroupOrderItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupOrderItems,
      getReferencedColumn: (t) => t.groupOrderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupOrderItemsTableFilterComposer(
            $db: $db,
            $table: $db.groupOrderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
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
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

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

  Expression<T> groupOrderItemsRefs<T extends Object>(
    Expression<T> Function($$GroupOrderItemsTableAnnotationComposer a) f,
  ) {
    final $$GroupOrderItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupOrderItems,
      getReferencedColumn: (t) => t.groupOrderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupOrderItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.groupOrderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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
          (GroupOrder, $$GroupOrdersTableReferences),
          GroupOrder,
          PrefetchHooks Function({bool groupOrderItemsRefs})
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
                Value<String> id = const Value.absent(),
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
                Value<int> rowid = const Value.absent(),
              }) => GroupOrdersCompanion(
                id: id,
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
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
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
                Value<int> rowid = const Value.absent(),
              }) => GroupOrdersCompanion.insert(
                id: id,
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
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GroupOrdersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({groupOrderItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (groupOrderItemsRefs) db.groupOrderItems,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (groupOrderItemsRefs)
                    await $_getPrefetchedData<
                      GroupOrder,
                      $GroupOrdersTable,
                      GroupOrderItem
                    >(
                      currentTable: table,
                      referencedTable: $$GroupOrdersTableReferences
                          ._groupOrderItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$GroupOrdersTableReferences(
                            db,
                            table,
                            p0,
                          ).groupOrderItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.groupOrderId == item.id,
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
      (GroupOrder, $$GroupOrdersTableReferences),
      GroupOrder,
      PrefetchHooks Function({bool groupOrderItemsRefs})
    >;
typedef $$GroupOrderItemsTableCreateCompanionBuilder =
    GroupOrderItemsCompanion Function({
      required String id,
      required double price,
      required int qty,
      required String mealId,
      required String groupOrderId,
      required String createdAt,
      required String updatedAt,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
      Value<int> rowid,
    });
typedef $$GroupOrderItemsTableUpdateCompanionBuilder =
    GroupOrderItemsCompanion Function({
      Value<String> id,
      Value<double> price,
      Value<int> qty,
      Value<String> mealId,
      Value<String> groupOrderId,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> syncStatus,
      Value<String?> syncUpdatedAt,
      Value<int> rowid,
    });

final class $$GroupOrderItemsTableReferences
    extends
        BaseReferences<_$AppDatabase, $GroupOrderItemsTable, GroupOrderItem> {
  $$GroupOrderItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MealsTable _mealIdTable(_$AppDatabase db) => db.meals.createAlias(
    $_aliasNameGenerator(db.groupOrderItems.mealId, db.meals.id),
  );

  $$MealsTableProcessedTableManager get mealId {
    final $_column = $_itemColumn<String>('meal_id')!;

    final manager = $$MealsTableTableManager(
      $_db,
      $_db.meals,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mealIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $GroupOrdersTable _groupOrderIdTable(_$AppDatabase db) =>
      db.groupOrders.createAlias(
        $_aliasNameGenerator(
          db.groupOrderItems.groupOrderId,
          db.groupOrders.id,
        ),
      );

  $$GroupOrdersTableProcessedTableManager get groupOrderId {
    final $_column = $_itemColumn<String>('group_order_id')!;

    final manager = $$GroupOrdersTableTableManager(
      $_db,
      $_db.groupOrders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupOrderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GroupOrderItemsTableFilterComposer
    extends Composer<_$AppDatabase, $GroupOrderItemsTable> {
  $$GroupOrderItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qty => $composableBuilder(
    column: $table.qty,
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

  $$MealsTableFilterComposer get mealId {
    final $$MealsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealId,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealsTableFilterComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GroupOrdersTableFilterComposer get groupOrderId {
    final $$GroupOrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupOrderId,
      referencedTable: $db.groupOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupOrdersTableFilterComposer(
            $db: $db,
            $table: $db.groupOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupOrderItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $GroupOrderItemsTable> {
  $$GroupOrderItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qty => $composableBuilder(
    column: $table.qty,
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

  $$MealsTableOrderingComposer get mealId {
    final $$MealsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealId,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealsTableOrderingComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GroupOrdersTableOrderingComposer get groupOrderId {
    final $$GroupOrdersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupOrderId,
      referencedTable: $db.groupOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupOrdersTableOrderingComposer(
            $db: $db,
            $table: $db.groupOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupOrderItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroupOrderItemsTable> {
  $$GroupOrderItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<int> get qty =>
      $composableBuilder(column: $table.qty, builder: (column) => column);

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

  $$MealsTableAnnotationComposer get mealId {
    final $$MealsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealId,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealsTableAnnotationComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GroupOrdersTableAnnotationComposer get groupOrderId {
    final $$GroupOrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupOrderId,
      referencedTable: $db.groupOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupOrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.groupOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupOrderItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GroupOrderItemsTable,
          GroupOrderItem,
          $$GroupOrderItemsTableFilterComposer,
          $$GroupOrderItemsTableOrderingComposer,
          $$GroupOrderItemsTableAnnotationComposer,
          $$GroupOrderItemsTableCreateCompanionBuilder,
          $$GroupOrderItemsTableUpdateCompanionBuilder,
          (GroupOrderItem, $$GroupOrderItemsTableReferences),
          GroupOrderItem,
          PrefetchHooks Function({bool mealId, bool groupOrderId})
        > {
  $$GroupOrderItemsTableTableManager(
    _$AppDatabase db,
    $GroupOrderItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupOrderItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupOrderItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupOrderItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<int> qty = const Value.absent(),
                Value<String> mealId = const Value.absent(),
                Value<String> groupOrderId = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GroupOrderItemsCompanion(
                id: id,
                price: price,
                qty: qty,
                mealId: mealId,
                groupOrderId: groupOrderId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required double price,
                required int qty,
                required String mealId,
                required String groupOrderId,
                required String createdAt,
                required String updatedAt,
                Value<int> syncStatus = const Value.absent(),
                Value<String?> syncUpdatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GroupOrderItemsCompanion.insert(
                id: id,
                price: price,
                qty: qty,
                mealId: mealId,
                groupOrderId: groupOrderId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                syncUpdatedAt: syncUpdatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GroupOrderItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({mealId = false, groupOrderId = false}) {
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
                    if (mealId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.mealId,
                                referencedTable:
                                    $$GroupOrderItemsTableReferences
                                        ._mealIdTable(db),
                                referencedColumn:
                                    $$GroupOrderItemsTableReferences
                                        ._mealIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (groupOrderId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.groupOrderId,
                                referencedTable:
                                    $$GroupOrderItemsTableReferences
                                        ._groupOrderIdTable(db),
                                referencedColumn:
                                    $$GroupOrderItemsTableReferences
                                        ._groupOrderIdTable(db)
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

typedef $$GroupOrderItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GroupOrderItemsTable,
      GroupOrderItem,
      $$GroupOrderItemsTableFilterComposer,
      $$GroupOrderItemsTableOrderingComposer,
      $$GroupOrderItemsTableAnnotationComposer,
      $$GroupOrderItemsTableCreateCompanionBuilder,
      $$GroupOrderItemsTableUpdateCompanionBuilder,
      (GroupOrderItem, $$GroupOrderItemsTableReferences),
      GroupOrderItem,
      PrefetchHooks Function({bool mealId, bool groupOrderId})
    >;
typedef $$BioDataEntriesTableCreateCompanionBuilder =
    BioDataEntriesCompanion Function({
      Value<int> id,
      required String staffId,
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
      Value<String> staffId,
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

  $$StaffTableProcessedTableManager get staffId {
    final $_column = $_itemColumn<String>('staff_id')!;

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
          PrefetchHooks Function({bool staffId})
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
                Value<String> staffId = const Value.absent(),
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
                required String staffId,
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
          prefetchHooksCallback: ({staffId = false}) {
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
                                referencedTable: $$BioDataEntriesTableReferences
                                    ._staffIdTable(db),
                                referencedColumn:
                                    $$BioDataEntriesTableReferences
                                        ._staffIdTable(db)
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
      PrefetchHooks Function({bool staffId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SitesTableTableManager get sites =>
      $$SitesTableTableManager(_db, _db.sites);
  $$KitchensTableTableManager get kitchens =>
      $$KitchensTableTableManager(_db, _db.kitchens);
  $$MenuTypesTableTableManager get menuTypes =>
      $$MenuTypesTableTableManager(_db, _db.menuTypes);
  $$MealsTableTableManager get meals =>
      $$MealsTableTableManager(_db, _db.meals);
  $$MealKitchensTableTableManager get mealKitchens =>
      $$MealKitchensTableTableManager(_db, _db.mealKitchens);
  $$StaffTableTableManager get staff =>
      $$StaffTableTableManager(_db, _db.staff);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$UserKitchensTableTableManager get userKitchens =>
      $$UserKitchensTableTableManager(_db, _db.userKitchens);
  $$OrdersTableTableManager get orders =>
      $$OrdersTableTableManager(_db, _db.orders);
  $$OrderItemsTableTableManager get orderItems =>
      $$OrderItemsTableTableManager(_db, _db.orderItems);
  $$OverchargesTableTableManager get overcharges =>
      $$OverchargesTableTableManager(_db, _db.overcharges);
  $$PosDevicesTableTableManager get posDevices =>
      $$PosDevicesTableTableManager(_db, _db.posDevices);
  $$ActivityLogsTableTableManager get activityLogs =>
      $$ActivityLogsTableTableManager(_db, _db.activityLogs);
  $$GroupOrdersTableTableManager get groupOrders =>
      $$GroupOrdersTableTableManager(_db, _db.groupOrders);
  $$GroupOrderItemsTableTableManager get groupOrderItems =>
      $$GroupOrderItemsTableTableManager(_db, _db.groupOrderItems);
  $$BioDataEntriesTableTableManager get bioDataEntries =>
      $$BioDataEntriesTableTableManager(_db, _db.bioDataEntries);
}
