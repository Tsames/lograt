import 'package:lograt/repository/models/workout.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class WorkoutService {
  static final _tableName = "workouts";
  static final WorkoutService instance = WorkoutService._init();
  static Database? _database;

  WorkoutService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _tableName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $_tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, createdOn INTEGER NOT NULL)',
    );
  }

  Future<List<Workout>> getWorkouts() async {
    final db = await instance.database;
    final List<Map<String, Object?>> workoutMaps = await db.query(_tableName);
    return workoutMaps.map((map) => Workout.fromMap(map)).toList();
  }

  Future<void> insertWorkout(Workout workout) async {
    final db = await instance.database;
    await db.insert(_tableName, workout.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateWorkout(Workout workout) async {
    final db = await instance.database;
    db.update(_tableName, workout.toMap(), where: 'id = ?', whereArgs: [workout.id]);
  }

  Future<void> deleteWorkout(int id) async {
    final db = await instance.database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearTable() async {
    final db = await instance.database;
    await db.delete(_tableName);
  }
}
