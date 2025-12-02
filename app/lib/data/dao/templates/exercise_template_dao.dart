import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/templates/exercise_template_model.dart';
import 'package:sqflite/sqflite.dart';

class ExerciseTemplateDao {
  final AppDatabase _db;

  ExerciseTemplateDao(this._db);

  Future<ExerciseTemplateModel?> getById(String id, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    final maps = await executor.query(
      exerciseTemplatesTable,
      where: '${ExerciseTemplateFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return ExerciseTemplateModel.fromMap(maps.first);
  }

  Future<List<ExerciseTemplateModel>>
  getAllExerciseTemplatesWithWorkoutTemplateId(
    String workoutId, [
    Transaction? txn,
  ]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    final maps = await executor.query(
      exerciseTemplatesTable,
      where: '${ExerciseTemplateFields.workoutTemplateId} = ?',
      whereArgs: [workoutId],
    );

    return maps
        .map((map) => ExerciseTemplateModel.fromMap(map))
        .nonNulls
        .toList();
  }

  Future<int> insert(ExerciseTemplateModel exercise, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    return await executor.insert(
      exerciseTemplatesTable,
      exercise.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<void> batchInsert(
    List<ExerciseTemplateModel> exercises, [
    Transaction? txn,
  ]) async {
    if (exercises.isEmpty) return;

    final DatabaseExecutor executor = txn ?? await _db.database;
    final batch = executor.batch();

    for (final exercise in exercises) {
      batch.insert(
        exerciseTemplatesTable,
        exercise.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<int> update(ExerciseTemplateModel exercise, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    return await executor.update(
      exerciseTemplatesTable,
      exercise.toMap(),
      where: '${ExerciseTemplateFields.id} = ?',
      whereArgs: [exercise.id],
    );
  }

  Future<void> batchUpdate(
    List<ExerciseTemplateModel> exercises, [
    Transaction? txn,
  ]) async {
    if (exercises.isEmpty) return;

    final DatabaseExecutor executor = txn ?? await _db.database;
    final batch = executor.batch();

    for (final exercise in exercises) {
      batch.update(
        exerciseTemplatesTable,
        exercise.toMap(),
        where: '${ExerciseTemplateFields.id} = ?',
        whereArgs: [exercise.id],
      );
    }

    await batch.commit(noResult: true);
  }

  Future<int> delete(String exerciseId, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    return await executor.delete(
      exerciseTemplatesTable,
      where: '${ExerciseTemplateFields.id} = ?',
      whereArgs: [exerciseId],
    );
  }

  Future<void> clearTable([Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    await executor.delete(exerciseTemplatesTable);
  }
}
