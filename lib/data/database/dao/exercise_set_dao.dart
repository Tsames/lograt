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
    final maps = await database.query(_tableName, where: 'id = ?', whereArgs: [setId]);

    if (maps.isEmpty) return null;
    return ExerciseSetModel.fromMap(maps.first);
  }

  /// Get all exercise sets for a specific exercise, ordered by their sequence
  /// Returns null if no there are no exercise sets with the given exercise ID
  Future<List<ExerciseSetModel>?> getByExerciseId(int exerciseId) async {
    final database = await _db.database;
    final maps = await database.query(
      _tableName,
      where: 'exercise_id = ?',
      whereArgs: [exerciseId],
      orderBy: 'order ASC',
    );

    final sets = maps.map((map) => ExerciseSetModel.fromMap(map)).toList();
    return sets.isEmpty ? null : sets;
  }

  /// Insert a new exercise set
  /// Returns the ID of the newly inserted exercise set
  /// Will replace existing values if the id already exists
  Future<int> insert(ExerciseSetModel set) async {
    final database = await _db.database;
    return await database.insert(_tableName, set.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Update an existing exercise set
  /// Returns the number of rows affected (should be 1 for success)
  Future<int> update(ExerciseSetModel set) async {
    if (set.id == null) {
      throw ArgumentError('Cannot update exercise without an ID');
    }

    final database = await _db.database;
    return await database.update(_tableName, set.toMap(), where: 'id = ?', whereArgs: [set.id]);
  }

  /// Delete an exercise set
  Future<int> delete(int setId) async {
    final setToDelete = await getById(setId);
    if (setToDelete == null) return 0;

    final database = await _db.database;
    return await database.delete(_tableName, where: 'id = ?', whereArgs: [setToDelete]);
  }

  /// Delete all exercise sets for a specific exercise
  /// This is typically called when an exercise is deleted
  Future<int> deleteByExerciseId(int exerciseId) async {
    final database = await _db.database;
    return await database.delete(_tableName, where: 'exercise_id = ?', whereArgs: [exerciseId]);
  }
}
