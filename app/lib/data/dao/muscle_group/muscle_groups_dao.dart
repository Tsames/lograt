import 'package:lograt/data/dao/model_dao.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/muscle_group/muscle_group_model.dart';
import 'package:sqflite/sqflite.dart';

class MuscleGroupDao extends ModelDao<MuscleGroupModel> {
  MuscleGroupDao(AppDatabase db)
    : super(
        db: db,
        modelName: 'muscle group',
        tableName: MuscleGroupModel.tableName,
        modelIdFieldName: MuscleGroupModel.idFieldName,
        fromMap: MuscleGroupModel.fromMap,
      );

  Future<MuscleGroupModel?> getByLabel(String label, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await db.database;

    final maps = await executor.query(
      tableName,
      where: '${MuscleGroupModel.labelFieldName} = ?',
      whereArgs: [label],
    );

    if (maps.isEmpty) return null;
    return MuscleGroupModel.fromMap(maps.first);
  }

  Future<List<MuscleGroupModel>> getMuscleGroupsByIds(
    List<String> muscleGroupIds, [
    Transaction? txn,
  ]) async {
    if (muscleGroupIds.isEmpty) {
      throw Exception(
        'Cannot retrieve muscle groups by ids if no ids are given.',
      );
    }
    final DatabaseExecutor executor = txn ?? await db.database;

    final placeholders = List.filled(muscleGroupIds.length, '?').join(', ');
    final records = await executor.query(
      tableName,
      where: '${MuscleGroupModel.idFieldName} IN ($placeholders)',
      whereArgs: [...muscleGroupIds],
    );

    return records
        .map((record) => MuscleGroupModel.fromMap(record))
        .nonNulls
        .toList();
  }

  Future<List<MuscleGroupModel>> getAllMuscleGroupsPaginatedSorted({
    int? limit,
    int? offset,
    Transaction? txn,
  }) async {
    final DatabaseExecutor executor = txn ?? await db.database;

    final maps = await executor.query(
      tableName,
      orderBy: '${MuscleGroupModel.labelFieldName} ASC',
      limit: limit,
      offset: offset,
    );

    return maps.map((map) => MuscleGroupModel.fromMap(map)).nonNulls.toList();
  }
}
