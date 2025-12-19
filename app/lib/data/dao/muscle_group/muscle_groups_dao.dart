import 'package:lograt/data/dao/model_dao.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/muscle_group/muscle_group_model.dart';
import 'package:sqflite/sqflite.dart';

class MuscleGroupDao extends ModelDao<MuscleGroupModel> {
  MuscleGroupDao(AppDatabase db)
    : super(
        db: db,
        modelName: 'muscle group',
        tableName: muscleGroupsTable,
        modelIdFieldName: MuscleGroupFields.id,
        fromMap: MuscleGroupModel.fromMap,
      );

  Future<MuscleGroupModel?> getByName(String label, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await db.database;

    final maps = await executor.query(
      tableName,
      where: '${MuscleGroupFields.label} = ?',
      whereArgs: [label],
    );

    if (maps.isEmpty) return null;
    return MuscleGroupModel.fromMap(maps.first);
  }

  Future<List<MuscleGroupModel>> getMuscleGroupsByIds(
    List<String> workoutIds, [
    Transaction? txn,
  ]) async {
    if (workoutIds.isEmpty) {
      throw Exception(
        'Cannot retrieve muscle groups by ids if no ids are given.',
      );
    }
    final DatabaseExecutor executor = txn ?? await db.database;

    final placeholders = List.filled(workoutIds.length, '?').join(', ');
    final records = await executor.query(
      tableName,
      where: '${MuscleGroupFields.id} IN ($placeholders)',
      whereArgs: [...workoutIds],
    );

    return records
        .map((record) => MuscleGroupModel.fromMap(record))
        .nonNulls
        .toList();
  }

  Future<List<MuscleGroupModel>> getAllMuscleGroupsPaginated({
    int? limit,
    int? offset,
    Transaction? txn,
  }) async {
    final DatabaseExecutor executor = txn ?? await db.database;

    final maps = await executor.query(
      tableName,
      orderBy: '${MuscleGroupFields.label} ASC',
      limit: limit,
      offset: offset,
    );

    return maps.map((map) => MuscleGroupModel.fromMap(map)).nonNulls.toList();
  }
}
