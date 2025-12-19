import 'package:lograt/data/dao/model_dao.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/templates/workout_template_model.dart';
import 'package:sqflite/sqflite.dart';

class WorkoutTemplateDao extends ModelDao<WorkoutTemplateModel> {
  WorkoutTemplateDao(AppDatabase db)
    : super(
        db: db,
        modelName: 'workout template',
        tableName: workoutTemplatesTable,
        modelIdFieldName: WorkoutTemplateFields.id,
        fromMap: WorkoutTemplateModel.fromMap,
      );

  Future<List<WorkoutTemplateModel>> getWorkoutTemplatesByIds(
    List<String> templateIds, [
    Transaction? txn,
  ]) async {
    if (templateIds.isEmpty) {
      throw Exception(
        'Cannot retrieve workout templates by ids if no ids are given.',
      );
    }
    final DatabaseExecutor executor = txn ?? await db.database;

    final placeholders = List.filled(templateIds.length, '?').join(', ');
    final records = await executor.query(
      tableName,
      where: '${WorkoutTemplateFields.id} IN ($placeholders)',
      whereArgs: [...templateIds],
    );

    return records
        .map((record) => WorkoutTemplateModel.fromMap(record))
        .nonNulls
        .toList();
  }

  /// Retrieves a list of workout templates ordered by date (DESC) without any associated exercise or set templates
  Future<List<WorkoutTemplateModel>> getTemplatePaginatedOrderedByDate({
    int? limit,
    int? offset,
    Transaction? txn,
  }) async {
    final DatabaseExecutor executor = txn ?? await db.database;

    final maps = await executor.query(
      tableName,
      orderBy: '${WorkoutTemplateFields.date} DESC',
      limit: limit,
      offset: offset,
    );

    return maps
        .map((map) => WorkoutTemplateModel.fromMap(map))
        .nonNulls
        .toList();
  }
}
