import 'package:sqflite/sqflite.dart';
import '../../models/workout_model.dart';
import '../app_database.dart';

class WorkoutDao {
  final AppDatabase _db;
  static const _tableName = 'workouts';

  WorkoutDao(this._db);

  Future<List<WorkoutModel>> getWorkouts() async {
    final db = await _db.database;
    final List<Map<String, Object?>> workoutMaps = await db.query(_tableName);
    return workoutMaps.map((map) => WorkoutModel.fromMap(map)).toList();
  }

  Future<void> insertWorkout(WorkoutModel workout) async {
    final db = await _db.database;
    await db.insert(_tableName, workout.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateWorkout(WorkoutModel workout) async {
    final db = await _db.database;
    db.update(_tableName, workout.toMap(), where: 'id = ?', whereArgs: [workout.id]);
  }

  Future<void> deleteWorkout(int id) async {
    final db = await _db.database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearTable() async {
    final db = await _db.database;
    await db.delete(_tableName);
  }
}
