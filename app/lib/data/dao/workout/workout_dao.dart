import 'package:lograt/data/dao/model_dao.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/workouts/workout_model.dart';
import 'package:sqflite/sqflite.dart';

class WorkoutDao extends ModelDao<WorkoutModel> {
  WorkoutDao(AppDatabase db)
    : super(
        db: db,
        modelName: 'workout',
        tableName: WorkoutModel.tableName,
        modelIdFieldName: WorkoutModel.idFieldName,
        fromMap: WorkoutModel.fromMap,
      );

  /// Get a list of the workouts of length [limit] starting from [offset]
  /// Workouts returned will be in order of creation date DESC
  Future<List<WorkoutModel>> getAllPaginatedOrderedByDate({
    int? limit,
    int? offset,
    Transaction? txn,
  }) async {
    final DatabaseExecutor executor = txn ?? await db.database;

    final maps = await executor.query(
      tableName,
      orderBy: '${WorkoutModel.dateFieldName} DESC',
      limit: limit,
      offset: offset,
    );

    return maps.map((map) => WorkoutModel.fromMap(map)).nonNulls.toList();
  }
}
