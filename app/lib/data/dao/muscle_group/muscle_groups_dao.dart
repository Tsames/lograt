import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/muscle_group/muscle_group_model.dart';
import 'package:sqflite/sqflite.dart';

class MuscleGroupDao {
  final AppDatabase _db;
  static const String _tableName = muscleGroupsTable;

  MuscleGroupDao(this._db);

  Future<MuscleGroupModel?> getById(String id, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    final maps = await executor.query(
      _tableName,
      where: '${MuscleGroupFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return MuscleGroupModel.fromMap(maps.first);
  }

  Future<MuscleGroupModel?> getByName(String label, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;

    final maps = await executor.query(
      _tableName,
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
    final DatabaseExecutor executor = txn ?? await _db.database;

    final placeholders = List.filled(workoutIds.length, '?').join(', ');
    final records = await executor.query(
      _tableName,
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
    final DatabaseExecutor executor = txn ?? await _db.database;

    final maps = await executor.query(
      _tableName,
      orderBy: '${MuscleGroupFields.label} ASC',
      limit: limit,
      offset: offset,
    );

    return maps.map((map) => MuscleGroupModel.fromMap(map)).nonNulls.toList();
  }

  Future<void> insert(MuscleGroupModel muscleGroup, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    await executor.insert(
      _tableName,
      muscleGroup.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<void> batchInsert(
    List<MuscleGroupModel> muscleGroups, [
    Transaction? txn,
  ]) async {
    if (muscleGroups.isEmpty) return;

    final DatabaseExecutor executor = txn ?? await _db.database;
    final batch = executor.batch();

    for (final muscleGroup in muscleGroups) {
      batch.insert(
        _tableName,
        muscleGroup.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<void> update(MuscleGroupModel muscleGroup, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    final rowsUpdated = await executor.update(
      _tableName,
      muscleGroup.toMap(),
      where: '${MuscleGroupFields.id} = ?',
      whereArgs: [muscleGroup.id],
    );

    if (rowsUpdated == 0) {
      throw Exception(
        'Cannot update muscle group $muscleGroup: does not exist',
      );
    }
  }

  Future<void> batchUpdate(
    List<MuscleGroupModel> muscleGroups, [
    Transaction? txn,
  ]) async {
    if (muscleGroups.isEmpty) return;

    Future<void> executeUpdate(Transaction transaction) async {
      for (final muscleGroup in muscleGroups) {
        final exists = await getById(muscleGroup.id, transaction);
        if (exists == null) {
          throw Exception(
            'Cannot update muscle group $muscleGroup: does not exist',
          );
        }
      }

      final batch = transaction.batch();
      for (final muscleGroup in muscleGroups) {
        batch.update(
          _tableName,
          muscleGroup.toMap(),
          where: '${MuscleGroupFields.id} = ?',
          whereArgs: [muscleGroup.id],
        );
      }
      await batch.commit(noResult: true);
    }

    // If no transaction provided, create one
    if (txn != null) {
      await executeUpdate(txn);
    } else {
      final db = await _db.database;
      await db.transaction((transaction) async {
        await executeUpdate(transaction);
      });
    }
  }

  Future<void> delete(String id, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    final rowsDeleted = await executor.delete(
      _tableName,
      where: '${MuscleGroupFields.id} = ?',
      whereArgs: [id],
    );

    if (rowsDeleted == 0) {
      throw Exception('Cannot delete muscle group $id: does not exist');
    }
  }

  Future<void> clearTable([Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    await executor.delete(_tableName);
  }
}
