part of '../app_database.dart';

@DataClassName('SetRow')
class SetsTable extends Table {
  TextColumn get id => text().clientDefault(() => uuid.v7())();

  IntColumn get setOrder => integer()();

  TextColumn get exerciseInstanceId => text().references(
    ExerciseInstanceTable,
    #id,
    onDelete: KeyAction.cascade,
  )();

  TextColumn get setType => text().nullable().map(const SetTypeConverter())();

  RealColumn get weight => real().nullable()();

  TextColumn get units => text().nullable().map(const UnitsConverter())();

  IntColumn get reps => integer().nullable()();

  IntColumn get restTimeSeconds => integer().nullable()();

  @override
  String get tableName => 'sets';

  @override
  Set<Column> get primaryKey => {id};
}
