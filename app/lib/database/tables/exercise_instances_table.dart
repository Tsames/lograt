part of '../app_database.dart';

@DataClassName('ExerciseInstanceRow')
class ExerciseInstanceTable extends Table {
  TextColumn get id => text().clientDefault(() => uuid.v7())();
  IntColumn get exerciseOrder => integer()();
  TextColumn get workoutId =>
      text().references(WorkoutsTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get exerciseId => text()
      .nullable()
      .references(ExercisesTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get notes => text().nullable()();

  @override
  String get tableName => 'exercise_instances';

  @override
  Set<Column> get primaryKey => {id};
}
