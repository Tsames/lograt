import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/templates/exercise_set_template_model.dart';
import 'package:sqflite/sqflite.dart';

class ExerciseSetTemplateDao {
  final AppDatabase _db;
  static const String _tableName = setTemplateTable;

  ExerciseSetTemplateDao(this._db);

  Future<ExerciseSetTemplateModel?> getById(
    String id, [
    Transaction? txn,
  ]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    final maps = await executor.query(
      _tableName,
      where: '${ExerciseSetTemplateFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return ExerciseSetTemplateModel.fromMap(maps.first);
  }

  Future<List<ExerciseSetTemplateModel>>
  getAllExerciseSetTemplatesWithExerciseTemplateId(
    String exerciseTemplateId, [
    Transaction? txn,
  ]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    final maps = await executor.query(
      _tableName,
      where: '${ExerciseSetTemplateFields.exerciseTemplateId} = ?',
      whereArgs: [exerciseTemplateId],
    );

    return maps
        .map((map) => ExerciseSetTemplateModel.fromMap(map))
        .nonNulls
        .toList();
  }

  Future<int> insert(
    ExerciseSetTemplateModel exercise, [
    Transaction? txn,
  ]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    return await executor.insert(
      _tableName,
      exercise.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<void> batchInsert(
    List<ExerciseSetTemplateModel> exerciseSetTemplates, [
    Transaction? txn,
  ]) async {
    if (exerciseSetTemplates.isEmpty) return;

    final DatabaseExecutor executor = txn ?? await _db.database;
    final batch = executor.batch();

    for (final template in exerciseSetTemplates) {
      batch.insert(
        _tableName,
        template.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<void> update(
    ExerciseSetTemplateModel exerciseSetTemplate, [
    Transaction? txn,
  ]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    final rowsUpdated = await executor.update(
      _tableName,
      exerciseSetTemplate.toMap(),
      where: '${ExerciseSetTemplateFields.id} = ?',
      whereArgs: [exerciseSetTemplate.id],
    );
    if (rowsUpdated == 0) {
      throw Exception(
        'Cannot update exercise set template $exerciseSetTemplate: does not exist',
      );
    }
  }

  Future<void> batchUpdate(
    List<ExerciseSetTemplateModel> exerciseSetTemplates, [
    Transaction? txn,
  ]) async {
    if (exerciseSetTemplates.isEmpty) return;

    Future<void> executeUpdate(Transaction transaction) async {
      for (final template in exerciseSetTemplates) {
        final exists = await getById(template.id, transaction);
        if (exists == null) {
          throw Exception(
            'Cannot update exercise set template $template: does not exist',
          );
        }
      }

      final batch = transaction.batch();
      for (final exercise in exerciseSetTemplates) {
        batch.update(
          _tableName,
          exercise.toMap(),
          where: '${ExerciseSetTemplateFields.id} = ?',
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
      _tableName,
      where: '${ExerciseSetTemplateFields.id} = ?',
      whereArgs: [id],
    );
    if (rowsDeleted == 0) {
      throw Exception(
        'Cannot delete exercise set template $id: does not exist',
      );
    }
  }

  Future<void> clearTable([Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    await executor.delete(_tableName);
  }
}
