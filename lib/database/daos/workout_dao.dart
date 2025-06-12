import 'package:lograt/database/app_database.dart';
import 'package:sqflite/sqflite.dart';

import '../models/workout.dart';

class WorkoutDao {
  static const _tableName = AppDatabase.workoutsTable;
  WorkoutDao();

  Future<List<Workout>> getWorkouts() async {
    final db = await AppDatabase().database;
    final List<Map<String, Object?>> workoutMaps = await db.query(_tableName);
    return workoutMaps.map((map) => Workout.fromMap(map)).toList();
  }

  Future<void> insertWorkout(Workout workout) async {
    final db = await AppDatabase().database;
    await db.insert(_tableName, workout.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateWorkout(Workout workout) async {
    final db = await AppDatabase().database;
    db.update(_tableName, workout.toMap(), where: 'id = ?', whereArgs: [workout.id]);
  }

  Future<void> deleteWorkout(int id) async {
    final db = await AppDatabase().database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearTable() async {
    final db = await AppDatabase().database;
    await db.delete(_tableName);
  }
}
