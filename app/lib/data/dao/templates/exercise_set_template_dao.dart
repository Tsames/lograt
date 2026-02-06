import 'package:lograt/data/dao/model_dao.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/templates/exercise_set_template_model.dart';
import 'package:sqflite/sqflite.dart';

class ExerciseSetTemplateDao extends ModelDao<ExerciseSetTemplateModel> {
  ExerciseSetTemplateDao(AppDatabase db)
    : super(
        db: db,
        modelName: 'exercise set template',
        tableName: ExerciseSetTemplateModel.tableName,
        modelIdFieldName: ExerciseSetTemplateModel.idFieldName,
        fromMap: ExerciseSetTemplateModel.fromMap,
      );

  Future<List<ExerciseSetTemplateModel>>
  getAllExerciseSetTemplatesWithExerciseTemplateId(
    String exerciseTemplateId, [
    Transaction? txn,
  ]) async {
    final DatabaseExecutor executor = txn ?? await db.database;
    final maps = await executor.query(
      tableName,
      where: '${ExerciseSetTemplateModel.exerciseTemplateIdFieldName} = ?',
      whereArgs: [exerciseTemplateId],
    );

    return maps
        .map((map) => ExerciseSetTemplateModel.fromMap(map))
        .nonNulls
        .toList();
  }
}
