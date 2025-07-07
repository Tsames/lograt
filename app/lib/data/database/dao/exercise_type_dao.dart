import 'package:lograt/data/database/app_database.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/exercise_type_model.dart';

/// Data Access Object for ExerciseType operations
/// This class handles all database operations related to exercise types
class ExerciseTypeDao {
  final AppDatabase _db;
  static const String _tableName = AppDatabase.exerciseTypesTableName;

  ExerciseTypeDao(this._db);

  /// Get an exercise type by its ID
  /// Returns null if no exercise set with the given ID exists
  Future<ExerciseTypeModel?> getById(int id) async {
    final db = await _db.database;
    final maps = await db.query(_tableName, where: 'id = ?', whereArgs: [id]);

    if (maps.isEmpty) return null;
    return ExerciseTypeModel.fromMap(maps.first);
  }

  /// Get an exercise type by its name
  /// Returns null if no exercise set with the given ID exists
  Future<ExerciseTypeModel?> getByName(String name) async {
    final db = await _db.database;
    final maps = await db.query(_tableName, where: 'name = ?', whereArgs: [name]);

    if (maps.isEmpty) return null;
    return ExerciseTypeModel.fromMap(maps.first);
  }

  /// Get all exercise types, ordered by name
  Future<List<ExerciseTypeModel>> getAll() async {
    final db = await _db.database;
    final maps = await db.query(_tableName, orderBy: 'name ASC');

    return maps.map((map) => ExerciseTypeModel.fromMap(map)).toList();
  }

  /// Search exercise types by name (case-insensitive partial match)
  Future<List<ExerciseTypeModel>> searchByName(String searchTerm) async {
    final db = await _db.database;
    final maps = await db.query(_tableName, where: 'name LIKE ?', whereArgs: ['%$searchTerm%'], orderBy: 'name ASC');

    return maps.map((map) => ExerciseTypeModel.fromMap(map)).toList();
  }

  /// Get the count of exercise types
  Future<int> getCount() async {
    final db = await _db.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM $_tableName');
    return result.first['count'] as int;
  }

  /// Check if an exercise type name already exists
  Future<bool> nameExists(String name) async {
    final db = await _db.database;
    final maps = await db.query(_tableName, where: 'name = ?', whereArgs: [name], limit: 1);

    return maps.isNotEmpty;
  }

  /// Insert a new exercise type into the database
  Future<int> insert(ExerciseTypeModel exerciseType) async {
    try {
      final db = await _db.database;
      return await db.insert(
        _tableName,
        exerciseType.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail, // Prevent duplicate names
      );
    } catch (e) {
      // Handle unique constraint violations gracefully
      throw Exception('Failed to insert exercise type: ${e.toString()}');
    }
  }

  Future<int> insertWithTransaction({required ExerciseTypeModel exerciseType, required Transaction txn}) async {
    return await txn.insert(_tableName, exerciseType.toMap());
  }

  /// Update an existing exercise type
  /// Returns the number of rows affected (should be 1 for success)
  Future<int> update(ExerciseTypeModel exerciseType) async {
    if (exerciseType.id == null) {
      throw ArgumentError('Cannot update exercise type without an ID');
    }

    final db = await _db.database;
    return await db.update(_tableName, exerciseType.toMap(), where: 'id = ?', whereArgs: [exerciseType.id]);
  }

  /// Delete an exercise type by ID
  /// Note: This will fail if the exercise type is referenced by any workout exercises
  /// due to the RESTRICT foreign key constraint
  Future<int> delete(int id) async {
    try {
      final db = await _db.database;
      return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw Exception('Cannot delete exercise type that is in use by workouts');
    }
  }
}
