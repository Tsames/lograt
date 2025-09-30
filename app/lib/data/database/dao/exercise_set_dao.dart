import 'package:lograt/data/models/exercise_set_model.dart';
import 'package:sqflite/sqflite.dart';

import '../app_database.dart';

/// Data Access Object operations for an ExerciseSet
/// This class handles all database operations related to exercise sets
class ExerciseSetDao {
  final AppDatabase _db;
  static const String _tableName = AppDatabase.exerciseSetsTableName;

  ExerciseSetDao(this._db);

  /// Get an exercise set by its ID
  /// Returns null if no exercise set with the given ID exists
  Future<ExerciseSetModel?> getById(int setId) async {
    final database = await _db.database;
    final maps = await database.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [setId],
    );

    if (maps.isEmpty) return null;
    return ExerciseSetModel.fromMap(maps.first);
  }

  /// Get all exercise sets for a specific exercise, ordered by their sequence
  Future<List<ExerciseSetModel>> getByExerciseId(int exerciseId) async {
    final database = await _db.database;
    final maps = await database.query(
      _tableName,
      where: 'exercise_id = ?',
      whereArgs: [exerciseId],
      orderBy: 'set_order ASC',
    );

    return maps.map((map) => ExerciseSetModel.fromMap(map)).toList();
  }

  /// For batch retrieval of all sets associated with a list of exercise ID
  Future<List<ExerciseSetModel>> getBatchByExerciseIds(
    List<int> exerciseIds,
  ) async {
    if (exerciseIds.isEmpty) return <ExerciseSetModel>[];

    final db = await _db.database;

    final placeholders = List.filled(exerciseIds.length, '?').join(",");
    final result = await db.query(
      _tableName,
      where: 'exercise_id IN ($placeholders)',
      whereArgs: exerciseIds,
      orderBy: 'exercise_id DESC',
    );

    return result.map((row) => ExerciseSetModel.fromMap(row)).toList();
  }

  /// Insert a new exercise set
  /// Returns the ID of the newly inserted exercise set
  /// Will replace existing values if the id already exists
  Future<int> insert(ExerciseSetModel set) async {
    final database = await _db.database;
    return await database.insert(
      _tableName,
      set.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Batch insert a list of [ExerciseSetModel]
  Future<void> batchInsertWithTransaction({
    required List<ExerciseSetModel> sets,
    required Transaction txn,
  }) async {
    final batch = txn.batch();

    for (final set in sets) {
      batch.insert(_tableName, set.toMap());
    }

    await batch.commit(noResult: true);
  }

  /// Update an existing exercise set
  /// Returns the number of rows affected (should be 1 for success)
  Future<int> update(ExerciseSetModel set) async {
    if (set.databaseId == null) {
      throw ArgumentError('Cannot update exercise without an ID');
    }

    final database = await _db.database;
    return await database.update(
      _tableName,
      set.toMap(),
      where: 'id = ?',
      whereArgs: [set.databaseId],
    );
  }

  /// Delete an exercise set
  Future<int> delete(int setId) async {
    final database = await _db.database;
    return await database.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [setId],
    );
  }

  /// Delete all exercise sets for a specific exercise
  /// This is typically called when an exercise is deleted
  Future<int> deleteByExerciseId(int exerciseId) async {
    final database = await _db.database;
    return await database.delete(
      _tableName,
      where: 'exercise_id = ?',
      whereArgs: [exerciseId],
    );
  }
}
