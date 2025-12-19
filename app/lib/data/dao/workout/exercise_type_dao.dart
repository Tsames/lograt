import 'package:lograt/data/dao/model_dao.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/workouts/exercise_type_model.dart';
import 'package:sqflite/sqflite.dart';

class ExerciseTypeDao extends ModelDao<ExerciseTypeModel> {
  ExerciseTypeDao(AppDatabase db)
    : super(
        db: db,
        modelName: 'exercise type',
        tableName: exerciseTypesTable,
        modelIdFieldName: ExerciseTypeFields.id,
        fromMap: ExerciseTypeModel.fromMap,
      );

  Future<List<ExerciseTypeModel>> getAllPaginated({
    int? limit,
    int? offset,
    Transaction? txn,
  }) async {
    final DatabaseExecutor executor = txn ?? await db.database;

    final maps = await executor.query(
      tableName,
      orderBy: '${ExerciseTypeFields.name} ASC',
      limit: limit,
      offset: offset,
    );

    return maps.map((map) => ExerciseTypeModel.fromMap(map)).nonNulls.toList();
  }

  Future<ExerciseTypeModel?> getByName(String name, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await db.database;

    final maps = await executor.query(
      tableName,
      where: '${ExerciseTypeFields.name} = ?',
      whereArgs: [name],
    );

    if (maps.isEmpty) return null;
    return ExerciseTypeModel.fromMap(maps.first);
  }
}
