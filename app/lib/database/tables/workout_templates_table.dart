part of '../app_database.dart';

@DataClassName('WorkoutTemplateRow')
class WorkoutTemplatesTable extends Table {
  TextColumn get id => text().clientDefault(() => uuid.v7())();
  TextColumn get title => text().nullable()();
  TextColumn get description => text().nullable()();

  @override
  String get tableName => 'workout_templates';

  @override
  Set<Column> get primaryKey => {id};
}
