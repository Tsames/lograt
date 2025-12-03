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
  Future<List<WorkoutTemplateModel>> getTemplatePaginatedOrderedByDate({
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

  Future<void> batchInsert(
    List<WorkoutTemplateModel> templates, [
    Transaction? txn,
  ]) async {
    if (templates.isEmpty) return;

    final DatabaseExecutor executor = txn ?? await _db.database;
    final batch = executor.batch();

    for (final template in templates) {
      batch.insert(
        workoutTemplatesTable,
        template.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<void> update(WorkoutTemplateModel template, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    final rowsUpdated = await executor.update(
      workoutTemplatesTable,
      template.toMap(),
      where: '${WorkoutTemplateFields.id} = ?',
      whereArgs: [template.id],
    );

    if (rowsUpdated == 0) {
      throw Exception(
        'Cannot update workout template $template: does not exist',
      );
    }
  }

  Future<void> batchUpdate(
    List<WorkoutTemplateModel> templates, [
    Transaction? txn,
  ]) async {
    if (templates.isEmpty) return;

    Future<void> executeUpdate(Transaction transaction) async {
      for (final template in templates) {
        final exists = await getById(template.id, transaction);
        if (exists == null) {
          throw Exception(
            'Cannot update workout template $template: does not exist',
          );
        }
      }

      final batch = transaction.batch();
      for (final template in templates) {
        batch.update(
          workoutTemplatesTable,
          template.toMap(),
          where: '${WorkoutTemplateFields.id} = ?',
          whereArgs: [template.id],
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
      workoutTemplatesTable,
      where: '${WorkoutTemplateFields.id} = ?',
      whereArgs: [id],
    );
    if (rowsDeleted == 0) {
      throw Exception('Cannot delete workout template $id: does not exist');
    }
  }

  Future<void> clearTable([Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    await executor.delete(workoutTemplatesTable);
  }
}
