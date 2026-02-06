import 'package:lograt/data/dao/model_dao.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/workouts/exercise_model.dart';
import 'package:lograt/data/models/workouts/workout_model.dart';
import 'package:sqflite/sqflite.dart';

class ExerciseDao extends ModelDao<ExerciseModel> {
  ExerciseDao(AppDatabase db)
    : super(
        db: db,
        modelName: 'exercise',
        tableName: exercisesTable,
        modelIdFieldName: ExerciseFields.id,
        fromMap: ExerciseModel.fromMap,
      );

  Future<List<ExerciseModel>> getAllExercisesWithWorkoutId(
    String workoutId, [
    Transaction? txn,
  ]) async {
    final DatabaseExecutor executor = txn ?? await db.database;
    final maps = await executor.query(
      tableName,
      where: '${ExerciseFields.workoutId} = ?',
      whereArgs: [workoutId],
    );

    return maps.map((map) => ExerciseModel.fromMap(map)).nonNulls.toList();
  }

  Future<ExerciseModel?> getMostRecentExerciseThatHasExerciseTypeId(
    String exerciseTypeId, [
    Transaction? txn,
  ]) async {
    final DatabaseExecutor executor = txn ?? await db.database;

    final maps = await executor.rawQuery(
      '''
    SELECT e.*
    FROM $tableName e
    INNER JOIN ${WorkoutModel.tableName} w ON e.${ExerciseFields.workoutId} = w.${WorkoutModel.idFieldName}
    WHERE e.${ExerciseFields.exerciseTypeId} = ?
    ORDER BY w.${WorkoutModel.dateFieldName} DESC, e.${ExerciseFields.order} DESC
    LIMIT 1
    ''',
      [exerciseTypeId],
    );

    if (maps.isEmpty) return null;
    return ExerciseModel.fromMap(maps.first);
  }
}
