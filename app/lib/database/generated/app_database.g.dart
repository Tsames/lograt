// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../app_database.dart';

// ignore_for_file: type=lint
class $WorkoutTemplatesTableTable extends WorkoutTemplatesTable
    with TableInfo<$WorkoutTemplatesTableTable, WorkoutTemplateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutTemplatesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => uuid.v7(),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  @override
  List<GeneratedColumn> get $columns => [id, title, description];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutTemplateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutTemplateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutTemplateRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
    );
  }

  @override
  $WorkoutTemplatesTableTable createAlias(String alias) {
    return $WorkoutTemplatesTableTable(attachedDatabase, alias);
  }
}

class WorkoutTemplateRow extends DataClass
    implements Insertable<WorkoutTemplateRow> {
  final String id;
  final String? title;
  final String? description;
  const WorkoutTemplateRow({required this.id, this.title, this.description});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  WorkoutTemplatesTableCompanion toCompanion(bool nullToAbsent) {
    return WorkoutTemplatesTableCompanion(
      id: Value(id),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory WorkoutTemplateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutTemplateRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String?>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String?>(title),
      'description': serializer.toJson<String?>(description),
    };
  }

  WorkoutTemplateRow copyWith({
    String? id,
    Value<String?> title = const Value.absent(),
    Value<String?> description = const Value.absent(),
  }) => WorkoutTemplateRow(
    id: id ?? this.id,
    title: title.present ? title.value : this.title,
    description: description.present ? description.value : this.description,
  );
  WorkoutTemplateRow copyWithCompanion(WorkoutTemplatesTableCompanion data) {
    return WorkoutTemplateRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutTemplateRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutTemplateRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description);
}

class WorkoutTemplatesTableCompanion
    extends UpdateCompanion<WorkoutTemplateRow> {
  final Value<String> id;
  final Value<String?> title;
  final Value<String?> description;
  final Value<int> rowid;
  const WorkoutTemplatesTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutTemplatesTableCompanion.insert({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<WorkoutTemplateRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutTemplatesTableCompanion copyWith({
    Value<String>? id,
    Value<String?>? title,
    Value<String?>? description,
    Value<int>? rowid,
  }) {
    return WorkoutTemplatesTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutTemplatesTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutsTableTable extends WorkoutsTable
    with TableInfo<$WorkoutsTableTable, WorkoutRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => uuid.v7(),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _templateIdMeta = const VerificationMeta(
    'templateId',
  );
  @override
  late final GeneratedColumn<String> templateId = GeneratedColumn<String>(
    'template_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_templates (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, date, title, templateId, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workouts';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('template_id')) {
      context.handle(
        _templateIdMeta,
        templateId.isAcceptableOrUnknown(data['template_id']!, _templateIdMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      templateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_id'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $WorkoutsTableTable createAlias(String alias) {
    return $WorkoutsTableTable(attachedDatabase, alias);
  }
}

class WorkoutRow extends DataClass implements Insertable<WorkoutRow> {
  final String id;
  final DateTime date;
  final String? title;
  final String? templateId;
  final String? notes;
  const WorkoutRow({
    required this.id,
    required this.date,
    this.title,
    this.templateId,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || templateId != null) {
      map['template_id'] = Variable<String>(templateId);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  WorkoutsTableCompanion toCompanion(bool nullToAbsent) {
    return WorkoutsTableCompanion(
      id: Value(id),
      date: Value(date),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      templateId: templateId == null && nullToAbsent
          ? const Value.absent()
          : Value(templateId),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory WorkoutRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutRow(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      title: serializer.fromJson<String?>(json['title']),
      templateId: serializer.fromJson<String?>(json['templateId']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<DateTime>(date),
      'title': serializer.toJson<String?>(title),
      'templateId': serializer.toJson<String?>(templateId),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  WorkoutRow copyWith({
    String? id,
    DateTime? date,
    Value<String?> title = const Value.absent(),
    Value<String?> templateId = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => WorkoutRow(
    id: id ?? this.id,
    date: date ?? this.date,
    title: title.present ? title.value : this.title,
    templateId: templateId.present ? templateId.value : this.templateId,
    notes: notes.present ? notes.value : this.notes,
  );
  WorkoutRow copyWithCompanion(WorkoutsTableCompanion data) {
    return WorkoutRow(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      title: data.title.present ? data.title.value : this.title,
      templateId: data.templateId.present
          ? data.templateId.value
          : this.templateId,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutRow(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('title: $title, ')
          ..write('templateId: $templateId, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, title, templateId, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutRow &&
          other.id == this.id &&
          other.date == this.date &&
          other.title == this.title &&
          other.templateId == this.templateId &&
          other.notes == this.notes);
}

class WorkoutsTableCompanion extends UpdateCompanion<WorkoutRow> {
  final Value<String> id;
  final Value<DateTime> date;
  final Value<String?> title;
  final Value<String?> templateId;
  final Value<String?> notes;
  final Value<int> rowid;
  const WorkoutsTableCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.title = const Value.absent(),
    this.templateId = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutsTableCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    this.title = const Value.absent(),
    this.templateId = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : date = Value(date);
  static Insertable<WorkoutRow> custom({
    Expression<String>? id,
    Expression<DateTime>? date,
    Expression<String>? title,
    Expression<String>? templateId,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (title != null) 'title': title,
      if (templateId != null) 'template_id': templateId,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutsTableCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? date,
    Value<String?>? title,
    Value<String?>? templateId,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return WorkoutsTableCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      title: title ?? this.title,
      templateId: templateId ?? this.templateId,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<String>(templateId.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutsTableCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('title: $title, ')
          ..write('templateId: $templateId, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExercisesTableTable extends ExercisesTable
    with TableInfo<$ExercisesTableTable, ExerciseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExercisesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => uuid.v7(),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
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
  @override
  List<GeneratedColumn> get $columns => [id, name, description];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExerciseRow> instance, {
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
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExerciseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
    );
  }

  @override
  $ExercisesTableTable createAlias(String alias) {
    return $ExercisesTableTable(attachedDatabase, alias);
  }
}

class ExerciseRow extends DataClass implements Insertable<ExerciseRow> {
  final String id;
  final String name;
  final String? description;
  const ExerciseRow({required this.id, required this.name, this.description});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  ExercisesTableCompanion toCompanion(bool nullToAbsent) {
    return ExercisesTableCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory ExerciseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
    };
  }

  ExerciseRow copyWith({
    String? id,
    String? name,
    Value<String?> description = const Value.absent(),
  }) => ExerciseRow(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
  );
  ExerciseRow copyWithCompanion(ExercisesTableCompanion data) {
    return ExerciseRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description);
}

class ExercisesTableCompanion extends UpdateCompanion<ExerciseRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<int> rowid;
  const ExercisesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExercisesTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<ExerciseRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExercisesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<int>? rowid,
  }) {
    return ExercisesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
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
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutTemplateSetsTableTable extends WorkoutTemplateSetsTable
    with TableInfo<$WorkoutTemplateSetsTableTable, WorkoutTemplateSetRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutTemplateSetsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => uuid.v7(),
  );
  static const VerificationMeta _templateIdMeta = const VerificationMeta(
    'templateId',
  );
  @override
  late final GeneratedColumn<String> templateId = GeneratedColumn<String>(
    'template_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_templates (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _exerciseOrderMeta = const VerificationMeta(
    'exerciseOrder',
  );
  @override
  late final GeneratedColumn<int> exerciseOrder = GeneratedColumn<int>(
    'exercise_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseTypeIdMeta = const VerificationMeta(
    'exerciseTypeId',
  );
  @override
  late final GeneratedColumn<String> exerciseTypeId = GeneratedColumn<String>(
    'exercise_type_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercises (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _setOrderMeta = const VerificationMeta(
    'setOrder',
  );
  @override
  late final GeneratedColumn<int> setOrder = GeneratedColumn<int>(
    'set_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SetType?, String> setType =
      GeneratedColumn<String>(
        'set_type',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<SetType?>(
        $WorkoutTemplateSetsTableTable.$convertersetType,
      );
  @override
  late final GeneratedColumnWithTypeConverter<Units?, String> units =
      GeneratedColumn<String>(
        'units',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Units?>($WorkoutTemplateSetsTableTable.$converterunits);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    templateId,
    exerciseOrder,
    exerciseTypeId,
    setOrder,
    setType,
    units,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_template_sets';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutTemplateSetRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('template_id')) {
      context.handle(
        _templateIdMeta,
        templateId.isAcceptableOrUnknown(data['template_id']!, _templateIdMeta),
      );
    } else if (isInserting) {
      context.missing(_templateIdMeta);
    }
    if (data.containsKey('exercise_order')) {
      context.handle(
        _exerciseOrderMeta,
        exerciseOrder.isAcceptableOrUnknown(
          data['exercise_order']!,
          _exerciseOrderMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseOrderMeta);
    }
    if (data.containsKey('exercise_type_id')) {
      context.handle(
        _exerciseTypeIdMeta,
        exerciseTypeId.isAcceptableOrUnknown(
          data['exercise_type_id']!,
          _exerciseTypeIdMeta,
        ),
      );
    }
    if (data.containsKey('set_order')) {
      context.handle(
        _setOrderMeta,
        setOrder.isAcceptableOrUnknown(data['set_order']!, _setOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_setOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutTemplateSetRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutTemplateSetRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      templateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_id'],
      )!,
      exerciseOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercise_order'],
      )!,
      exerciseTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_type_id'],
      ),
      setOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}set_order'],
      )!,
      setType: $WorkoutTemplateSetsTableTable.$convertersetType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}set_type'],
        ),
      ),
      units: $WorkoutTemplateSetsTableTable.$converterunits.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}units'],
        ),
      ),
    );
  }

  @override
  $WorkoutTemplateSetsTableTable createAlias(String alias) {
    return $WorkoutTemplateSetsTableTable(attachedDatabase, alias);
  }

  static TypeConverter<SetType?, String?> $convertersetType =
      const SetTypeConverter();
  static TypeConverter<Units?, String?> $converterunits =
      const UnitsConverter();
}

class WorkoutTemplateSetRow extends DataClass
    implements Insertable<WorkoutTemplateSetRow> {
  final String id;
  final String templateId;
  final int exerciseOrder;
  final String? exerciseTypeId;
  final int setOrder;
  final SetType? setType;
  final Units? units;
  const WorkoutTemplateSetRow({
    required this.id,
    required this.templateId,
    required this.exerciseOrder,
    this.exerciseTypeId,
    required this.setOrder,
    this.setType,
    this.units,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['template_id'] = Variable<String>(templateId);
    map['exercise_order'] = Variable<int>(exerciseOrder);
    if (!nullToAbsent || exerciseTypeId != null) {
      map['exercise_type_id'] = Variable<String>(exerciseTypeId);
    }
    map['set_order'] = Variable<int>(setOrder);
    if (!nullToAbsent || setType != null) {
      map['set_type'] = Variable<String>(
        $WorkoutTemplateSetsTableTable.$convertersetType.toSql(setType),
      );
    }
    if (!nullToAbsent || units != null) {
      map['units'] = Variable<String>(
        $WorkoutTemplateSetsTableTable.$converterunits.toSql(units),
      );
    }
    return map;
  }

  WorkoutTemplateSetsTableCompanion toCompanion(bool nullToAbsent) {
    return WorkoutTemplateSetsTableCompanion(
      id: Value(id),
      templateId: Value(templateId),
      exerciseOrder: Value(exerciseOrder),
      exerciseTypeId: exerciseTypeId == null && nullToAbsent
          ? const Value.absent()
          : Value(exerciseTypeId),
      setOrder: Value(setOrder),
      setType: setType == null && nullToAbsent
          ? const Value.absent()
          : Value(setType),
      units: units == null && nullToAbsent
          ? const Value.absent()
          : Value(units),
    );
  }

  factory WorkoutTemplateSetRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutTemplateSetRow(
      id: serializer.fromJson<String>(json['id']),
      templateId: serializer.fromJson<String>(json['templateId']),
      exerciseOrder: serializer.fromJson<int>(json['exerciseOrder']),
      exerciseTypeId: serializer.fromJson<String?>(json['exerciseTypeId']),
      setOrder: serializer.fromJson<int>(json['setOrder']),
      setType: serializer.fromJson<SetType?>(json['setType']),
      units: serializer.fromJson<Units?>(json['units']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'templateId': serializer.toJson<String>(templateId),
      'exerciseOrder': serializer.toJson<int>(exerciseOrder),
      'exerciseTypeId': serializer.toJson<String?>(exerciseTypeId),
      'setOrder': serializer.toJson<int>(setOrder),
      'setType': serializer.toJson<SetType?>(setType),
      'units': serializer.toJson<Units?>(units),
    };
  }

  WorkoutTemplateSetRow copyWith({
    String? id,
    String? templateId,
    int? exerciseOrder,
    Value<String?> exerciseTypeId = const Value.absent(),
    int? setOrder,
    Value<SetType?> setType = const Value.absent(),
    Value<Units?> units = const Value.absent(),
  }) => WorkoutTemplateSetRow(
    id: id ?? this.id,
    templateId: templateId ?? this.templateId,
    exerciseOrder: exerciseOrder ?? this.exerciseOrder,
    exerciseTypeId: exerciseTypeId.present
        ? exerciseTypeId.value
        : this.exerciseTypeId,
    setOrder: setOrder ?? this.setOrder,
    setType: setType.present ? setType.value : this.setType,
    units: units.present ? units.value : this.units,
  );
  WorkoutTemplateSetRow copyWithCompanion(
    WorkoutTemplateSetsTableCompanion data,
  ) {
    return WorkoutTemplateSetRow(
      id: data.id.present ? data.id.value : this.id,
      templateId: data.templateId.present
          ? data.templateId.value
          : this.templateId,
      exerciseOrder: data.exerciseOrder.present
          ? data.exerciseOrder.value
          : this.exerciseOrder,
      exerciseTypeId: data.exerciseTypeId.present
          ? data.exerciseTypeId.value
          : this.exerciseTypeId,
      setOrder: data.setOrder.present ? data.setOrder.value : this.setOrder,
      setType: data.setType.present ? data.setType.value : this.setType,
      units: data.units.present ? data.units.value : this.units,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutTemplateSetRow(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('exerciseOrder: $exerciseOrder, ')
          ..write('exerciseTypeId: $exerciseTypeId, ')
          ..write('setOrder: $setOrder, ')
          ..write('setType: $setType, ')
          ..write('units: $units')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    templateId,
    exerciseOrder,
    exerciseTypeId,
    setOrder,
    setType,
    units,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutTemplateSetRow &&
          other.id == this.id &&
          other.templateId == this.templateId &&
          other.exerciseOrder == this.exerciseOrder &&
          other.exerciseTypeId == this.exerciseTypeId &&
          other.setOrder == this.setOrder &&
          other.setType == this.setType &&
          other.units == this.units);
}

class WorkoutTemplateSetsTableCompanion
    extends UpdateCompanion<WorkoutTemplateSetRow> {
  final Value<String> id;
  final Value<String> templateId;
  final Value<int> exerciseOrder;
  final Value<String?> exerciseTypeId;
  final Value<int> setOrder;
  final Value<SetType?> setType;
  final Value<Units?> units;
  final Value<int> rowid;
  const WorkoutTemplateSetsTableCompanion({
    this.id = const Value.absent(),
    this.templateId = const Value.absent(),
    this.exerciseOrder = const Value.absent(),
    this.exerciseTypeId = const Value.absent(),
    this.setOrder = const Value.absent(),
    this.setType = const Value.absent(),
    this.units = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutTemplateSetsTableCompanion.insert({
    this.id = const Value.absent(),
    required String templateId,
    required int exerciseOrder,
    this.exerciseTypeId = const Value.absent(),
    required int setOrder,
    this.setType = const Value.absent(),
    this.units = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : templateId = Value(templateId),
       exerciseOrder = Value(exerciseOrder),
       setOrder = Value(setOrder);
  static Insertable<WorkoutTemplateSetRow> custom({
    Expression<String>? id,
    Expression<String>? templateId,
    Expression<int>? exerciseOrder,
    Expression<String>? exerciseTypeId,
    Expression<int>? setOrder,
    Expression<String>? setType,
    Expression<String>? units,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (templateId != null) 'template_id': templateId,
      if (exerciseOrder != null) 'exercise_order': exerciseOrder,
      if (exerciseTypeId != null) 'exercise_type_id': exerciseTypeId,
      if (setOrder != null) 'set_order': setOrder,
      if (setType != null) 'set_type': setType,
      if (units != null) 'units': units,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutTemplateSetsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? templateId,
    Value<int>? exerciseOrder,
    Value<String?>? exerciseTypeId,
    Value<int>? setOrder,
    Value<SetType?>? setType,
    Value<Units?>? units,
    Value<int>? rowid,
  }) {
    return WorkoutTemplateSetsTableCompanion(
      id: id ?? this.id,
      templateId: templateId ?? this.templateId,
      exerciseOrder: exerciseOrder ?? this.exerciseOrder,
      exerciseTypeId: exerciseTypeId ?? this.exerciseTypeId,
      setOrder: setOrder ?? this.setOrder,
      setType: setType ?? this.setType,
      units: units ?? this.units,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<String>(templateId.value);
    }
    if (exerciseOrder.present) {
      map['exercise_order'] = Variable<int>(exerciseOrder.value);
    }
    if (exerciseTypeId.present) {
      map['exercise_type_id'] = Variable<String>(exerciseTypeId.value);
    }
    if (setOrder.present) {
      map['set_order'] = Variable<int>(setOrder.value);
    }
    if (setType.present) {
      map['set_type'] = Variable<String>(
        $WorkoutTemplateSetsTableTable.$convertersetType.toSql(setType.value),
      );
    }
    if (units.present) {
      map['units'] = Variable<String>(
        $WorkoutTemplateSetsTableTable.$converterunits.toSql(units.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutTemplateSetsTableCompanion(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('exerciseOrder: $exerciseOrder, ')
          ..write('exerciseTypeId: $exerciseTypeId, ')
          ..write('setOrder: $setOrder, ')
          ..write('setType: $setType, ')
          ..write('units: $units, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExerciseInstanceTableTable extends ExerciseInstanceTable
    with TableInfo<$ExerciseInstanceTableTable, ExerciseInstanceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExerciseInstanceTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => uuid.v7(),
  );
  static const VerificationMeta _exerciseOrderMeta = const VerificationMeta(
    'exerciseOrder',
  );
  @override
  late final GeneratedColumn<int> exerciseOrder = GeneratedColumn<int>(
    'exercise_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workoutIdMeta = const VerificationMeta(
    'workoutId',
  );
  @override
  late final GeneratedColumn<String> workoutId = GeneratedColumn<String>(
    'workout_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workouts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercises (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    exerciseOrder,
    workoutId,
    exerciseId,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercise_instances';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExerciseInstanceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('exercise_order')) {
      context.handle(
        _exerciseOrderMeta,
        exerciseOrder.isAcceptableOrUnknown(
          data['exercise_order']!,
          _exerciseOrderMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseOrderMeta);
    }
    if (data.containsKey('workout_id')) {
      context.handle(
        _workoutIdMeta,
        workoutId.isAcceptableOrUnknown(data['workout_id']!, _workoutIdMeta),
      );
    } else if (isInserting) {
      context.missing(_workoutIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExerciseInstanceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseInstanceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      exerciseOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercise_order'],
      )!,
      workoutId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workout_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $ExerciseInstanceTableTable createAlias(String alias) {
    return $ExerciseInstanceTableTable(attachedDatabase, alias);
  }
}

class ExerciseInstanceRow extends DataClass
    implements Insertable<ExerciseInstanceRow> {
  final String id;
  final int exerciseOrder;
  final String workoutId;
  final String? exerciseId;
  final String? notes;
  const ExerciseInstanceRow({
    required this.id,
    required this.exerciseOrder,
    required this.workoutId,
    this.exerciseId,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['exercise_order'] = Variable<int>(exerciseOrder);
    map['workout_id'] = Variable<String>(workoutId);
    if (!nullToAbsent || exerciseId != null) {
      map['exercise_id'] = Variable<String>(exerciseId);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  ExerciseInstanceTableCompanion toCompanion(bool nullToAbsent) {
    return ExerciseInstanceTableCompanion(
      id: Value(id),
      exerciseOrder: Value(exerciseOrder),
      workoutId: Value(workoutId),
      exerciseId: exerciseId == null && nullToAbsent
          ? const Value.absent()
          : Value(exerciseId),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory ExerciseInstanceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseInstanceRow(
      id: serializer.fromJson<String>(json['id']),
      exerciseOrder: serializer.fromJson<int>(json['exerciseOrder']),
      workoutId: serializer.fromJson<String>(json['workoutId']),
      exerciseId: serializer.fromJson<String?>(json['exerciseId']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'exerciseOrder': serializer.toJson<int>(exerciseOrder),
      'workoutId': serializer.toJson<String>(workoutId),
      'exerciseId': serializer.toJson<String?>(exerciseId),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  ExerciseInstanceRow copyWith({
    String? id,
    int? exerciseOrder,
    String? workoutId,
    Value<String?> exerciseId = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => ExerciseInstanceRow(
    id: id ?? this.id,
    exerciseOrder: exerciseOrder ?? this.exerciseOrder,
    workoutId: workoutId ?? this.workoutId,
    exerciseId: exerciseId.present ? exerciseId.value : this.exerciseId,
    notes: notes.present ? notes.value : this.notes,
  );
  ExerciseInstanceRow copyWithCompanion(ExerciseInstanceTableCompanion data) {
    return ExerciseInstanceRow(
      id: data.id.present ? data.id.value : this.id,
      exerciseOrder: data.exerciseOrder.present
          ? data.exerciseOrder.value
          : this.exerciseOrder,
      workoutId: data.workoutId.present ? data.workoutId.value : this.workoutId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseInstanceRow(')
          ..write('id: $id, ')
          ..write('exerciseOrder: $exerciseOrder, ')
          ..write('workoutId: $workoutId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, exerciseOrder, workoutId, exerciseId, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseInstanceRow &&
          other.id == this.id &&
          other.exerciseOrder == this.exerciseOrder &&
          other.workoutId == this.workoutId &&
          other.exerciseId == this.exerciseId &&
          other.notes == this.notes);
}

class ExerciseInstanceTableCompanion
    extends UpdateCompanion<ExerciseInstanceRow> {
  final Value<String> id;
  final Value<int> exerciseOrder;
  final Value<String> workoutId;
  final Value<String?> exerciseId;
  final Value<String?> notes;
  final Value<int> rowid;
  const ExerciseInstanceTableCompanion({
    this.id = const Value.absent(),
    this.exerciseOrder = const Value.absent(),
    this.workoutId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExerciseInstanceTableCompanion.insert({
    this.id = const Value.absent(),
    required int exerciseOrder,
    required String workoutId,
    this.exerciseId = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : exerciseOrder = Value(exerciseOrder),
       workoutId = Value(workoutId);
  static Insertable<ExerciseInstanceRow> custom({
    Expression<String>? id,
    Expression<int>? exerciseOrder,
    Expression<String>? workoutId,
    Expression<String>? exerciseId,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (exerciseOrder != null) 'exercise_order': exerciseOrder,
      if (workoutId != null) 'workout_id': workoutId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExerciseInstanceTableCompanion copyWith({
    Value<String>? id,
    Value<int>? exerciseOrder,
    Value<String>? workoutId,
    Value<String?>? exerciseId,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return ExerciseInstanceTableCompanion(
      id: id ?? this.id,
      exerciseOrder: exerciseOrder ?? this.exerciseOrder,
      workoutId: workoutId ?? this.workoutId,
      exerciseId: exerciseId ?? this.exerciseId,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (exerciseOrder.present) {
      map['exercise_order'] = Variable<int>(exerciseOrder.value);
    }
    if (workoutId.present) {
      map['workout_id'] = Variable<String>(workoutId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseInstanceTableCompanion(')
          ..write('id: $id, ')
          ..write('exerciseOrder: $exerciseOrder, ')
          ..write('workoutId: $workoutId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SetsTableTable extends SetsTable
    with TableInfo<$SetsTableTable, SetRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SetsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => uuid.v7(),
  );
  static const VerificationMeta _setOrderMeta = const VerificationMeta(
    'setOrder',
  );
  @override
  late final GeneratedColumn<int> setOrder = GeneratedColumn<int>(
    'set_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseInstanceIdMeta =
      const VerificationMeta('exerciseInstanceId');
  @override
  late final GeneratedColumn<String> exerciseInstanceId =
      GeneratedColumn<String>(
        'exercise_instance_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES exercise_instances (id) ON DELETE CASCADE',
        ),
      );
  @override
  late final GeneratedColumnWithTypeConverter<SetType?, String> setType =
      GeneratedColumn<String>(
        'set_type',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<SetType?>($SetsTableTable.$convertersetType);
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
    'weight',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Units?, String> units =
      GeneratedColumn<String>(
        'units',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Units?>($SetsTableTable.$converterunits);
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _restTimeSecondsMeta = const VerificationMeta(
    'restTimeSeconds',
  );
  @override
  late final GeneratedColumn<int> restTimeSeconds = GeneratedColumn<int>(
    'rest_time_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    setOrder,
    exerciseInstanceId,
    setType,
    weight,
    units,
    reps,
    restTimeSeconds,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sets';
  @override
  VerificationContext validateIntegrity(
    Insertable<SetRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('set_order')) {
      context.handle(
        _setOrderMeta,
        setOrder.isAcceptableOrUnknown(data['set_order']!, _setOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_setOrderMeta);
    }
    if (data.containsKey('exercise_instance_id')) {
      context.handle(
        _exerciseInstanceIdMeta,
        exerciseInstanceId.isAcceptableOrUnknown(
          data['exercise_instance_id']!,
          _exerciseInstanceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseInstanceIdMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    }
    if (data.containsKey('rest_time_seconds')) {
      context.handle(
        _restTimeSecondsMeta,
        restTimeSeconds.isAcceptableOrUnknown(
          data['rest_time_seconds']!,
          _restTimeSecondsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SetRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SetRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      setOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}set_order'],
      )!,
      exerciseInstanceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_instance_id'],
      )!,
      setType: $SetsTableTable.$convertersetType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}set_type'],
        ),
      ),
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight'],
      ),
      units: $SetsTableTable.$converterunits.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}units'],
        ),
      ),
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      ),
      restTimeSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_time_seconds'],
      ),
    );
  }

  @override
  $SetsTableTable createAlias(String alias) {
    return $SetsTableTable(attachedDatabase, alias);
  }

  static TypeConverter<SetType?, String?> $convertersetType =
      const SetTypeConverter();
  static TypeConverter<Units?, String?> $converterunits =
      const UnitsConverter();
}

class SetRow extends DataClass implements Insertable<SetRow> {
  final String id;
  final int setOrder;
  final String exerciseInstanceId;
  final SetType? setType;
  final double? weight;
  final Units? units;
  final int? reps;
  final int? restTimeSeconds;
  const SetRow({
    required this.id,
    required this.setOrder,
    required this.exerciseInstanceId,
    this.setType,
    this.weight,
    this.units,
    this.reps,
    this.restTimeSeconds,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['set_order'] = Variable<int>(setOrder);
    map['exercise_instance_id'] = Variable<String>(exerciseInstanceId);
    if (!nullToAbsent || setType != null) {
      map['set_type'] = Variable<String>(
        $SetsTableTable.$convertersetType.toSql(setType),
      );
    }
    if (!nullToAbsent || weight != null) {
      map['weight'] = Variable<double>(weight);
    }
    if (!nullToAbsent || units != null) {
      map['units'] = Variable<String>(
        $SetsTableTable.$converterunits.toSql(units),
      );
    }
    if (!nullToAbsent || reps != null) {
      map['reps'] = Variable<int>(reps);
    }
    if (!nullToAbsent || restTimeSeconds != null) {
      map['rest_time_seconds'] = Variable<int>(restTimeSeconds);
    }
    return map;
  }

  SetsTableCompanion toCompanion(bool nullToAbsent) {
    return SetsTableCompanion(
      id: Value(id),
      setOrder: Value(setOrder),
      exerciseInstanceId: Value(exerciseInstanceId),
      setType: setType == null && nullToAbsent
          ? const Value.absent()
          : Value(setType),
      weight: weight == null && nullToAbsent
          ? const Value.absent()
          : Value(weight),
      units: units == null && nullToAbsent
          ? const Value.absent()
          : Value(units),
      reps: reps == null && nullToAbsent ? const Value.absent() : Value(reps),
      restTimeSeconds: restTimeSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(restTimeSeconds),
    );
  }

  factory SetRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SetRow(
      id: serializer.fromJson<String>(json['id']),
      setOrder: serializer.fromJson<int>(json['setOrder']),
      exerciseInstanceId: serializer.fromJson<String>(
        json['exerciseInstanceId'],
      ),
      setType: serializer.fromJson<SetType?>(json['setType']),
      weight: serializer.fromJson<double?>(json['weight']),
      units: serializer.fromJson<Units?>(json['units']),
      reps: serializer.fromJson<int?>(json['reps']),
      restTimeSeconds: serializer.fromJson<int?>(json['restTimeSeconds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'setOrder': serializer.toJson<int>(setOrder),
      'exerciseInstanceId': serializer.toJson<String>(exerciseInstanceId),
      'setType': serializer.toJson<SetType?>(setType),
      'weight': serializer.toJson<double?>(weight),
      'units': serializer.toJson<Units?>(units),
      'reps': serializer.toJson<int?>(reps),
      'restTimeSeconds': serializer.toJson<int?>(restTimeSeconds),
    };
  }

  SetRow copyWith({
    String? id,
    int? setOrder,
    String? exerciseInstanceId,
    Value<SetType?> setType = const Value.absent(),
    Value<double?> weight = const Value.absent(),
    Value<Units?> units = const Value.absent(),
    Value<int?> reps = const Value.absent(),
    Value<int?> restTimeSeconds = const Value.absent(),
  }) => SetRow(
    id: id ?? this.id,
    setOrder: setOrder ?? this.setOrder,
    exerciseInstanceId: exerciseInstanceId ?? this.exerciseInstanceId,
    setType: setType.present ? setType.value : this.setType,
    weight: weight.present ? weight.value : this.weight,
    units: units.present ? units.value : this.units,
    reps: reps.present ? reps.value : this.reps,
    restTimeSeconds: restTimeSeconds.present
        ? restTimeSeconds.value
        : this.restTimeSeconds,
  );
  SetRow copyWithCompanion(SetsTableCompanion data) {
    return SetRow(
      id: data.id.present ? data.id.value : this.id,
      setOrder: data.setOrder.present ? data.setOrder.value : this.setOrder,
      exerciseInstanceId: data.exerciseInstanceId.present
          ? data.exerciseInstanceId.value
          : this.exerciseInstanceId,
      setType: data.setType.present ? data.setType.value : this.setType,
      weight: data.weight.present ? data.weight.value : this.weight,
      units: data.units.present ? data.units.value : this.units,
      reps: data.reps.present ? data.reps.value : this.reps,
      restTimeSeconds: data.restTimeSeconds.present
          ? data.restTimeSeconds.value
          : this.restTimeSeconds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SetRow(')
          ..write('id: $id, ')
          ..write('setOrder: $setOrder, ')
          ..write('exerciseInstanceId: $exerciseInstanceId, ')
          ..write('setType: $setType, ')
          ..write('weight: $weight, ')
          ..write('units: $units, ')
          ..write('reps: $reps, ')
          ..write('restTimeSeconds: $restTimeSeconds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    setOrder,
    exerciseInstanceId,
    setType,
    weight,
    units,
    reps,
    restTimeSeconds,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SetRow &&
          other.id == this.id &&
          other.setOrder == this.setOrder &&
          other.exerciseInstanceId == this.exerciseInstanceId &&
          other.setType == this.setType &&
          other.weight == this.weight &&
          other.units == this.units &&
          other.reps == this.reps &&
          other.restTimeSeconds == this.restTimeSeconds);
}

class SetsTableCompanion extends UpdateCompanion<SetRow> {
  final Value<String> id;
  final Value<int> setOrder;
  final Value<String> exerciseInstanceId;
  final Value<SetType?> setType;
  final Value<double?> weight;
  final Value<Units?> units;
  final Value<int?> reps;
  final Value<int?> restTimeSeconds;
  final Value<int> rowid;
  const SetsTableCompanion({
    this.id = const Value.absent(),
    this.setOrder = const Value.absent(),
    this.exerciseInstanceId = const Value.absent(),
    this.setType = const Value.absent(),
    this.weight = const Value.absent(),
    this.units = const Value.absent(),
    this.reps = const Value.absent(),
    this.restTimeSeconds = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SetsTableCompanion.insert({
    this.id = const Value.absent(),
    required int setOrder,
    required String exerciseInstanceId,
    this.setType = const Value.absent(),
    this.weight = const Value.absent(),
    this.units = const Value.absent(),
    this.reps = const Value.absent(),
    this.restTimeSeconds = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : setOrder = Value(setOrder),
       exerciseInstanceId = Value(exerciseInstanceId);
  static Insertable<SetRow> custom({
    Expression<String>? id,
    Expression<int>? setOrder,
    Expression<String>? exerciseInstanceId,
    Expression<String>? setType,
    Expression<double>? weight,
    Expression<String>? units,
    Expression<int>? reps,
    Expression<int>? restTimeSeconds,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (setOrder != null) 'set_order': setOrder,
      if (exerciseInstanceId != null)
        'exercise_instance_id': exerciseInstanceId,
      if (setType != null) 'set_type': setType,
      if (weight != null) 'weight': weight,
      if (units != null) 'units': units,
      if (reps != null) 'reps': reps,
      if (restTimeSeconds != null) 'rest_time_seconds': restTimeSeconds,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SetsTableCompanion copyWith({
    Value<String>? id,
    Value<int>? setOrder,
    Value<String>? exerciseInstanceId,
    Value<SetType?>? setType,
    Value<double?>? weight,
    Value<Units?>? units,
    Value<int?>? reps,
    Value<int?>? restTimeSeconds,
    Value<int>? rowid,
  }) {
    return SetsTableCompanion(
      id: id ?? this.id,
      setOrder: setOrder ?? this.setOrder,
      exerciseInstanceId: exerciseInstanceId ?? this.exerciseInstanceId,
      setType: setType ?? this.setType,
      weight: weight ?? this.weight,
      units: units ?? this.units,
      reps: reps ?? this.reps,
      restTimeSeconds: restTimeSeconds ?? this.restTimeSeconds,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (setOrder.present) {
      map['set_order'] = Variable<int>(setOrder.value);
    }
    if (exerciseInstanceId.present) {
      map['exercise_instance_id'] = Variable<String>(exerciseInstanceId.value);
    }
    if (setType.present) {
      map['set_type'] = Variable<String>(
        $SetsTableTable.$convertersetType.toSql(setType.value),
      );
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (units.present) {
      map['units'] = Variable<String>(
        $SetsTableTable.$converterunits.toSql(units.value),
      );
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (restTimeSeconds.present) {
      map['rest_time_seconds'] = Variable<int>(restTimeSeconds.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SetsTableCompanion(')
          ..write('id: $id, ')
          ..write('setOrder: $setOrder, ')
          ..write('exerciseInstanceId: $exerciseInstanceId, ')
          ..write('setType: $setType, ')
          ..write('weight: $weight, ')
          ..write('units: $units, ')
          ..write('reps: $reps, ')
          ..write('restTimeSeconds: $restTimeSeconds, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MuscleGroupsTableTable extends MuscleGroupsTable
    with TableInfo<$MuscleGroupsTableTable, MuscleGroupRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MuscleGroupsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => uuid.v7(),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
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
  @override
  List<GeneratedColumn> get $columns => [id, label, description];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'muscle_groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<MuscleGroupRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MuscleGroupRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MuscleGroupRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
    );
  }

  @override
  $MuscleGroupsTableTable createAlias(String alias) {
    return $MuscleGroupsTableTable(attachedDatabase, alias);
  }
}

class MuscleGroupRow extends DataClass implements Insertable<MuscleGroupRow> {
  final String id;
  final String label;
  final String? description;
  const MuscleGroupRow({
    required this.id,
    required this.label,
    this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['label'] = Variable<String>(label);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  MuscleGroupsTableCompanion toCompanion(bool nullToAbsent) {
    return MuscleGroupsTableCompanion(
      id: Value(id),
      label: Value(label),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory MuscleGroupRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MuscleGroupRow(
      id: serializer.fromJson<String>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      description: serializer.fromJson<String?>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'label': serializer.toJson<String>(label),
      'description': serializer.toJson<String?>(description),
    };
  }

  MuscleGroupRow copyWith({
    String? id,
    String? label,
    Value<String?> description = const Value.absent(),
  }) => MuscleGroupRow(
    id: id ?? this.id,
    label: label ?? this.label,
    description: description.present ? description.value : this.description,
  );
  MuscleGroupRow copyWithCompanion(MuscleGroupsTableCompanion data) {
    return MuscleGroupRow(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MuscleGroupRow(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, label, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MuscleGroupRow &&
          other.id == this.id &&
          other.label == this.label &&
          other.description == this.description);
}

class MuscleGroupsTableCompanion extends UpdateCompanion<MuscleGroupRow> {
  final Value<String> id;
  final Value<String> label;
  final Value<String?> description;
  final Value<int> rowid;
  const MuscleGroupsTableCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MuscleGroupsTableCompanion.insert({
    this.id = const Value.absent(),
    required String label,
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : label = Value(label);
  static Insertable<MuscleGroupRow> custom({
    Expression<String>? id,
    Expression<String>? label,
    Expression<String>? description,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (description != null) 'description': description,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MuscleGroupsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? label,
    Value<String?>? description,
    Value<int>? rowid,
  }) {
    return MuscleGroupsTableCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      description: description ?? this.description,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MuscleGroupsTableCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('description: $description, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MuscleGroupsToExercisesTableTable extends MuscleGroupsToExercisesTable
    with
        TableInfo<
          $MuscleGroupsToExercisesTableTable,
          MuscleGroupToExerciseRow
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MuscleGroupsToExercisesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => uuid.v7(),
  );
  static const VerificationMeta _muscleGroupIdMeta = const VerificationMeta(
    'muscleGroupId',
  );
  @override
  late final GeneratedColumn<String> muscleGroupId = GeneratedColumn<String>(
    'muscle_group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES muscle_groups (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercises (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, muscleGroupId, exerciseId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'muscle_groups_to_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<MuscleGroupToExerciseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('muscle_group_id')) {
      context.handle(
        _muscleGroupIdMeta,
        muscleGroupId.isAcceptableOrUnknown(
          data['muscle_group_id']!,
          _muscleGroupIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_muscleGroupIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {muscleGroupId, exerciseId},
  ];
  @override
  MuscleGroupToExerciseRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MuscleGroupToExerciseRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      muscleGroupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}muscle_group_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
    );
  }

  @override
  $MuscleGroupsToExercisesTableTable createAlias(String alias) {
    return $MuscleGroupsToExercisesTableTable(attachedDatabase, alias);
  }
}

class MuscleGroupToExerciseRow extends DataClass
    implements Insertable<MuscleGroupToExerciseRow> {
  final String id;
  final String muscleGroupId;
  final String exerciseId;
  const MuscleGroupToExerciseRow({
    required this.id,
    required this.muscleGroupId,
    required this.exerciseId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['muscle_group_id'] = Variable<String>(muscleGroupId);
    map['exercise_id'] = Variable<String>(exerciseId);
    return map;
  }

  MuscleGroupsToExercisesTableCompanion toCompanion(bool nullToAbsent) {
    return MuscleGroupsToExercisesTableCompanion(
      id: Value(id),
      muscleGroupId: Value(muscleGroupId),
      exerciseId: Value(exerciseId),
    );
  }

  factory MuscleGroupToExerciseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MuscleGroupToExerciseRow(
      id: serializer.fromJson<String>(json['id']),
      muscleGroupId: serializer.fromJson<String>(json['muscleGroupId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'muscleGroupId': serializer.toJson<String>(muscleGroupId),
      'exerciseId': serializer.toJson<String>(exerciseId),
    };
  }

  MuscleGroupToExerciseRow copyWith({
    String? id,
    String? muscleGroupId,
    String? exerciseId,
  }) => MuscleGroupToExerciseRow(
    id: id ?? this.id,
    muscleGroupId: muscleGroupId ?? this.muscleGroupId,
    exerciseId: exerciseId ?? this.exerciseId,
  );
  MuscleGroupToExerciseRow copyWithCompanion(
    MuscleGroupsToExercisesTableCompanion data,
  ) {
    return MuscleGroupToExerciseRow(
      id: data.id.present ? data.id.value : this.id,
      muscleGroupId: data.muscleGroupId.present
          ? data.muscleGroupId.value
          : this.muscleGroupId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MuscleGroupToExerciseRow(')
          ..write('id: $id, ')
          ..write('muscleGroupId: $muscleGroupId, ')
          ..write('exerciseId: $exerciseId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, muscleGroupId, exerciseId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MuscleGroupToExerciseRow &&
          other.id == this.id &&
          other.muscleGroupId == this.muscleGroupId &&
          other.exerciseId == this.exerciseId);
}

class MuscleGroupsToExercisesTableCompanion
    extends UpdateCompanion<MuscleGroupToExerciseRow> {
  final Value<String> id;
  final Value<String> muscleGroupId;
  final Value<String> exerciseId;
  final Value<int> rowid;
  const MuscleGroupsToExercisesTableCompanion({
    this.id = const Value.absent(),
    this.muscleGroupId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MuscleGroupsToExercisesTableCompanion.insert({
    this.id = const Value.absent(),
    required String muscleGroupId,
    required String exerciseId,
    this.rowid = const Value.absent(),
  }) : muscleGroupId = Value(muscleGroupId),
       exerciseId = Value(exerciseId);
  static Insertable<MuscleGroupToExerciseRow> custom({
    Expression<String>? id,
    Expression<String>? muscleGroupId,
    Expression<String>? exerciseId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (muscleGroupId != null) 'muscle_group_id': muscleGroupId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MuscleGroupsToExercisesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? muscleGroupId,
    Value<String>? exerciseId,
    Value<int>? rowid,
  }) {
    return MuscleGroupsToExercisesTableCompanion(
      id: id ?? this.id,
      muscleGroupId: muscleGroupId ?? this.muscleGroupId,
      exerciseId: exerciseId ?? this.exerciseId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (muscleGroupId.present) {
      map['muscle_group_id'] = Variable<String>(muscleGroupId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MuscleGroupsToExercisesTableCompanion(')
          ..write('id: $id, ')
          ..write('muscleGroupId: $muscleGroupId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WorkoutTemplatesTableTable workoutTemplatesTable =
      $WorkoutTemplatesTableTable(this);
  late final $WorkoutsTableTable workoutsTable = $WorkoutsTableTable(this);
  late final $ExercisesTableTable exercisesTable = $ExercisesTableTable(this);
  late final $WorkoutTemplateSetsTableTable workoutTemplateSetsTable =
      $WorkoutTemplateSetsTableTable(this);
  late final $ExerciseInstanceTableTable exerciseInstanceTable =
      $ExerciseInstanceTableTable(this);
  late final $SetsTableTable setsTable = $SetsTableTable(this);
  late final $MuscleGroupsTableTable muscleGroupsTable =
      $MuscleGroupsTableTable(this);
  late final $MuscleGroupsToExercisesTableTable muscleGroupsToExercisesTable =
      $MuscleGroupsToExercisesTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    workoutTemplatesTable,
    workoutsTable,
    exercisesTable,
    workoutTemplateSetsTable,
    exerciseInstanceTable,
    setsTable,
    muscleGroupsTable,
    muscleGroupsToExercisesTable,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'workout_templates',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('workouts', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'workout_templates',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('workout_template_sets', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'exercises',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('workout_template_sets', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'workouts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('exercise_instances', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'exercises',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('exercise_instances', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'exercise_instances',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('sets', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'muscle_groups',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('muscle_groups_to_exercises', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'exercises',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('muscle_groups_to_exercises', kind: UpdateKind.delete),
      ],
    ),
  ]);
}

typedef $$WorkoutTemplatesTableTableCreateCompanionBuilder =
    WorkoutTemplatesTableCompanion Function({
      Value<String> id,
      Value<String?> title,
      Value<String?> description,
      Value<int> rowid,
    });
typedef $$WorkoutTemplatesTableTableUpdateCompanionBuilder =
    WorkoutTemplatesTableCompanion Function({
      Value<String> id,
      Value<String?> title,
      Value<String?> description,
      Value<int> rowid,
    });

final class $$WorkoutTemplatesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WorkoutTemplatesTableTable,
          WorkoutTemplateRow
        > {
  $$WorkoutTemplatesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$WorkoutsTableTable, List<WorkoutRow>>
  _workoutsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutsTable,
    aliasName: $_aliasNameGenerator(
      db.workoutTemplatesTable.id,
      db.workoutsTable.templateId,
    ),
  );

  $$WorkoutsTableTableProcessedTableManager get workoutsTableRefs {
    final manager = $$WorkoutsTableTableTableManager(
      $_db,
      $_db.workoutsTable,
    ).filter((f) => f.templateId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_workoutsTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $WorkoutTemplateSetsTableTable,
    List<WorkoutTemplateSetRow>
  >
  _workoutTemplateSetsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.workoutTemplateSetsTable,
        aliasName: $_aliasNameGenerator(
          db.workoutTemplatesTable.id,
          db.workoutTemplateSetsTable.templateId,
        ),
      );

  $$WorkoutTemplateSetsTableTableProcessedTableManager
  get workoutTemplateSetsTableRefs {
    final manager = $$WorkoutTemplateSetsTableTableTableManager(
      $_db,
      $_db.workoutTemplateSetsTable,
    ).filter((f) => f.templateId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutTemplateSetsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutTemplatesTableTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutTemplatesTableTable> {
  $$WorkoutTemplatesTableTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> workoutsTableRefs(
    Expression<bool> Function($$WorkoutsTableTableFilterComposer f) f,
  ) {
    final $$WorkoutsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutsTable,
      getReferencedColumn: (t) => t.templateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableTableFilterComposer(
            $db: $db,
            $table: $db.workoutsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> workoutTemplateSetsTableRefs(
    Expression<bool> Function($$WorkoutTemplateSetsTableTableFilterComposer f)
    f,
  ) {
    final $$WorkoutTemplateSetsTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.workoutTemplateSetsTable,
          getReferencedColumn: (t) => t.templateId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutTemplateSetsTableTableFilterComposer(
                $db: $db,
                $table: $db.workoutTemplateSetsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$WorkoutTemplatesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutTemplatesTableTable> {
  $$WorkoutTemplatesTableTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutTemplatesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutTemplatesTableTable> {
  $$WorkoutTemplatesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  Expression<T> workoutsTableRefs<T extends Object>(
    Expression<T> Function($$WorkoutsTableTableAnnotationComposer a) f,
  ) {
    final $$WorkoutsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutsTable,
      getReferencedColumn: (t) => t.templateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> workoutTemplateSetsTableRefs<T extends Object>(
    Expression<T> Function($$WorkoutTemplateSetsTableTableAnnotationComposer a)
    f,
  ) {
    final $$WorkoutTemplateSetsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.workoutTemplateSetsTable,
          getReferencedColumn: (t) => t.templateId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutTemplateSetsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.workoutTemplateSetsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$WorkoutTemplatesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutTemplatesTableTable,
          WorkoutTemplateRow,
          $$WorkoutTemplatesTableTableFilterComposer,
          $$WorkoutTemplatesTableTableOrderingComposer,
          $$WorkoutTemplatesTableTableAnnotationComposer,
          $$WorkoutTemplatesTableTableCreateCompanionBuilder,
          $$WorkoutTemplatesTableTableUpdateCompanionBuilder,
          (WorkoutTemplateRow, $$WorkoutTemplatesTableTableReferences),
          WorkoutTemplateRow,
          PrefetchHooks Function({
            bool workoutsTableRefs,
            bool workoutTemplateSetsTableRefs,
          })
        > {
  $$WorkoutTemplatesTableTableTableManager(
    _$AppDatabase db,
    $WorkoutTemplatesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutTemplatesTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$WorkoutTemplatesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$WorkoutTemplatesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutTemplatesTableCompanion(
                id: id,
                title: title,
                description: description,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutTemplatesTableCompanion.insert(
                id: id,
                title: title,
                description: description,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkoutTemplatesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                workoutsTableRefs = false,
                workoutTemplateSetsTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (workoutsTableRefs) db.workoutsTable,
                    if (workoutTemplateSetsTableRefs)
                      db.workoutTemplateSetsTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (workoutsTableRefs)
                        await $_getPrefetchedData<
                          WorkoutTemplateRow,
                          $WorkoutTemplatesTableTable,
                          WorkoutRow
                        >(
                          currentTable: table,
                          referencedTable:
                              $$WorkoutTemplatesTableTableReferences
                                  ._workoutsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutTemplatesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.templateId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (workoutTemplateSetsTableRefs)
                        await $_getPrefetchedData<
                          WorkoutTemplateRow,
                          $WorkoutTemplatesTableTable,
                          WorkoutTemplateSetRow
                        >(
                          currentTable: table,
                          referencedTable:
                              $$WorkoutTemplatesTableTableReferences
                                  ._workoutTemplateSetsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutTemplatesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutTemplateSetsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.templateId == item.id,
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

typedef $$WorkoutTemplatesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutTemplatesTableTable,
      WorkoutTemplateRow,
      $$WorkoutTemplatesTableTableFilterComposer,
      $$WorkoutTemplatesTableTableOrderingComposer,
      $$WorkoutTemplatesTableTableAnnotationComposer,
      $$WorkoutTemplatesTableTableCreateCompanionBuilder,
      $$WorkoutTemplatesTableTableUpdateCompanionBuilder,
      (WorkoutTemplateRow, $$WorkoutTemplatesTableTableReferences),
      WorkoutTemplateRow,
      PrefetchHooks Function({
        bool workoutsTableRefs,
        bool workoutTemplateSetsTableRefs,
      })
    >;
typedef $$WorkoutsTableTableCreateCompanionBuilder =
    WorkoutsTableCompanion Function({
      Value<String> id,
      required DateTime date,
      Value<String?> title,
      Value<String?> templateId,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$WorkoutsTableTableUpdateCompanionBuilder =
    WorkoutsTableCompanion Function({
      Value<String> id,
      Value<DateTime> date,
      Value<String?> title,
      Value<String?> templateId,
      Value<String?> notes,
      Value<int> rowid,
    });

final class $$WorkoutsTableTableReferences
    extends BaseReferences<_$AppDatabase, $WorkoutsTableTable, WorkoutRow> {
  $$WorkoutsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkoutTemplatesTableTable _templateIdTable(_$AppDatabase db) =>
      db.workoutTemplatesTable.createAlias(
        $_aliasNameGenerator(
          db.workoutsTable.templateId,
          db.workoutTemplatesTable.id,
        ),
      );

  $$WorkoutTemplatesTableTableProcessedTableManager? get templateId {
    final $_column = $_itemColumn<String>('template_id');
    if ($_column == null) return null;
    final manager = $$WorkoutTemplatesTableTableTableManager(
      $_db,
      $_db.workoutTemplatesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_templateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $ExerciseInstanceTableTable,
    List<ExerciseInstanceRow>
  >
  _exerciseInstanceTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.exerciseInstanceTable,
        aliasName: $_aliasNameGenerator(
          db.workoutsTable.id,
          db.exerciseInstanceTable.workoutId,
        ),
      );

  $$ExerciseInstanceTableTableProcessedTableManager
  get exerciseInstanceTableRefs {
    final manager = $$ExerciseInstanceTableTableTableManager(
      $_db,
      $_db.exerciseInstanceTable,
    ).filter((f) => f.workoutId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _exerciseInstanceTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutsTableTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutsTableTable> {
  $$WorkoutsTableTableFilterComposer({
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

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutTemplatesTableTableFilterComposer get templateId {
    final $$WorkoutTemplatesTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.templateId,
          referencedTable: $db.workoutTemplatesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutTemplatesTableTableFilterComposer(
                $db: $db,
                $table: $db.workoutTemplatesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<bool> exerciseInstanceTableRefs(
    Expression<bool> Function($$ExerciseInstanceTableTableFilterComposer f) f,
  ) {
    final $$ExerciseInstanceTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.exerciseInstanceTable,
          getReferencedColumn: (t) => t.workoutId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ExerciseInstanceTableTableFilterComposer(
                $db: $db,
                $table: $db.exerciseInstanceTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$WorkoutsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutsTableTable> {
  $$WorkoutsTableTableOrderingComposer({
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

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutTemplatesTableTableOrderingComposer get templateId {
    final $$WorkoutTemplatesTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.templateId,
          referencedTable: $db.workoutTemplatesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutTemplatesTableTableOrderingComposer(
                $db: $db,
                $table: $db.workoutTemplatesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$WorkoutsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutsTableTable> {
  $$WorkoutsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$WorkoutTemplatesTableTableAnnotationComposer get templateId {
    final $$WorkoutTemplatesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.templateId,
          referencedTable: $db.workoutTemplatesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutTemplatesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.workoutTemplatesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> exerciseInstanceTableRefs<T extends Object>(
    Expression<T> Function($$ExerciseInstanceTableTableAnnotationComposer a) f,
  ) {
    final $$ExerciseInstanceTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.exerciseInstanceTable,
          getReferencedColumn: (t) => t.workoutId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ExerciseInstanceTableTableAnnotationComposer(
                $db: $db,
                $table: $db.exerciseInstanceTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$WorkoutsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutsTableTable,
          WorkoutRow,
          $$WorkoutsTableTableFilterComposer,
          $$WorkoutsTableTableOrderingComposer,
          $$WorkoutsTableTableAnnotationComposer,
          $$WorkoutsTableTableCreateCompanionBuilder,
          $$WorkoutsTableTableUpdateCompanionBuilder,
          (WorkoutRow, $$WorkoutsTableTableReferences),
          WorkoutRow,
          PrefetchHooks Function({
            bool templateId,
            bool exerciseInstanceTableRefs,
          })
        > {
  $$WorkoutsTableTableTableManager(_$AppDatabase db, $WorkoutsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> templateId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutsTableCompanion(
                id: id,
                date: date,
                title: title,
                templateId: templateId,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required DateTime date,
                Value<String?> title = const Value.absent(),
                Value<String?> templateId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutsTableCompanion.insert(
                id: id,
                date: date,
                title: title,
                templateId: templateId,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkoutsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({templateId = false, exerciseInstanceTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (exerciseInstanceTableRefs) db.exerciseInstanceTable,
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
                        if (templateId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.templateId,
                                    referencedTable:
                                        $$WorkoutsTableTableReferences
                                            ._templateIdTable(db),
                                    referencedColumn:
                                        $$WorkoutsTableTableReferences
                                            ._templateIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (exerciseInstanceTableRefs)
                        await $_getPrefetchedData<
                          WorkoutRow,
                          $WorkoutsTableTable,
                          ExerciseInstanceRow
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutsTableTableReferences
                              ._exerciseInstanceTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).exerciseInstanceTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.workoutId == item.id,
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

typedef $$WorkoutsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutsTableTable,
      WorkoutRow,
      $$WorkoutsTableTableFilterComposer,
      $$WorkoutsTableTableOrderingComposer,
      $$WorkoutsTableTableAnnotationComposer,
      $$WorkoutsTableTableCreateCompanionBuilder,
      $$WorkoutsTableTableUpdateCompanionBuilder,
      (WorkoutRow, $$WorkoutsTableTableReferences),
      WorkoutRow,
      PrefetchHooks Function({bool templateId, bool exerciseInstanceTableRefs})
    >;
typedef $$ExercisesTableTableCreateCompanionBuilder =
    ExercisesTableCompanion Function({
      Value<String> id,
      required String name,
      Value<String?> description,
      Value<int> rowid,
    });
typedef $$ExercisesTableTableUpdateCompanionBuilder =
    ExercisesTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> description,
      Value<int> rowid,
    });

final class $$ExercisesTableTableReferences
    extends BaseReferences<_$AppDatabase, $ExercisesTableTable, ExerciseRow> {
  $$ExercisesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $WorkoutTemplateSetsTableTable,
    List<WorkoutTemplateSetRow>
  >
  _workoutTemplateSetsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.workoutTemplateSetsTable,
        aliasName: $_aliasNameGenerator(
          db.exercisesTable.id,
          db.workoutTemplateSetsTable.exerciseTypeId,
        ),
      );

  $$WorkoutTemplateSetsTableTableProcessedTableManager
  get workoutTemplateSetsTableRefs {
    final manager = $$WorkoutTemplateSetsTableTableTableManager(
      $_db,
      $_db.workoutTemplateSetsTable,
    ).filter((f) => f.exerciseTypeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutTemplateSetsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ExerciseInstanceTableTable,
    List<ExerciseInstanceRow>
  >
  _exerciseInstanceTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.exerciseInstanceTable,
        aliasName: $_aliasNameGenerator(
          db.exercisesTable.id,
          db.exerciseInstanceTable.exerciseId,
        ),
      );

  $$ExerciseInstanceTableTableProcessedTableManager
  get exerciseInstanceTableRefs {
    final manager = $$ExerciseInstanceTableTableTableManager(
      $_db,
      $_db.exerciseInstanceTable,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _exerciseInstanceTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $MuscleGroupsToExercisesTableTable,
    List<MuscleGroupToExerciseRow>
  >
  _muscleGroupsToExercisesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.muscleGroupsToExercisesTable,
        aliasName: $_aliasNameGenerator(
          db.exercisesTable.id,
          db.muscleGroupsToExercisesTable.exerciseId,
        ),
      );

  $$MuscleGroupsToExercisesTableTableProcessedTableManager
  get muscleGroupsToExercisesTableRefs {
    final manager = $$MuscleGroupsToExercisesTableTableTableManager(
      $_db,
      $_db.muscleGroupsToExercisesTable,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _muscleGroupsToExercisesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExercisesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ExercisesTableTable> {
  $$ExercisesTableTableFilterComposer({
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

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> workoutTemplateSetsTableRefs(
    Expression<bool> Function($$WorkoutTemplateSetsTableTableFilterComposer f)
    f,
  ) {
    final $$WorkoutTemplateSetsTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.workoutTemplateSetsTable,
          getReferencedColumn: (t) => t.exerciseTypeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutTemplateSetsTableTableFilterComposer(
                $db: $db,
                $table: $db.workoutTemplateSetsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> exerciseInstanceTableRefs(
    Expression<bool> Function($$ExerciseInstanceTableTableFilterComposer f) f,
  ) {
    final $$ExerciseInstanceTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.exerciseInstanceTable,
          getReferencedColumn: (t) => t.exerciseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ExerciseInstanceTableTableFilterComposer(
                $db: $db,
                $table: $db.exerciseInstanceTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> muscleGroupsToExercisesTableRefs(
    Expression<bool> Function(
      $$MuscleGroupsToExercisesTableTableFilterComposer f,
    )
    f,
  ) {
    final $$MuscleGroupsToExercisesTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.muscleGroupsToExercisesTable,
          getReferencedColumn: (t) => t.exerciseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MuscleGroupsToExercisesTableTableFilterComposer(
                $db: $db,
                $table: $db.muscleGroupsToExercisesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ExercisesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ExercisesTableTable> {
  $$ExercisesTableTableOrderingComposer({
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

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExercisesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExercisesTableTable> {
  $$ExercisesTableTableAnnotationComposer({
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

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  Expression<T> workoutTemplateSetsTableRefs<T extends Object>(
    Expression<T> Function($$WorkoutTemplateSetsTableTableAnnotationComposer a)
    f,
  ) {
    final $$WorkoutTemplateSetsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.workoutTemplateSetsTable,
          getReferencedColumn: (t) => t.exerciseTypeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutTemplateSetsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.workoutTemplateSetsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> exerciseInstanceTableRefs<T extends Object>(
    Expression<T> Function($$ExerciseInstanceTableTableAnnotationComposer a) f,
  ) {
    final $$ExerciseInstanceTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.exerciseInstanceTable,
          getReferencedColumn: (t) => t.exerciseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ExerciseInstanceTableTableAnnotationComposer(
                $db: $db,
                $table: $db.exerciseInstanceTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> muscleGroupsToExercisesTableRefs<T extends Object>(
    Expression<T> Function(
      $$MuscleGroupsToExercisesTableTableAnnotationComposer a,
    )
    f,
  ) {
    final $$MuscleGroupsToExercisesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.muscleGroupsToExercisesTable,
          getReferencedColumn: (t) => t.exerciseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MuscleGroupsToExercisesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.muscleGroupsToExercisesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ExercisesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExercisesTableTable,
          ExerciseRow,
          $$ExercisesTableTableFilterComposer,
          $$ExercisesTableTableOrderingComposer,
          $$ExercisesTableTableAnnotationComposer,
          $$ExercisesTableTableCreateCompanionBuilder,
          $$ExercisesTableTableUpdateCompanionBuilder,
          (ExerciseRow, $$ExercisesTableTableReferences),
          ExerciseRow,
          PrefetchHooks Function({
            bool workoutTemplateSetsTableRefs,
            bool exerciseInstanceTableRefs,
            bool muscleGroupsToExercisesTableRefs,
          })
        > {
  $$ExercisesTableTableTableManager(
    _$AppDatabase db,
    $ExercisesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExercisesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExercisesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExercisesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExercisesTableCompanion(
                id: id,
                name: name,
                description: description,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String name,
                Value<String?> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExercisesTableCompanion.insert(
                id: id,
                name: name,
                description: description,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExercisesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                workoutTemplateSetsTableRefs = false,
                exerciseInstanceTableRefs = false,
                muscleGroupsToExercisesTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (workoutTemplateSetsTableRefs)
                      db.workoutTemplateSetsTable,
                    if (exerciseInstanceTableRefs) db.exerciseInstanceTable,
                    if (muscleGroupsToExercisesTableRefs)
                      db.muscleGroupsToExercisesTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (workoutTemplateSetsTableRefs)
                        await $_getPrefetchedData<
                          ExerciseRow,
                          $ExercisesTableTable,
                          WorkoutTemplateSetRow
                        >(
                          currentTable: table,
                          referencedTable: $$ExercisesTableTableReferences
                              ._workoutTemplateSetsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExercisesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutTemplateSetsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.exerciseTypeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (exerciseInstanceTableRefs)
                        await $_getPrefetchedData<
                          ExerciseRow,
                          $ExercisesTableTable,
                          ExerciseInstanceRow
                        >(
                          currentTable: table,
                          referencedTable: $$ExercisesTableTableReferences
                              ._exerciseInstanceTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExercisesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).exerciseInstanceTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.exerciseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (muscleGroupsToExercisesTableRefs)
                        await $_getPrefetchedData<
                          ExerciseRow,
                          $ExercisesTableTable,
                          MuscleGroupToExerciseRow
                        >(
                          currentTable: table,
                          referencedTable: $$ExercisesTableTableReferences
                              ._muscleGroupsToExercisesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExercisesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).muscleGroupsToExercisesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.exerciseId == item.id,
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

typedef $$ExercisesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExercisesTableTable,
      ExerciseRow,
      $$ExercisesTableTableFilterComposer,
      $$ExercisesTableTableOrderingComposer,
      $$ExercisesTableTableAnnotationComposer,
      $$ExercisesTableTableCreateCompanionBuilder,
      $$ExercisesTableTableUpdateCompanionBuilder,
      (ExerciseRow, $$ExercisesTableTableReferences),
      ExerciseRow,
      PrefetchHooks Function({
        bool workoutTemplateSetsTableRefs,
        bool exerciseInstanceTableRefs,
        bool muscleGroupsToExercisesTableRefs,
      })
    >;
typedef $$WorkoutTemplateSetsTableTableCreateCompanionBuilder =
    WorkoutTemplateSetsTableCompanion Function({
      Value<String> id,
      required String templateId,
      required int exerciseOrder,
      Value<String?> exerciseTypeId,
      required int setOrder,
      Value<SetType?> setType,
      Value<Units?> units,
      Value<int> rowid,
    });
typedef $$WorkoutTemplateSetsTableTableUpdateCompanionBuilder =
    WorkoutTemplateSetsTableCompanion Function({
      Value<String> id,
      Value<String> templateId,
      Value<int> exerciseOrder,
      Value<String?> exerciseTypeId,
      Value<int> setOrder,
      Value<SetType?> setType,
      Value<Units?> units,
      Value<int> rowid,
    });

final class $$WorkoutTemplateSetsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WorkoutTemplateSetsTableTable,
          WorkoutTemplateSetRow
        > {
  $$WorkoutTemplateSetsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkoutTemplatesTableTable _templateIdTable(_$AppDatabase db) =>
      db.workoutTemplatesTable.createAlias(
        $_aliasNameGenerator(
          db.workoutTemplateSetsTable.templateId,
          db.workoutTemplatesTable.id,
        ),
      );

  $$WorkoutTemplatesTableTableProcessedTableManager get templateId {
    final $_column = $_itemColumn<String>('template_id')!;

    final manager = $$WorkoutTemplatesTableTableTableManager(
      $_db,
      $_db.workoutTemplatesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_templateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExercisesTableTable _exerciseTypeIdTable(_$AppDatabase db) =>
      db.exercisesTable.createAlias(
        $_aliasNameGenerator(
          db.workoutTemplateSetsTable.exerciseTypeId,
          db.exercisesTable.id,
        ),
      );

  $$ExercisesTableTableProcessedTableManager? get exerciseTypeId {
    final $_column = $_itemColumn<String>('exercise_type_id');
    if ($_column == null) return null;
    final manager = $$ExercisesTableTableTableManager(
      $_db,
      $_db.exercisesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseTypeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WorkoutTemplateSetsTableTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutTemplateSetsTableTable> {
  $$WorkoutTemplateSetsTableTableFilterComposer({
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

  ColumnFilters<int> get exerciseOrder => $composableBuilder(
    column: $table.exerciseOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get setOrder => $composableBuilder(
    column: $table.setOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SetType?, SetType, String> get setType =>
      $composableBuilder(
        column: $table.setType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Units?, Units, String> get units =>
      $composableBuilder(
        column: $table.units,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  $$WorkoutTemplatesTableTableFilterComposer get templateId {
    final $$WorkoutTemplatesTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.templateId,
          referencedTable: $db.workoutTemplatesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutTemplatesTableTableFilterComposer(
                $db: $db,
                $table: $db.workoutTemplatesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$ExercisesTableTableFilterComposer get exerciseTypeId {
    final $$ExercisesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseTypeId,
      referencedTable: $db.exercisesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableTableFilterComposer(
            $db: $db,
            $table: $db.exercisesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutTemplateSetsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutTemplateSetsTableTable> {
  $$WorkoutTemplateSetsTableTableOrderingComposer({
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

  ColumnOrderings<int> get exerciseOrder => $composableBuilder(
    column: $table.exerciseOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get setOrder => $composableBuilder(
    column: $table.setOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get setType => $composableBuilder(
    column: $table.setType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get units => $composableBuilder(
    column: $table.units,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutTemplatesTableTableOrderingComposer get templateId {
    final $$WorkoutTemplatesTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.templateId,
          referencedTable: $db.workoutTemplatesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutTemplatesTableTableOrderingComposer(
                $db: $db,
                $table: $db.workoutTemplatesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$ExercisesTableTableOrderingComposer get exerciseTypeId {
    final $$ExercisesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseTypeId,
      referencedTable: $db.exercisesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableTableOrderingComposer(
            $db: $db,
            $table: $db.exercisesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutTemplateSetsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutTemplateSetsTableTable> {
  $$WorkoutTemplateSetsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get exerciseOrder => $composableBuilder(
    column: $table.exerciseOrder,
    builder: (column) => column,
  );

  GeneratedColumn<int> get setOrder =>
      $composableBuilder(column: $table.setOrder, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SetType?, String> get setType =>
      $composableBuilder(column: $table.setType, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Units?, String> get units =>
      $composableBuilder(column: $table.units, builder: (column) => column);

  $$WorkoutTemplatesTableTableAnnotationComposer get templateId {
    final $$WorkoutTemplatesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.templateId,
          referencedTable: $db.workoutTemplatesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutTemplatesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.workoutTemplatesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$ExercisesTableTableAnnotationComposer get exerciseTypeId {
    final $$ExercisesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseTypeId,
      referencedTable: $db.exercisesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.exercisesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutTemplateSetsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutTemplateSetsTableTable,
          WorkoutTemplateSetRow,
          $$WorkoutTemplateSetsTableTableFilterComposer,
          $$WorkoutTemplateSetsTableTableOrderingComposer,
          $$WorkoutTemplateSetsTableTableAnnotationComposer,
          $$WorkoutTemplateSetsTableTableCreateCompanionBuilder,
          $$WorkoutTemplateSetsTableTableUpdateCompanionBuilder,
          (WorkoutTemplateSetRow, $$WorkoutTemplateSetsTableTableReferences),
          WorkoutTemplateSetRow,
          PrefetchHooks Function({bool templateId, bool exerciseTypeId})
        > {
  $$WorkoutTemplateSetsTableTableTableManager(
    _$AppDatabase db,
    $WorkoutTemplateSetsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutTemplateSetsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$WorkoutTemplateSetsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$WorkoutTemplateSetsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> templateId = const Value.absent(),
                Value<int> exerciseOrder = const Value.absent(),
                Value<String?> exerciseTypeId = const Value.absent(),
                Value<int> setOrder = const Value.absent(),
                Value<SetType?> setType = const Value.absent(),
                Value<Units?> units = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutTemplateSetsTableCompanion(
                id: id,
                templateId: templateId,
                exerciseOrder: exerciseOrder,
                exerciseTypeId: exerciseTypeId,
                setOrder: setOrder,
                setType: setType,
                units: units,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String templateId,
                required int exerciseOrder,
                Value<String?> exerciseTypeId = const Value.absent(),
                required int setOrder,
                Value<SetType?> setType = const Value.absent(),
                Value<Units?> units = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutTemplateSetsTableCompanion.insert(
                id: id,
                templateId: templateId,
                exerciseOrder: exerciseOrder,
                exerciseTypeId: exerciseTypeId,
                setOrder: setOrder,
                setType: setType,
                units: units,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkoutTemplateSetsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({templateId = false, exerciseTypeId = false}) {
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
                    if (templateId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.templateId,
                                referencedTable:
                                    $$WorkoutTemplateSetsTableTableReferences
                                        ._templateIdTable(db),
                                referencedColumn:
                                    $$WorkoutTemplateSetsTableTableReferences
                                        ._templateIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (exerciseTypeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.exerciseTypeId,
                                referencedTable:
                                    $$WorkoutTemplateSetsTableTableReferences
                                        ._exerciseTypeIdTable(db),
                                referencedColumn:
                                    $$WorkoutTemplateSetsTableTableReferences
                                        ._exerciseTypeIdTable(db)
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

typedef $$WorkoutTemplateSetsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutTemplateSetsTableTable,
      WorkoutTemplateSetRow,
      $$WorkoutTemplateSetsTableTableFilterComposer,
      $$WorkoutTemplateSetsTableTableOrderingComposer,
      $$WorkoutTemplateSetsTableTableAnnotationComposer,
      $$WorkoutTemplateSetsTableTableCreateCompanionBuilder,
      $$WorkoutTemplateSetsTableTableUpdateCompanionBuilder,
      (WorkoutTemplateSetRow, $$WorkoutTemplateSetsTableTableReferences),
      WorkoutTemplateSetRow,
      PrefetchHooks Function({bool templateId, bool exerciseTypeId})
    >;
typedef $$ExerciseInstanceTableTableCreateCompanionBuilder =
    ExerciseInstanceTableCompanion Function({
      Value<String> id,
      required int exerciseOrder,
      required String workoutId,
      Value<String?> exerciseId,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$ExerciseInstanceTableTableUpdateCompanionBuilder =
    ExerciseInstanceTableCompanion Function({
      Value<String> id,
      Value<int> exerciseOrder,
      Value<String> workoutId,
      Value<String?> exerciseId,
      Value<String?> notes,
      Value<int> rowid,
    });

final class $$ExerciseInstanceTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ExerciseInstanceTableTable,
          ExerciseInstanceRow
        > {
  $$ExerciseInstanceTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkoutsTableTable _workoutIdTable(_$AppDatabase db) =>
      db.workoutsTable.createAlias(
        $_aliasNameGenerator(
          db.exerciseInstanceTable.workoutId,
          db.workoutsTable.id,
        ),
      );

  $$WorkoutsTableTableProcessedTableManager get workoutId {
    final $_column = $_itemColumn<String>('workout_id')!;

    final manager = $$WorkoutsTableTableTableManager(
      $_db,
      $_db.workoutsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workoutIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExercisesTableTable _exerciseIdTable(_$AppDatabase db) =>
      db.exercisesTable.createAlias(
        $_aliasNameGenerator(
          db.exerciseInstanceTable.exerciseId,
          db.exercisesTable.id,
        ),
      );

  $$ExercisesTableTableProcessedTableManager? get exerciseId {
    final $_column = $_itemColumn<String>('exercise_id');
    if ($_column == null) return null;
    final manager = $$ExercisesTableTableTableManager(
      $_db,
      $_db.exercisesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SetsTableTable, List<SetRow>> _setsTableRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.setsTable,
    aliasName: $_aliasNameGenerator(
      db.exerciseInstanceTable.id,
      db.setsTable.exerciseInstanceId,
    ),
  );

  $$SetsTableTableProcessedTableManager get setsTableRefs {
    final manager = $$SetsTableTableTableManager($_db, $_db.setsTable).filter(
      (f) => f.exerciseInstanceId.id.sqlEquals($_itemColumn<String>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_setsTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExerciseInstanceTableTableFilterComposer
    extends Composer<_$AppDatabase, $ExerciseInstanceTableTable> {
  $$ExerciseInstanceTableTableFilterComposer({
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

  ColumnFilters<int> get exerciseOrder => $composableBuilder(
    column: $table.exerciseOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutsTableTableFilterComposer get workoutId {
    final $$WorkoutsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workoutsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableTableFilterComposer(
            $db: $db,
            $table: $db.workoutsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableTableFilterComposer get exerciseId {
    final $$ExercisesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercisesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableTableFilterComposer(
            $db: $db,
            $table: $db.exercisesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> setsTableRefs(
    Expression<bool> Function($$SetsTableTableFilterComposer f) f,
  ) {
    final $$SetsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.setsTable,
      getReferencedColumn: (t) => t.exerciseInstanceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SetsTableTableFilterComposer(
            $db: $db,
            $table: $db.setsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExerciseInstanceTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ExerciseInstanceTableTable> {
  $$ExerciseInstanceTableTableOrderingComposer({
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

  ColumnOrderings<int> get exerciseOrder => $composableBuilder(
    column: $table.exerciseOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutsTableTableOrderingComposer get workoutId {
    final $$WorkoutsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workoutsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableTableOrderingComposer(
            $db: $db,
            $table: $db.workoutsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableTableOrderingComposer get exerciseId {
    final $$ExercisesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercisesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableTableOrderingComposer(
            $db: $db,
            $table: $db.exercisesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExerciseInstanceTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExerciseInstanceTableTable> {
  $$ExerciseInstanceTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get exerciseOrder => $composableBuilder(
    column: $table.exerciseOrder,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$WorkoutsTableTableAnnotationComposer get workoutId {
    final $$WorkoutsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workoutsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableTableAnnotationComposer get exerciseId {
    final $$ExercisesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercisesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.exercisesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> setsTableRefs<T extends Object>(
    Expression<T> Function($$SetsTableTableAnnotationComposer a) f,
  ) {
    final $$SetsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.setsTable,
      getReferencedColumn: (t) => t.exerciseInstanceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SetsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.setsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExerciseInstanceTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExerciseInstanceTableTable,
          ExerciseInstanceRow,
          $$ExerciseInstanceTableTableFilterComposer,
          $$ExerciseInstanceTableTableOrderingComposer,
          $$ExerciseInstanceTableTableAnnotationComposer,
          $$ExerciseInstanceTableTableCreateCompanionBuilder,
          $$ExerciseInstanceTableTableUpdateCompanionBuilder,
          (ExerciseInstanceRow, $$ExerciseInstanceTableTableReferences),
          ExerciseInstanceRow,
          PrefetchHooks Function({
            bool workoutId,
            bool exerciseId,
            bool setsTableRefs,
          })
        > {
  $$ExerciseInstanceTableTableTableManager(
    _$AppDatabase db,
    $ExerciseInstanceTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExerciseInstanceTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ExerciseInstanceTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ExerciseInstanceTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> exerciseOrder = const Value.absent(),
                Value<String> workoutId = const Value.absent(),
                Value<String?> exerciseId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExerciseInstanceTableCompanion(
                id: id,
                exerciseOrder: exerciseOrder,
                workoutId: workoutId,
                exerciseId: exerciseId,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required int exerciseOrder,
                required String workoutId,
                Value<String?> exerciseId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExerciseInstanceTableCompanion.insert(
                id: id,
                exerciseOrder: exerciseOrder,
                workoutId: workoutId,
                exerciseId: exerciseId,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExerciseInstanceTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({workoutId = false, exerciseId = false, setsTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (setsTableRefs) db.setsTable],
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
                        if (workoutId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.workoutId,
                                    referencedTable:
                                        $$ExerciseInstanceTableTableReferences
                                            ._workoutIdTable(db),
                                    referencedColumn:
                                        $$ExerciseInstanceTableTableReferences
                                            ._workoutIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (exerciseId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.exerciseId,
                                    referencedTable:
                                        $$ExerciseInstanceTableTableReferences
                                            ._exerciseIdTable(db),
                                    referencedColumn:
                                        $$ExerciseInstanceTableTableReferences
                                            ._exerciseIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (setsTableRefs)
                        await $_getPrefetchedData<
                          ExerciseInstanceRow,
                          $ExerciseInstanceTableTable,
                          SetRow
                        >(
                          currentTable: table,
                          referencedTable:
                              $$ExerciseInstanceTableTableReferences
                                  ._setsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExerciseInstanceTableTableReferences(
                                db,
                                table,
                                p0,
                              ).setsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.exerciseInstanceId == item.id,
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

typedef $$ExerciseInstanceTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExerciseInstanceTableTable,
      ExerciseInstanceRow,
      $$ExerciseInstanceTableTableFilterComposer,
      $$ExerciseInstanceTableTableOrderingComposer,
      $$ExerciseInstanceTableTableAnnotationComposer,
      $$ExerciseInstanceTableTableCreateCompanionBuilder,
      $$ExerciseInstanceTableTableUpdateCompanionBuilder,
      (ExerciseInstanceRow, $$ExerciseInstanceTableTableReferences),
      ExerciseInstanceRow,
      PrefetchHooks Function({
        bool workoutId,
        bool exerciseId,
        bool setsTableRefs,
      })
    >;
typedef $$SetsTableTableCreateCompanionBuilder =
    SetsTableCompanion Function({
      Value<String> id,
      required int setOrder,
      required String exerciseInstanceId,
      Value<SetType?> setType,
      Value<double?> weight,
      Value<Units?> units,
      Value<int?> reps,
      Value<int?> restTimeSeconds,
      Value<int> rowid,
    });
typedef $$SetsTableTableUpdateCompanionBuilder =
    SetsTableCompanion Function({
      Value<String> id,
      Value<int> setOrder,
      Value<String> exerciseInstanceId,
      Value<SetType?> setType,
      Value<double?> weight,
      Value<Units?> units,
      Value<int?> reps,
      Value<int?> restTimeSeconds,
      Value<int> rowid,
    });

final class $$SetsTableTableReferences
    extends BaseReferences<_$AppDatabase, $SetsTableTable, SetRow> {
  $$SetsTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ExerciseInstanceTableTable _exerciseInstanceIdTable(
    _$AppDatabase db,
  ) => db.exerciseInstanceTable.createAlias(
    $_aliasNameGenerator(
      db.setsTable.exerciseInstanceId,
      db.exerciseInstanceTable.id,
    ),
  );

  $$ExerciseInstanceTableTableProcessedTableManager get exerciseInstanceId {
    final $_column = $_itemColumn<String>('exercise_instance_id')!;

    final manager = $$ExerciseInstanceTableTableTableManager(
      $_db,
      $_db.exerciseInstanceTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseInstanceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SetsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SetsTableTable> {
  $$SetsTableTableFilterComposer({
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

  ColumnFilters<int> get setOrder => $composableBuilder(
    column: $table.setOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SetType?, SetType, String> get setType =>
      $composableBuilder(
        column: $table.setType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Units?, Units, String> get units =>
      $composableBuilder(
        column: $table.units,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restTimeSeconds => $composableBuilder(
    column: $table.restTimeSeconds,
    builder: (column) => ColumnFilters(column),
  );

  $$ExerciseInstanceTableTableFilterComposer get exerciseInstanceId {
    final $$ExerciseInstanceTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.exerciseInstanceId,
          referencedTable: $db.exerciseInstanceTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ExerciseInstanceTableTableFilterComposer(
                $db: $db,
                $table: $db.exerciseInstanceTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$SetsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SetsTableTable> {
  $$SetsTableTableOrderingComposer({
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

  ColumnOrderings<int> get setOrder => $composableBuilder(
    column: $table.setOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get setType => $composableBuilder(
    column: $table.setType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get units => $composableBuilder(
    column: $table.units,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restTimeSeconds => $composableBuilder(
    column: $table.restTimeSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExerciseInstanceTableTableOrderingComposer get exerciseInstanceId {
    final $$ExerciseInstanceTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.exerciseInstanceId,
          referencedTable: $db.exerciseInstanceTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ExerciseInstanceTableTableOrderingComposer(
                $db: $db,
                $table: $db.exerciseInstanceTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$SetsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SetsTableTable> {
  $$SetsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get setOrder =>
      $composableBuilder(column: $table.setOrder, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SetType?, String> get setType =>
      $composableBuilder(column: $table.setType, builder: (column) => column);

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Units?, String> get units =>
      $composableBuilder(column: $table.units, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<int> get restTimeSeconds => $composableBuilder(
    column: $table.restTimeSeconds,
    builder: (column) => column,
  );

  $$ExerciseInstanceTableTableAnnotationComposer get exerciseInstanceId {
    final $$ExerciseInstanceTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.exerciseInstanceId,
          referencedTable: $db.exerciseInstanceTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ExerciseInstanceTableTableAnnotationComposer(
                $db: $db,
                $table: $db.exerciseInstanceTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$SetsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SetsTableTable,
          SetRow,
          $$SetsTableTableFilterComposer,
          $$SetsTableTableOrderingComposer,
          $$SetsTableTableAnnotationComposer,
          $$SetsTableTableCreateCompanionBuilder,
          $$SetsTableTableUpdateCompanionBuilder,
          (SetRow, $$SetsTableTableReferences),
          SetRow,
          PrefetchHooks Function({bool exerciseInstanceId})
        > {
  $$SetsTableTableTableManager(_$AppDatabase db, $SetsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SetsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SetsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SetsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> setOrder = const Value.absent(),
                Value<String> exerciseInstanceId = const Value.absent(),
                Value<SetType?> setType = const Value.absent(),
                Value<double?> weight = const Value.absent(),
                Value<Units?> units = const Value.absent(),
                Value<int?> reps = const Value.absent(),
                Value<int?> restTimeSeconds = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SetsTableCompanion(
                id: id,
                setOrder: setOrder,
                exerciseInstanceId: exerciseInstanceId,
                setType: setType,
                weight: weight,
                units: units,
                reps: reps,
                restTimeSeconds: restTimeSeconds,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required int setOrder,
                required String exerciseInstanceId,
                Value<SetType?> setType = const Value.absent(),
                Value<double?> weight = const Value.absent(),
                Value<Units?> units = const Value.absent(),
                Value<int?> reps = const Value.absent(),
                Value<int?> restTimeSeconds = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SetsTableCompanion.insert(
                id: id,
                setOrder: setOrder,
                exerciseInstanceId: exerciseInstanceId,
                setType: setType,
                weight: weight,
                units: units,
                reps: reps,
                restTimeSeconds: restTimeSeconds,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SetsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({exerciseInstanceId = false}) {
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
                    if (exerciseInstanceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.exerciseInstanceId,
                                referencedTable: $$SetsTableTableReferences
                                    ._exerciseInstanceIdTable(db),
                                referencedColumn: $$SetsTableTableReferences
                                    ._exerciseInstanceIdTable(db)
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

typedef $$SetsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SetsTableTable,
      SetRow,
      $$SetsTableTableFilterComposer,
      $$SetsTableTableOrderingComposer,
      $$SetsTableTableAnnotationComposer,
      $$SetsTableTableCreateCompanionBuilder,
      $$SetsTableTableUpdateCompanionBuilder,
      (SetRow, $$SetsTableTableReferences),
      SetRow,
      PrefetchHooks Function({bool exerciseInstanceId})
    >;
typedef $$MuscleGroupsTableTableCreateCompanionBuilder =
    MuscleGroupsTableCompanion Function({
      Value<String> id,
      required String label,
      Value<String?> description,
      Value<int> rowid,
    });
typedef $$MuscleGroupsTableTableUpdateCompanionBuilder =
    MuscleGroupsTableCompanion Function({
      Value<String> id,
      Value<String> label,
      Value<String?> description,
      Value<int> rowid,
    });

final class $$MuscleGroupsTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $MuscleGroupsTableTable, MuscleGroupRow> {
  $$MuscleGroupsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $MuscleGroupsToExercisesTableTable,
    List<MuscleGroupToExerciseRow>
  >
  _muscleGroupsToExercisesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.muscleGroupsToExercisesTable,
        aliasName: $_aliasNameGenerator(
          db.muscleGroupsTable.id,
          db.muscleGroupsToExercisesTable.muscleGroupId,
        ),
      );

  $$MuscleGroupsToExercisesTableTableProcessedTableManager
  get muscleGroupsToExercisesTableRefs {
    final manager = $$MuscleGroupsToExercisesTableTableTableManager(
      $_db,
      $_db.muscleGroupsToExercisesTable,
    ).filter((f) => f.muscleGroupId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _muscleGroupsToExercisesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MuscleGroupsTableTableFilterComposer
    extends Composer<_$AppDatabase, $MuscleGroupsTableTable> {
  $$MuscleGroupsTableTableFilterComposer({
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

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> muscleGroupsToExercisesTableRefs(
    Expression<bool> Function(
      $$MuscleGroupsToExercisesTableTableFilterComposer f,
    )
    f,
  ) {
    final $$MuscleGroupsToExercisesTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.muscleGroupsToExercisesTable,
          getReferencedColumn: (t) => t.muscleGroupId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MuscleGroupsToExercisesTableTableFilterComposer(
                $db: $db,
                $table: $db.muscleGroupsToExercisesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$MuscleGroupsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MuscleGroupsTableTable> {
  $$MuscleGroupsTableTableOrderingComposer({
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

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MuscleGroupsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MuscleGroupsTableTable> {
  $$MuscleGroupsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  Expression<T> muscleGroupsToExercisesTableRefs<T extends Object>(
    Expression<T> Function(
      $$MuscleGroupsToExercisesTableTableAnnotationComposer a,
    )
    f,
  ) {
    final $$MuscleGroupsToExercisesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.muscleGroupsToExercisesTable,
          getReferencedColumn: (t) => t.muscleGroupId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MuscleGroupsToExercisesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.muscleGroupsToExercisesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$MuscleGroupsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MuscleGroupsTableTable,
          MuscleGroupRow,
          $$MuscleGroupsTableTableFilterComposer,
          $$MuscleGroupsTableTableOrderingComposer,
          $$MuscleGroupsTableTableAnnotationComposer,
          $$MuscleGroupsTableTableCreateCompanionBuilder,
          $$MuscleGroupsTableTableUpdateCompanionBuilder,
          (MuscleGroupRow, $$MuscleGroupsTableTableReferences),
          MuscleGroupRow,
          PrefetchHooks Function({bool muscleGroupsToExercisesTableRefs})
        > {
  $$MuscleGroupsTableTableTableManager(
    _$AppDatabase db,
    $MuscleGroupsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MuscleGroupsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MuscleGroupsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MuscleGroupsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MuscleGroupsTableCompanion(
                id: id,
                label: label,
                description: description,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String label,
                Value<String?> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MuscleGroupsTableCompanion.insert(
                id: id,
                label: label,
                description: description,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MuscleGroupsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({muscleGroupsToExercisesTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (muscleGroupsToExercisesTableRefs)
                  db.muscleGroupsToExercisesTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (muscleGroupsToExercisesTableRefs)
                    await $_getPrefetchedData<
                      MuscleGroupRow,
                      $MuscleGroupsTableTable,
                      MuscleGroupToExerciseRow
                    >(
                      currentTable: table,
                      referencedTable: $$MuscleGroupsTableTableReferences
                          ._muscleGroupsToExercisesTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$MuscleGroupsTableTableReferences(
                            db,
                            table,
                            p0,
                          ).muscleGroupsToExercisesTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.muscleGroupId == item.id,
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

typedef $$MuscleGroupsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MuscleGroupsTableTable,
      MuscleGroupRow,
      $$MuscleGroupsTableTableFilterComposer,
      $$MuscleGroupsTableTableOrderingComposer,
      $$MuscleGroupsTableTableAnnotationComposer,
      $$MuscleGroupsTableTableCreateCompanionBuilder,
      $$MuscleGroupsTableTableUpdateCompanionBuilder,
      (MuscleGroupRow, $$MuscleGroupsTableTableReferences),
      MuscleGroupRow,
      PrefetchHooks Function({bool muscleGroupsToExercisesTableRefs})
    >;
typedef $$MuscleGroupsToExercisesTableTableCreateCompanionBuilder =
    MuscleGroupsToExercisesTableCompanion Function({
      Value<String> id,
      required String muscleGroupId,
      required String exerciseId,
      Value<int> rowid,
    });
typedef $$MuscleGroupsToExercisesTableTableUpdateCompanionBuilder =
    MuscleGroupsToExercisesTableCompanion Function({
      Value<String> id,
      Value<String> muscleGroupId,
      Value<String> exerciseId,
      Value<int> rowid,
    });

final class $$MuscleGroupsToExercisesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MuscleGroupsToExercisesTableTable,
          MuscleGroupToExerciseRow
        > {
  $$MuscleGroupsToExercisesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MuscleGroupsTableTable _muscleGroupIdTable(_$AppDatabase db) =>
      db.muscleGroupsTable.createAlias(
        $_aliasNameGenerator(
          db.muscleGroupsToExercisesTable.muscleGroupId,
          db.muscleGroupsTable.id,
        ),
      );

  $$MuscleGroupsTableTableProcessedTableManager get muscleGroupId {
    final $_column = $_itemColumn<String>('muscle_group_id')!;

    final manager = $$MuscleGroupsTableTableTableManager(
      $_db,
      $_db.muscleGroupsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_muscleGroupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExercisesTableTable _exerciseIdTable(_$AppDatabase db) =>
      db.exercisesTable.createAlias(
        $_aliasNameGenerator(
          db.muscleGroupsToExercisesTable.exerciseId,
          db.exercisesTable.id,
        ),
      );

  $$ExercisesTableTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<String>('exercise_id')!;

    final manager = $$ExercisesTableTableTableManager(
      $_db,
      $_db.exercisesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MuscleGroupsToExercisesTableTableFilterComposer
    extends Composer<_$AppDatabase, $MuscleGroupsToExercisesTableTable> {
  $$MuscleGroupsToExercisesTableTableFilterComposer({
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

  $$MuscleGroupsTableTableFilterComposer get muscleGroupId {
    final $$MuscleGroupsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.muscleGroupId,
      referencedTable: $db.muscleGroupsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MuscleGroupsTableTableFilterComposer(
            $db: $db,
            $table: $db.muscleGroupsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableTableFilterComposer get exerciseId {
    final $$ExercisesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercisesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableTableFilterComposer(
            $db: $db,
            $table: $db.exercisesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MuscleGroupsToExercisesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MuscleGroupsToExercisesTableTable> {
  $$MuscleGroupsToExercisesTableTableOrderingComposer({
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

  $$MuscleGroupsTableTableOrderingComposer get muscleGroupId {
    final $$MuscleGroupsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.muscleGroupId,
      referencedTable: $db.muscleGroupsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MuscleGroupsTableTableOrderingComposer(
            $db: $db,
            $table: $db.muscleGroupsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableTableOrderingComposer get exerciseId {
    final $$ExercisesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercisesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableTableOrderingComposer(
            $db: $db,
            $table: $db.exercisesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MuscleGroupsToExercisesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MuscleGroupsToExercisesTableTable> {
  $$MuscleGroupsToExercisesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  $$MuscleGroupsTableTableAnnotationComposer get muscleGroupId {
    final $$MuscleGroupsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.muscleGroupId,
          referencedTable: $db.muscleGroupsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MuscleGroupsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.muscleGroupsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$ExercisesTableTableAnnotationComposer get exerciseId {
    final $$ExercisesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercisesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.exercisesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MuscleGroupsToExercisesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MuscleGroupsToExercisesTableTable,
          MuscleGroupToExerciseRow,
          $$MuscleGroupsToExercisesTableTableFilterComposer,
          $$MuscleGroupsToExercisesTableTableOrderingComposer,
          $$MuscleGroupsToExercisesTableTableAnnotationComposer,
          $$MuscleGroupsToExercisesTableTableCreateCompanionBuilder,
          $$MuscleGroupsToExercisesTableTableUpdateCompanionBuilder,
          (
            MuscleGroupToExerciseRow,
            $$MuscleGroupsToExercisesTableTableReferences,
          ),
          MuscleGroupToExerciseRow,
          PrefetchHooks Function({bool muscleGroupId, bool exerciseId})
        > {
  $$MuscleGroupsToExercisesTableTableTableManager(
    _$AppDatabase db,
    $MuscleGroupsToExercisesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MuscleGroupsToExercisesTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$MuscleGroupsToExercisesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MuscleGroupsToExercisesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> muscleGroupId = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MuscleGroupsToExercisesTableCompanion(
                id: id,
                muscleGroupId: muscleGroupId,
                exerciseId: exerciseId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String muscleGroupId,
                required String exerciseId,
                Value<int> rowid = const Value.absent(),
              }) => MuscleGroupsToExercisesTableCompanion.insert(
                id: id,
                muscleGroupId: muscleGroupId,
                exerciseId: exerciseId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MuscleGroupsToExercisesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({muscleGroupId = false, exerciseId = false}) {
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
                    if (muscleGroupId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.muscleGroupId,
                                referencedTable:
                                    $$MuscleGroupsToExercisesTableTableReferences
                                        ._muscleGroupIdTable(db),
                                referencedColumn:
                                    $$MuscleGroupsToExercisesTableTableReferences
                                        ._muscleGroupIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (exerciseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.exerciseId,
                                referencedTable:
                                    $$MuscleGroupsToExercisesTableTableReferences
                                        ._exerciseIdTable(db),
                                referencedColumn:
                                    $$MuscleGroupsToExercisesTableTableReferences
                                        ._exerciseIdTable(db)
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

typedef $$MuscleGroupsToExercisesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MuscleGroupsToExercisesTableTable,
      MuscleGroupToExerciseRow,
      $$MuscleGroupsToExercisesTableTableFilterComposer,
      $$MuscleGroupsToExercisesTableTableOrderingComposer,
      $$MuscleGroupsToExercisesTableTableAnnotationComposer,
      $$MuscleGroupsToExercisesTableTableCreateCompanionBuilder,
      $$MuscleGroupsToExercisesTableTableUpdateCompanionBuilder,
      (MuscleGroupToExerciseRow, $$MuscleGroupsToExercisesTableTableReferences),
      MuscleGroupToExerciseRow,
      PrefetchHooks Function({bool muscleGroupId, bool exerciseId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WorkoutTemplatesTableTableTableManager get workoutTemplatesTable =>
      $$WorkoutTemplatesTableTableTableManager(_db, _db.workoutTemplatesTable);
  $$WorkoutsTableTableTableManager get workoutsTable =>
      $$WorkoutsTableTableTableManager(_db, _db.workoutsTable);
  $$ExercisesTableTableTableManager get exercisesTable =>
      $$ExercisesTableTableTableManager(_db, _db.exercisesTable);
  $$WorkoutTemplateSetsTableTableTableManager get workoutTemplateSetsTable =>
      $$WorkoutTemplateSetsTableTableTableManager(
        _db,
        _db.workoutTemplateSetsTable,
      );
  $$ExerciseInstanceTableTableTableManager get exerciseInstanceTable =>
      $$ExerciseInstanceTableTableTableManager(_db, _db.exerciseInstanceTable);
  $$SetsTableTableTableManager get setsTable =>
      $$SetsTableTableTableManager(_db, _db.setsTable);
  $$MuscleGroupsTableTableTableManager get muscleGroupsTable =>
      $$MuscleGroupsTableTableTableManager(_db, _db.muscleGroupsTable);
  $$MuscleGroupsToExercisesTableTableTableManager
  get muscleGroupsToExercisesTable =>
      $$MuscleGroupsToExercisesTableTableTableManager(
        _db,
        _db.muscleGroupsToExercisesTable,
      );
}
