import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/workouts/exercise_type_model.dart';
import 'package:sqflite/sqflite.dart';

class ExerciseTypeDao {
  final AppDatabase _db;

  ExerciseTypeDao(this._db);

  Future<ExerciseTypeModel?> getById(String id, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    final maps = await executor.query(
      exerciseTypesTable,
      where: '${ExerciseTypeFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return ExerciseTypeModel.fromMap(maps.first);
  }

  Future<ExerciseTypeModel?> getByName(String name, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;

    final maps = await executor.query(
      exerciseTypesTable,
      where: '${ExerciseTypeFields.name} = ?',
      whereArgs: [name],
    );

    if (maps.isEmpty) return null;
    return ExerciseTypeModel.fromMap(maps.first);
  }

  Future<List<ExerciseTypeModel>> getAllPaginated({
    int? limit,
    int? offset,
    Transaction? txn,
  }) async {
    final DatabaseExecutor executor = txn ?? await _db.database;

    final maps = await executor.query(
      exerciseTypesTable,
      orderBy: '${ExerciseTypeFields.name} ASC',
      limit: limit,
      offset: offset,
    );

    return maps.map((map) => ExerciseTypeModel.fromMap(map)).nonNulls.toList();
  }

  Future<int> insert(ExerciseTypeModel exerciseType, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    return await executor.insert(
      exerciseTypesTable,
      exerciseType.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail, // Prevent duplicate names
    );
  }

  Future<void> batchInsert(
    List<ExerciseTypeModel> exerciseTypes, [
    Transaction? txn,
  ]) async {
    if (exerciseTypes.isEmpty) return;

    final DatabaseExecutor executor = txn ?? await _db.database;
    final batch = executor.batch();

    for (final exerciseType in exerciseTypes) {
      batch.insert(
        exerciseTypesTable,
        exerciseType.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<void> updateById(
    ExerciseTypeModel exerciseType, [
    Transaction? txn,
  ]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    final rowsUpdated = await executor.update(
      exerciseTypesTable,
      exerciseType.toMap(),
      where: '${ExerciseTypeFields.id} = ?',
      whereArgs: [exerciseType.id],
    );

    if (rowsUpdated == 0) {
      throw Exception(
        'Cannot update exercise type $exerciseType: does not exist',
      );
    }
  }

  Future<void> batchUpdate(
    List<ExerciseTypeModel> exerciseTypes, [
    Transaction? txn,
  ]) async {
    if (exerciseTypes.isEmpty) return;

    Future<void> executeUpdate(Transaction transaction) async {
      for (final exerciseType in exerciseTypes) {
        final exists = await getById(exerciseType.id, transaction);
        if (exists == null) {
          throw Exception(
            'Cannot update exercise $exerciseType: does not exist',
          );
        }
      }

      final batch = transaction.batch();
      for (final exerciseType in exerciseTypes) {
        batch.update(
          exerciseTypesTable,
          exerciseType.toMap(),
          where: '${ExerciseTypeFields.id} = ?',
          whereArgs: [exerciseType.id],
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
      exerciseTypesTable,
      where: '${ExerciseTypeFields.id} = ?',
      whereArgs: [id],
    );
    if (rowsDeleted == 0) {
      throw Exception('Cannot delete exercise type $id: does not exist');
    }
  }

  Future<void> clearTable([Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    await executor.delete(exerciseTypesTable);
  }
}
