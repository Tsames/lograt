import 'package:lograt/repository/models/workout.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class WorkoutService {
  static final _databaseName = "workouts";
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
    final path = join(dbPath, _databaseName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute(
      'CREATE TABLE workouts(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, createdOn INTEGER NOT NULL)',
    );
  }

  Future<List<Workout>> getWorkouts() async {
    final db = await instance.database;
    final List<Map<String, Object?>> workoutMaps = await db.query(_databaseName);
    return workoutMaps.map((map) => Workout.fromMap(map)).toList();
  }

  Future<void> insertWorkout(Workout workout) async {
    final db = await instance.database;
    await db.insert(_databaseName, workout.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
