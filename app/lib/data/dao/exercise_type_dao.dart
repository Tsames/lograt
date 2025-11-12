import 'package:lograt/data/database/app_database.dart';
import 'package:sqflite/sqflite.dart';

import '../models/exercise_type_model.dart';

class ExerciseTypeDao {
  final AppDatabase _db;
  static const String _tableName = AppDatabase.exerciseTypesTableName;

  ExerciseTypeDao(this._db);

  /// Retrieves an exercise type from the database by its id.
  ///
  /// Optionally accepts a [txn] parameter to execute the query within an existing
  /// database transaction. If no transaction is provided, the query runs directly
  /// against the database.
  ///
  /// Returns the [ExerciseTypeModel] if found, or `null` if no exercise type
  /// with the given [id] exists.
  Future<ExerciseTypeModel?> getById(int id, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;

    final maps = await executor.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return ExerciseTypeModel.fromMap(maps.first);
  }

  /// Retrieves an exercise type from the database by its name.
  ///
  /// Optionally accepts a [txn] parameter to execute the query within an existing
  /// database transaction. If no transaction is provided, the query runs directly
  /// against the database.
  ///
  /// Returns the [ExerciseTypeModel] if found, or `null` if no exercise type
  /// with the given [name] exists.
  Future<ExerciseTypeModel?> getByName(String name, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;

    final maps = await executor.query(
      _tableName,
      where: 'name = ?',
      whereArgs: [name],
    );

    if (maps.isEmpty) return null;
    return ExerciseTypeModel.fromMap(maps.first);
  }

  /// Retrieves all exercise types from the database, ordered alphabetically by name.
  ///
  /// Optionally accepts [limit] and [offset] parameters for pagination.
  ///
  /// Optionally accepts a [txn] parameter to execute the query within an existing
  /// database transaction. If no transaction is provided, the query runs directly
  /// against the database.
  ///
  /// Returns a list of [ExerciseTypeModel] instances matching the query parameters,
  /// or an empty list if none exist.
  Future<List<ExerciseTypeModel>> getAll({
    int? limit,
    int? offset,
    Transaction? txn,
  }) async {
    final DatabaseExecutor executor = txn ?? await _db.database;

    final maps = await executor.query(
      _tableName,
      orderBy: 'name ASC',
      limit: limit,
      offset: offset,
    );

    return maps.map((map) => ExerciseTypeModel.fromMap(map)).toList();
  }

  /// Inserts a new exercise type into the database.
  ///
  /// Optionally accepts a [txn] parameter to execute the insert within an existing
  /// database transaction. If no transaction is provided, the insert runs directly
  /// against the database.
  ///
  /// Returns the auto-generated ID of the newly inserted exercise type.
  ///
  /// Throws an [Exception] if the insert fails, including cases where an exercise
  /// type with the same name already exists (due to the UNIQUE constraint on the
  /// name column).
  Future<int> insert(ExerciseTypeModel exerciseType, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    try {
      return await executor.insert(
        _tableName,
        exerciseType.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail, // Prevent duplicate names
      );
    } catch (e) {
      // Handle unique constraint violations gracefully
      throw Exception('Failed to insert exercise type: ${e.toString()}');
    }
  }

  /// Updates an existing exercise type in the database.
  ///
  /// The [exerciseType] must have a non-null ID.
  ///
  /// Optionally accepts a [txn] parameter to execute the update within an existing
  /// database transaction. If no transaction is provided, the update runs directly
  /// against the database.
  ///
  /// Returns true if a row was updated correctly, and false if no row was updated.
  ///
  /// Throws an [ArgumentError] if the exercise type ID is `null`.
  Future<bool> updateById(
    ExerciseTypeModel exerciseType, [
    Transaction? txn,
  ]) async {
    if (exerciseType.id == null) {
      throw ArgumentError(
        'Cannot update exercise type without an ID: ${exerciseType.toString()}',
      );
    }

    final DatabaseExecutor executor = txn ?? await _db.database;
    return await executor.update(
          _tableName,
          exerciseType.toMap(),
          where: 'id = ?',
          whereArgs: [exerciseType.id],
        ) ==
        1;
  }

  /// Deletes an exercise type from the database by its ID.
  ///
  /// Optionally accepts a [txn] parameter to execute the delete within an existing
  /// database transaction. If no transaction is provided, the delete runs directly
  /// against the database.
  ///
  /// Returns the true if the row was correctly deleted, and false if no row was deleted.
  ///
  /// Throws an [Exception] if the exercise type is referenced by any workout exercises,
  /// due to the RESTRICT foreign key constraint.
  Future<bool> deleteById(int id, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    try {
      return await executor.delete(
            _tableName,
            where: 'id = ?',
            whereArgs: [id],
          ) ==
          1;
    } catch (e) {
      throw Exception(
        'Cannot delete exercise type that is in use by workouts. \n$e',
      );
    }
  }
}
