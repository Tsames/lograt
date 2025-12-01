import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/templates/workout_template_model.dart';
import 'package:sqflite/sqflite.dart';

class WorkoutTemplateDao {
  final AppDatabase _db;

  WorkoutTemplateDao(this._db);

  Future<WorkoutTemplateModel?> getById(String id, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    final maps = await executor.query(
      workoutTemplatesTable,
      where: '${WorkoutTemplateFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return WorkoutTemplateModel.fromMap(maps.first);
  }

  /// Retrieves a list of workout templates ordered by date (DESC) without any associated exercise or set templates
  Future<List<WorkoutTemplateModel>> getTemplateSummaries({
    int? limit,
    int? offset,
    Transaction? txn,
  }) async {
    final DatabaseExecutor executor = txn ?? await _db.database;

    final maps = await executor.query(
      workoutTemplatesTable,
      orderBy: '${WorkoutTemplateFields.date} DESC',
      limit: limit,
      offset: offset,
    );

    return maps
        .map((map) => WorkoutTemplateModel.fromMap(map))
        .nonNulls
        .toList();
  }

  Future<void> insert(WorkoutTemplateModel template, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    await executor.insert(
      workoutTemplatesTable,
      template.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<int> update(WorkoutTemplateModel template, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    return await executor.update(
      workoutTemplatesTable,
      template.toMap(),
      where: '${WorkoutTemplateFields.id} = ?',
      whereArgs: [template.id],
    );
  }

  Future<int> delete(String id, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    return await executor.delete(
      workoutTemplatesTable,
      where: '${WorkoutTemplateFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearTable(Transaction? txn) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    await executor.delete(workoutTemplatesTable);
  }
}
