import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/muscle_group_model.dart';
import 'package:sqflite/sqflite.dart';

class MuscleGroupDao {
  final AppDatabase _db;

  MuscleGroupDao(this._db);

  Future<MuscleGroupModel?> getById(String id, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    final maps = await executor.query(
      muscleGroupTable,
      where: '${MuscleGroupFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return MuscleGroupModel.fromMap(maps.first);
  }

  Future<MuscleGroupModel?> getByName(String label, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;

    final maps = await executor.query(
      muscleGroupTable,
      where: '${MuscleGroupFields.label} = ?',
      whereArgs: [label],
    );

    if (maps.isEmpty) return null;
    return MuscleGroupModel.fromMap(maps.first);
  }

  Future<List<MuscleGroupModel>> getAllMuscleGroups({
    int? limit,
    int? offset,
    Transaction? txn,
  }) async {
    final DatabaseExecutor executor = txn ?? await _db.database;

    final maps = await executor.query(
      muscleGroupTable,
      orderBy: '${MuscleGroupFields.label} ASC',
      limit: limit,
      offset: offset,
    );

    return maps.map((map) => MuscleGroupModel.fromMap(map)).nonNulls.toList();
  }

  Future<void> insert(MuscleGroupModel muscleGroup, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    await executor.insert(
      muscleGroupTable,
      muscleGroup.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<int> update(MuscleGroupModel muscleGroup, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    return await executor.update(
      muscleGroupTable,
      muscleGroup.toMap(),
      where: '${MuscleGroupFields.id} = ?',
      whereArgs: [muscleGroup.id],
    );
  }

  Future<int> delete(String id, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    return await executor.delete(
      muscleGroupTable,
      where: '${MuscleGroupFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearTable([Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    await executor.delete(muscleGroupTable);
  }
}
