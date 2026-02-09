import 'package:lograt/data/dao/model_dao.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/templates/exercise_template_model.dart';
import 'package:sqflite/sqflite.dart';

class ExerciseTemplateDao extends ModelDao<ExerciseTemplateModel> {
  ExerciseTemplateDao(AppDatabase db)
    : super(
        db: db,
        modelName: 'exercise template',
        tableName: ExerciseTemplateModel.tableName,
        modelIdFieldName: ExerciseTemplateModel.idFieldName,
        fromMap: ExerciseTemplateModel.fromMap,
      );

  Future<List<ExerciseTemplateModel>>
  getAllExerciseTemplatesWithWorkoutTemplateId(
    String workoutTemplateId, [
    Transaction? txn,
  ]) async {
    final DatabaseExecutor executor = txn ?? await db.database;
    final maps = await executor.query(
      tableName,
      where: '${ExerciseTemplateModel.workoutTemplateIdFieldName} = ?',
      whereArgs: [workoutTemplateId],
    );

    return maps
        .map((map) => ExerciseTemplateModel.fromMap(map))
        .nonNulls
        .toList();
  }
}
