part of '../app_database.dart';

@DataClassName('MuscleGroupRow')
class MuscleGroupsTable extends Table {
  TextColumn get id => text().clientDefault(() => uuid.v7())();

  TextColumn get label => text().unique()();

  TextColumn get description => text().nullable()();

  @override
  String get tableName => 'muscle_groups';

  @override
  Set<Column> get primaryKey => {id};
}
