part of '../app_database.dart';

@DataClassName('MuscleGroupToExerciseRow')
class MuscleGroupsToExercisesTable extends Table {
  TextColumn get id => text().clientDefault(() => uuid.v7())();

  TextColumn get muscleGroupId =>
      text().references(MuscleGroupsTable, #id, onDelete: KeyAction.cascade)();

  TextColumn get exerciseId =>
      text().references(ExercisesTable, #id, onDelete: KeyAction.cascade)();

  @override
  String get tableName => 'muscle_groups_to_exercises';

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {muscleGroupId, exerciseId},
  ];
}
