part of '../app_database.dart';

@DataClassName('WorkoutRow')
class WorkoutsTable extends Table {
  TextColumn get id => text().clientDefault(() => uuid.v7())();
  DateTimeColumn get date => dateTime()();
  TextColumn get title => text().nullable()();
  TextColumn get templateId => text()
      .nullable()
      .references(WorkoutTemplatesTable, #id, onDelete: KeyAction.setNull)();
  TextColumn get notes => text().nullable()();

  @override
  String get tableName => 'workouts';

  @override
  Set<Column> get primaryKey => {id};
}
