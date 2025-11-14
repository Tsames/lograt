import 'package:lograt/data/entities/exercise_set.dart';
import 'package:lograt/data/models/exercise_set_model.dart';
import 'package:sqflite/sqflite.dart';

import '../database/app_database.dart';

class ExerciseSetDao {
  final AppDatabase _db;
  static const String _tableName = AppDatabase.exerciseSetsTableName;

  ExerciseSetDao(this._db);

  /// Retrieves an exercise set from the database by its id.
  ///
  /// Optionally accepts a [txn] parameter to execute the query within an existing
  /// database transaction. If no transaction is provided, the query runs directly
  /// against the database.
  ///
  /// Returns the [ExerciseSetModel] if found, or `null` if no exercise set
  /// with the given [id] exists.
  Future<ExerciseSetModel?> getById(String id, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;

    final maps = await executor.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return ExerciseSetModel.fromMap(maps.first);
  }

  /// Retrieves a list of all exercise sets associated with a given exercise in order from the database.
  ///
  /// Optionally accepts a [txn] parameter to execute the query within an existing
  /// database transaction. If no transaction is provided, the query runs directly
  /// against the database.
  ///
  /// Returns an empty `List<ExerciseSetModel>` if none with the given [id] exists.
  Future<List<ExerciseSetModel>> getByExerciseId(
    String exerciseId, [
    Transaction? txn,
  ]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    final maps = await executor.query(
      _tableName,
      where: 'exercise_id = ?',
      whereArgs: [exerciseId],
      orderBy: 'set_order ASC',
    );

    return maps.map((map) => ExerciseSetModel.fromMap(map)).nonNulls.toList();
  }

  /// Inserts a new exercise set into the database.
  ///
  /// Optionally accepts a [txn] parameter to execute the insert within an existing
  /// database transaction. If no transaction is provided, the insert runs directly
  /// against the database.
  ///
  /// Returns the auto-generated ID of the newly inserted exercise set.
  Future<int> insert(ExerciseSetModel set, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    return await executor.insert(
      _tableName,
      set.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  /// Batch inserts a list of sets into the database.
  ///
  /// Optionally accepts a [txn] parameter to execute the insert within an existing
  /// database transaction. If no transaction is provided, the insert runs directly
  /// against the database.
  Future<void> batchInsert(
    List<ExerciseSetModel> sets, [
    Transaction? txn,
  ]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    final batch = executor.batch();

    for (final set in sets) {
      batch.insert(_tableName, set.toMap());
    }

    await batch.commit(noResult: true);
  }

  /// Updates an existing exercise set in the database.
  ///
  /// The [ExerciseSet] must have a non-null ID.
  ///
  /// Optionally accepts a [txn] parameter to execute the update within an existing
  /// database transaction. If no transaction is provided, the update runs directly
  /// against the database.
  ///
  /// Returns true if a row was updated correctly, and false if no row was updated.
  ///
  /// Throws an [ArgumentError] if the exercise type ID is `null`.
  Future<bool> update(ExerciseSetModel set, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    return await executor.update(
          _tableName,
          set.toMap(),
          where: 'id = ?',
          whereArgs: [set.id],
        ) ==
        1;
  }

  /// Deletes an exercise set from the database by its ID.
  ///
  /// Optionally accepts a [txn] parameter to execute the delete within an existing
  /// database transaction. If no transaction is provided, the delete runs directly
  /// against the database.
  ///
  /// Returns the true if the row was correctly deleted, and false if no row was deleted.
  ///
  /// Throws an [Exception] if the exercise set is referenced by any workout exercises,
  /// due to the RESTRICT foreign key constraint.
  Future<bool> delete(String setId, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    try {
      return await executor.delete(
            _tableName,
            where: 'id = ?',
            whereArgs: [setId],
          ) ==
          1;
    } catch (e) {
      throw Exception(
        'Cannot delete an exercise set that is in use by an exercise. \n$e',
      );
    }
  }

  /// Deletes all exercise sets from the database that are associated with the given exercise id.
  ///
  /// Optionally accepts a [txn] parameter to execute the delete within an existing
  /// database transaction. If no transaction is provided, the delete runs directly
  /// against the database.
  ///
  /// Returns the number of rows that were deleted.
  Future<int> deleteByExerciseId(String exerciseId, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    return await executor.delete(
      _tableName,
      where: 'exercise_id = ?',
      whereArgs: [exerciseId],
    );
  }

  Future<void> clearTable() async {
    final db = await _db.database;
    await db.delete(_tableName);
  }
}
