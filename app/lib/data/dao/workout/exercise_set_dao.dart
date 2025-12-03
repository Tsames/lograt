import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/workouts/exercise_set_model.dart';
import 'package:sqflite/sqflite.dart';

class ExerciseSetDao {
  final AppDatabase _db;

  ExerciseSetDao(this._db);

  Future<ExerciseSetModel?> getById(String id, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;

    final maps = await executor.query(
      setsTable,
      where: '${ExerciseSetFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return ExerciseSetModel.fromMap(maps.first);
  }

  Future<List<ExerciseSetModel>> getAllSetsWithExerciseId(
    String exerciseId, [
    Transaction? txn,
  ]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    final maps = await executor.query(
      setsTable,
      where: '${ExerciseSetFields.exerciseId} = ?',
      whereArgs: [exerciseId],
      orderBy: '${ExerciseSetFields.order} ASC',
    );

    return maps.map((map) => ExerciseSetModel.fromMap(map)).nonNulls.toList();
  }

  Future<int> insert(ExerciseSetModel set, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    return await executor.insert(
      setsTable,
      set.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<void> batchInsert(
    List<ExerciseSetModel> sets, [
    Transaction? txn,
  ]) async {
    if (sets.isEmpty) return;

    final DatabaseExecutor executor = txn ?? await _db.database;
    final batch = executor.batch();

    for (final set in sets) {
      batch.insert(
        setsTable,
        set.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<void> update(ExerciseSetModel set, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    final rowsUpdated = await executor.update(
      setsTable,
      set.toMap(),
      where: '${ExerciseSetFields.id} = ?',
      whereArgs: [set.id],
    );
    if (rowsUpdated == 0) {
      throw Exception('Cannot update set $set: does not exist');
    }
  }

  Future<void> batchUpdate(
    List<ExerciseSetModel> sets, [
    Transaction? txn,
  ]) async {
    if (sets.isEmpty) return;

    Future<void> executeUpdate(Transaction transaction) async {
      for (final set in sets) {
        final exists = await getById(set.id, transaction);
        if (exists == null) {
          throw Exception('Cannot update set $set: does not exist');
        }
      }

      final batch = transaction.batch();
      for (final set in sets) {
        batch.update(
          setsTable,
          set.toMap(),
          where: '${ExerciseSetFields.id} = ?',
          whereArgs: [set.id],
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

  Future<void> delete(String setId, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    final rowsDeleted = await executor.delete(
      setsTable,
      where: '${ExerciseSetFields.id} = ?',
      whereArgs: [setId],
    );
    if (rowsDeleted == 0) {
      throw Exception('Cannot delete set $setId: does not exist');
    }
  }

  Future<void> clearTable([Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    await executor.delete(setsTable);
  }
}
