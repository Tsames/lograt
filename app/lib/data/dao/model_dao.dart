import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/model.dart';
import 'package:sqflite/sqflite.dart';

class ModelDao<T extends Model> {
  final AppDatabase db;
  final String modelName;
  final String tableName;
  final String modelIdFieldName;
  final T? Function(Map<String, dynamic>) _fromMap;

  ModelDao({
    required this.db,
    required this.modelName,
    required this.tableName,
    required this.modelIdFieldName,
    required T? Function(Map<String, dynamic>) fromMap,
  }) : _fromMap = fromMap;

  Future<T?> getById(String id, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await db.database;
    final maps = await executor.query(
      tableName,
      where: '$modelIdFieldName = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return _fromMap(maps.first);
  }

  Future<int> insert(T model, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await db.database;
    return await executor.insert(
      tableName,
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<void> batchInsert(List<T> models, [Transaction? txn]) async {
    if (models.isEmpty) return;

    final DatabaseExecutor executor = txn ?? await db.database;
    final batch = executor.batch();

    for (final model in models) {
      batch.insert(
        tableName,
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<void> update(T model, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await db.database;
    final rowsUpdated = await executor.update(
      tableName,
      model.toMap(),
      where: '$modelIdFieldName = ?',
      whereArgs: [model.id],
    );

    if (rowsUpdated == 0) {
      throw Exception('Cannot update $model: does not exist');
    }
  }

  Future<void> batchUpdate(List<T> models, [Transaction? txn]) async {
    if (models.isEmpty) return;

    Future<void> executeUpdate(Transaction transaction) async {
      for (final model in models) {
        final exists = await getById(model.id, transaction);
        if (exists == null) {
          throw Exception('Cannot update $model: does not exist');
        }
      }

      final batch = transaction.batch();
      for (final model in models) {
        batch.update(
          tableName,
          model.toMap(),
          where: '$modelIdFieldName = ?',
          whereArgs: [model.id],
        );
      }
      await batch.commit(noResult: true);
    }

    // If no transaction provided, create one
    if (txn != null) {
      await executeUpdate(txn);
    } else {
      final db = await this.db.database;
      await db.transaction((transaction) async {
        await executeUpdate(transaction);
      });
    }
  }

  Future<void> delete(String modelId, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await db.database;
    final rowsDeleted = await executor.delete(
      tableName,
      where: '$modelIdFieldName = ?',
      whereArgs: [modelId],
    );

    if (rowsDeleted == 0) {
      throw Exception('Cannot delete $modelName $modelId: does not exist');
    }
  }

  Future<void> clearTable([Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await db.database;
    await executor.delete(tableName);
  }
}
