import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/relationship.dart';
import 'package:lograt/util/uuidv7.dart';
import 'package:sqflite/sqflite.dart';

class RelationshipDao<T extends Relationship> {
  final AppDatabase db;
  final String tableName;
  final String relationshipIdFieldName;
  final String leftModelIdFieldName;
  final String rightModelIdFieldName;

  RelationshipDao({
    required this.db,
    required this.tableName,
    required this.relationshipIdFieldName,
    required this.leftModelIdFieldName,
    required this.rightModelIdFieldName,
  });

  Future<bool> relationshipExists(T relationship, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await db.database;
    final maps = await executor.query(
      tableName,
      where: '$leftModelIdFieldName = ? AND $rightModelIdFieldName = ?',
      whereArgs: [relationship.leftId, relationship.rightId],
      limit: 1,
    );
    return maps.isNotEmpty;
  }

  Future<void> insertRelationship(T relationship, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await db.database;
    await executor.insert(tableName, {
      relationshipIdFieldName: uuidV7(),
      leftModelIdFieldName: relationship.leftId,
      rightModelIdFieldName: relationship.rightId,
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
      batch.insert(tableName, {
        relationshipIdFieldName: uuidV7(),
        leftModelIdFieldName: rel.leftId,
        rightModelIdFieldName: rel.rightId,
      }, conflictAlgorithm: ConflictAlgorithm.fail);
    }

    await batch.commit(noResult: true);
  }

  Future<void> delete(T relationship, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await db.database;
    final rowsDeleted = await executor.delete(
      tableName,
      where: '$leftModelIdFieldName = ? AND $rightModelIdFieldName = ?',
      whereArgs: [relationship.leftId, relationship.rightId],
    );

    if (rowsDeleted == 0) {
      throw Exception(
        'Cannot delete relationship of type $T ($leftModelIdFieldName: ${relationship.leftId}, $rightModelIdFieldName: ${relationship.rightId}): does not exist',
      );
    }
  }
}
