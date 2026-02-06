import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/relationship.dart';
import 'package:lograt/util/uuidv7.dart';
import 'package:sqflite/sqflite.dart';

abstract class ManyToManyRelationshipDao<T extends Relationship> {
  final AppDatabase db;

  ManyToManyRelationshipDao({required this.db});

  Future<bool> relationshipExists(T relationship, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await db.database;
    final maps = await executor.query(
      relationship.nameOfTable,
      where:
          '${relationship.leftModelIdField} = ? AND ${relationship.rightModelIdField} = ?',
      whereArgs: [relationship.leftId, relationship.rightId],
      limit: 1,
    );
    return maps.isNotEmpty;
  }

  Future<void> insertRelationship(T relationship, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await db.database;
    await executor.insert(relationship.nameOfTable, {
      relationship.idField: uuidV7(),
      relationship.leftModelIdField: relationship.leftId,
      relationship.rightModelIdField: relationship.rightId,
    }, conflictAlgorithm: ConflictAlgorithm.fail);
  }

  Future<void> batchInsertRelationships(
    List<T> relationships, [
    Transaction? txn,
  ]) async {
    if (relationships.isEmpty) return;

    final DatabaseExecutor executor = txn ?? await db.database;
    final batch = executor.batch();

    for (final rel in relationships) {
      batch.insert(rel.nameOfTable, {
        rel.idField: uuidV7(),
        rel.leftModelIdField: rel.leftId,
        rel.rightModelIdField: rel.rightId,
      }, conflictAlgorithm: ConflictAlgorithm.fail);
    }

    await batch.commit(noResult: true);
  }

  Future<void> delete(T relationship, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await db.database;
    final rowsDeleted = await executor.delete(
      relationship.nameOfTable,
      where:
          '${relationship.leftModelIdField} = ? AND ${relationship.rightModelIdField} = ?',
      whereArgs: [relationship.leftId, relationship.rightId],
    );

    if (rowsDeleted == 0) {
      throw Exception(
        'Cannot delete relationship of type $T (${relationship.leftModelIdField}: $relationship.leftId, ${relationship.rightModelIdField}: $relationship.rightId): does not exist',
      );
    }
  }
}
