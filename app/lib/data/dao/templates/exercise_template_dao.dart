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
    String workoutTemplateId, [
    Transaction? txn,
  ]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    final maps = await executor.query(
      exerciseTemplatesTable,
      where: '${ExerciseTemplateFields.workoutTemplateId} = ?',
      whereArgs: [workoutTemplateId],
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
    List<ExerciseTemplateModel> exerciseTemplates, [
    Transaction? txn,
  ]) async {
    if (exerciseTemplates.isEmpty) return;

    final DatabaseExecutor executor = txn ?? await _db.database;
    final batch = executor.batch();

    for (final exercise in exerciseTemplates) {
      batch.insert(
        exerciseTemplatesTable,
        exercise.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<void> update(
    ExerciseTemplateModel exerciseTemplate, [
    Transaction? txn,
  ]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    final rowsUpdated = await executor.update(
      exerciseTemplatesTable,
      exerciseTemplate.toMap(),
      where: '${ExerciseTemplateFields.id} = ?',
      whereArgs: [exerciseTemplate.id],
    );
    if (rowsUpdated == 0) {
      throw Exception(
        'Cannot update exercise template $exerciseTemplate: does not exist',
      );
    }
  }

  Future<void> batchUpdate(
    List<ExerciseTemplateModel> exerciseTemplates, [
    Transaction? txn,
  ]) async {
    if (exerciseTemplates.isEmpty) return;

    Future<void> executeUpdate(Transaction transaction) async {
      for (final template in exerciseTemplates) {
        final exists = await getById(template.id, transaction);
        if (exists == null) {
          throw Exception(
            'Cannot update exercise template $template: does not exist',
          );
        }
      }

      final batch = transaction.batch();
      for (final exercise in exerciseTemplates) {
        batch.update(
          exerciseTemplatesTable,
          exercise.toMap(),
          where: '${ExerciseTemplateFields.id} = ?',
          whereArgs: [exercise.id],
        );
      }
      await batch.commit(noResult: true);
    }

    // If no transaction provided, create one
    if (txn != null) {
      await executeUpdate(txn);
    } else {
      final db = await _db.database;
      await db.transaction((transaction) async {
        await executeUpdate(transaction);
      });
    }
  }

  Future<void> delete(String id, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    final rowsDeleted = await executor.delete(
      exerciseTemplatesTable,
      where: '${ExerciseTemplateFields.id} = ?',
      whereArgs: [id],
    );
    if (rowsDeleted == 0) {
      throw Exception('Cannot delete exercise template $id: does not exist');
    }
  }

  Future<void> clearTable([Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    await executor.delete(exerciseTemplatesTable);
  }
}
