import 'package:lograt/data/dao/model_dao.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/workouts/exercise_set_model.dart';
import 'package:sqflite/sqflite.dart';

class ExerciseSetDao extends ModelDao<ExerciseSetModel> {
  ExerciseSetDao(AppDatabase db)
    : super(
        db: db,
        modelName: 'set',
        tableName: ExerciseSetModel.tableName,
        modelIdFieldName: ExerciseSetModel.idFieldName,
        fromMap: ExerciseSetModel.fromMap,
      );

  Future<List<ExerciseSetModel>> getAllSetsWithExerciseId(
    String exerciseId, [
    Transaction? txn,
  ]) async {
    final DatabaseExecutor executor = txn ?? await db.database;
    final maps = await executor.query(
      tableName,
      where: '${ExerciseSetModel.exerciseIdFieldName} = ?',
      whereArgs: [exerciseId],
      orderBy: '${ExerciseSetModel.orderFieldName} ASC',
    );

    return maps.map((map) => ExerciseSetModel.fromMap(map)).nonNulls.toList();
  }
}
