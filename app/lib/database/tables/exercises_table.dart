part of '../app_database.dart';

@DataClassName('ExerciseRow')
class ExercisesTable extends Table {
  TextColumn get id => text().clientDefault(() => uuid.v7())();
  TextColumn get name => text().unique()();
  TextColumn get description => text().nullable()();

  @override
  String get tableName => 'exercises';

  @override
  Set<Column> get primaryKey => {id};
}
