part of '../app_database.dart';

@DataClassName('WorkoutTemplateSetRow')
class WorkoutTemplateSetsTable extends Table {
  TextColumn get id => text().clientDefault(() => uuid.v7())();
  TextColumn get templateId =>
      text().references(WorkoutTemplatesTable, #id, onDelete: KeyAction.cascade)();
  IntColumn get exerciseOrder => integer()();
  TextColumn get exerciseTypeId => text()
      .nullable()
      .references(ExercisesTable, #id, onDelete: KeyAction.setNull)();
  IntColumn get setOrder => integer()();
  TextColumn get setType => text().nullable().map(const SetTypeConverter())();
  TextColumn get units => text().nullable().map(const UnitsConverter())();

  @override
  String get tableName => 'workout_template_sets';

  @override
  Set<Column> get primaryKey => {id};
}
