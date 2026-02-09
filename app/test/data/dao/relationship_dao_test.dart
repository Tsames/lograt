import 'package:flutter_test/flutter_test.dart';
import 'package:lograt/data/dao/relationship_dao.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/model.dart';
import 'package:lograt/data/models/relationship.dart';
import 'package:lograt/util/uuidv7.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// Test models for testing generic RelationshipDao functionality
class _LeftModel implements Model {
  @override
  final String id;
  final String name;

  static const tableName = 'left_models';
  static const idFieldName = 'id';
  static const nameFieldName = 'name';

  const _LeftModel({required this.id, required this.name});

  _LeftModel.forTest({required String name}) : this(id: uuidV7(), name: name);

  @override
  Map<String, dynamic> toMap() {
    return {idFieldName: id, nameFieldName: name};
  }
}

class _RightModel implements Model {
  @override
  final String id;
  final String name;

  static const tableName = 'right_models';
  static const idFieldName = 'id';
  static const nameFieldName = 'name';

  const _RightModel({required this.id, required this.name});

  _RightModel.forTest({required String name}) : this(id: uuidV7(), name: name);

  @override
  Map<String, dynamic> toMap() {
    return {idFieldName: id, nameFieldName: name};
  }
}

class _TestRelationship implements Relationship<_LeftModel, _RightModel> {
  @override
  final String id;
  final String leftModelId;
  final String rightModelId;

  static const tableName = 'test_relationships';
  static const idFieldName = 'id';
  static const leftModelIdFieldName = 'left_model_id';
  static const rightModelIdFieldName = 'right_model_id';

  @override
  String get leftId => leftModelId;

  @override
  String get rightId => rightModelId;

  const _TestRelationship._({
    required this.id,
    required this.leftModelId,
    required this.rightModelId,
  });

  _TestRelationship.forTest({
    required String leftModelId,
    required String rightModelId,
  }) : this._(
         id: uuidV7(),
         leftModelId: leftModelId,
         rightModelId: rightModelId,
       );

  @override
  Map<String, dynamic> toMap() {
    return {
      idFieldName: id,
      leftModelIdFieldName: leftModelId,
      rightModelIdFieldName: rightModelId,
    };
  }

  @override
  String toString() =>
      '_TestRelationship(id: $id, leftModelId: $leftModelId, rightModelId: $rightModelId)';
}

// Test database that includes the relationship table
class _TestDatabase implements AppDatabase {
  Database? _database;

  @override
  String get connectionString => ':memory:';

  @override
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initialize();
    return _database!;
  }

  @override
  Future<Database> initialize() async {
    return await openDatabase(
      ':memory:',
      version: 1,
      onCreate: (Database db, int version) async {
        // Create left model table
        await db.execute('''
          CREATE TABLE ${_LeftModel.tableName}(
            ${_LeftModel.idFieldName} TEXT PRIMARY KEY,
            ${_LeftModel.nameFieldName} TEXT NOT NULL
          )
        ''');

        // Create right model table
        await db.execute('''
          CREATE TABLE ${_RightModel.tableName}(
            ${_RightModel.idFieldName} TEXT PRIMARY KEY,
            ${_RightModel.nameFieldName} TEXT NOT NULL
          )
        ''');

        // Create relationship table with foreign keys and unique constraint
        await db.execute('''
          CREATE TABLE ${_TestRelationship.tableName}(
            ${_TestRelationship.idFieldName} TEXT PRIMARY KEY,
            ${_TestRelationship.leftModelIdFieldName} TEXT NOT NULL,
            ${_TestRelationship.rightModelIdFieldName} TEXT NOT NULL,
            FOREIGN KEY (${_TestRelationship.leftModelIdFieldName}) REFERENCES ${_LeftModel.tableName}(${_LeftModel.idFieldName}) ON DELETE CASCADE,
            FOREIGN KEY (${_TestRelationship.rightModelIdFieldName}) REFERENCES ${_RightModel.tableName}(${_RightModel.idFieldName}) ON DELETE CASCADE,
            UNIQUE(${_TestRelationship.leftModelIdFieldName}, ${_TestRelationship.rightModelIdFieldName})
          )
        ''');
      },
      onOpen: (Database db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  @override
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  // Helper methods to insert test models
  Future<void> insertLeftModel(_LeftModel model) async {
    final db = await database;
    await db.insert(_LeftModel.tableName, model.toMap());
  }

  Future<void> insertRightModel(_RightModel model) async {
    final db = await database;
    await db.insert(_RightModel.tableName, model.toMap());
  }
}

void main() {
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('RelationshipDao Tests', () {
    late _TestDatabase testDatabase;
    late RelationshipDao<_TestRelationship> relationshipDao;

    late _LeftModel leftModel1;
    late _LeftModel leftModel2;
    late _LeftModel leftModel3;
    late _RightModel rightModel1;
    late _RightModel rightModel2;

    setUp(() async {
      testDatabase = _TestDatabase();
      relationshipDao = RelationshipDao<_TestRelationship>(
        db: testDatabase,
        tableName: _TestRelationship.tableName,
        relationshipIdFieldName: _TestRelationship.idFieldName,
        leftModelIdFieldName: _TestRelationship.leftModelIdFieldName,
        rightModelIdFieldName: _TestRelationship.rightModelIdFieldName,
      );

      // Create test models
      leftModel1 = _LeftModel.forTest(name: 'Left 1');
      leftModel2 = _LeftModel.forTest(name: 'Left 2');
      leftModel3 = _LeftModel.forTest(name: 'Left 3');
      rightModel1 = _RightModel.forTest(name: 'Right 1');
      rightModel2 = _RightModel.forTest(name: 'Right 2');

      // Insert test models into database
      await testDatabase.insertLeftModel(leftModel1);
      await testDatabase.insertLeftModel(leftModel2);
      await testDatabase.insertLeftModel(leftModel3);
      await testDatabase.insertRightModel(rightModel1);
      await testDatabase.insertRightModel(rightModel2);
    });

    tearDown(() async {
      await testDatabase.close();
    });

    group('Insert Operations', () {
      test('should insert a relationship correctly', () async {
        final relationship = _TestRelationship.forTest(
          leftModelId: leftModel1.id,
          rightModelId: rightModel1.id,
        );

        await relationshipDao.insertRelationship(relationship);

        final exists = await relationshipDao.relationshipExists(relationship);
        expect(exists, isTrue);
      });

      test(
        'should throw exception when inserting duplicate relationship',
        () async {
          final relationship = _TestRelationship.forTest(
            leftModelId: leftModel1.id,
            rightModelId: rightModel1.id,
          );

          await relationshipDao.insertRelationship(relationship);

          // Try to insert same left+right combination (different id, same relationship)
          final duplicateRelationship = _TestRelationship.forTest(
            leftModelId: leftModel1.id,
            rightModelId: rightModel1.id,
          );

          expect(
            () async =>
                await relationshipDao.insertRelationship(duplicateRelationship),
            throwsA(isA<Exception>()),
          );
        },
      );

      test('should handle transaction-based insert correctly', () async {
        final relationship = _TestRelationship.forTest(
          leftModelId: leftModel1.id,
          rightModelId: rightModel1.id,
        );

        final db = await testDatabase.database;

        await db.transaction((txn) async {
          await relationshipDao.insertRelationship(relationship, txn);

          final exists = await relationshipDao.relationshipExists(
            relationship,
            txn,
          );
          expect(exists, isTrue);
        });

        // Verify it persisted after transaction
        final exists = await relationshipDao.relationshipExists(relationship);
        expect(exists, isTrue);
      });

      test(
        'should allow same left model with different right models',
        () async {
          final relationship1 = _TestRelationship.forTest(
            leftModelId: leftModel1.id,
            rightModelId: rightModel1.id,
          );
          final relationship2 = _TestRelationship.forTest(
            leftModelId: leftModel1.id,
            rightModelId: rightModel2.id,
          );

          await relationshipDao.insertRelationship(relationship1);
          await relationshipDao.insertRelationship(relationship2);

          final exists1 = await relationshipDao.relationshipExists(
            relationship1,
          );
          final exists2 = await relationshipDao.relationshipExists(
            relationship2,
          );

          expect(exists1, isTrue);
          expect(exists2, isTrue);
        },
      );

      test(
        'should allow different left models with same right model',
        () async {
          final relationship1 = _TestRelationship.forTest(
            leftModelId: leftModel1.id,
            rightModelId: rightModel1.id,
          );
          final relationship2 = _TestRelationship.forTest(
            leftModelId: leftModel2.id,
            rightModelId: rightModel1.id,
          );

          await relationshipDao.insertRelationship(relationship1);
          await relationshipDao.insertRelationship(relationship2);

          final exists1 = await relationshipDao.relationshipExists(
            relationship1,
          );
          final exists2 = await relationshipDao.relationshipExists(
            relationship2,
          );

          expect(exists1, isTrue);
          expect(exists2, isTrue);
        },
      );
    });

    group('Batch Insert Operations', () {
      test('should batch insert multiple relationships correctly', () async {
        final relationships = [
          _TestRelationship.forTest(
            leftModelId: leftModel1.id,
            rightModelId: rightModel1.id,
          ),
          _TestRelationship.forTest(
            leftModelId: leftModel2.id,
            rightModelId: rightModel1.id,
          ),
          _TestRelationship.forTest(
            leftModelId: leftModel3.id,
            rightModelId: rightModel1.id,
          ),
        ];

        await relationshipDao.batchInsertRelationships(relationships);

        for (final relationship in relationships) {
          final exists = await relationshipDao.relationshipExists(relationship);
          expect(exists, isTrue);
        }
      });

      test('should handle empty list gracefully in batch insert', () async {
        // Should not throw
        await relationshipDao.batchInsertRelationships([]);

        // Verify no relationships exist
        final testRelationship = _TestRelationship.forTest(
          leftModelId: leftModel1.id,
          rightModelId: rightModel1.id,
        );
        final exists = await relationshipDao.relationshipExists(
          testRelationship,
        );
        expect(exists, isFalse);
      });

      test(
        'should batch insert relationships across multiple right models',
        () async {
          final relationships = [
            _TestRelationship.forTest(
              leftModelId: leftModel1.id,
              rightModelId: rightModel1.id,
            ),
            _TestRelationship.forTest(
              leftModelId: leftModel2.id,
              rightModelId: rightModel1.id,
            ),
            _TestRelationship.forTest(
              leftModelId: leftModel1.id,
              rightModelId: rightModel2.id,
            ),
          ];

          await relationshipDao.batchInsertRelationships(relationships);

          for (final relationship in relationships) {
            final exists = await relationshipDao.relationshipExists(
              relationship,
            );
            expect(exists, isTrue);
          }
        },
      );

      test(
        'should throw exception and rollback when batch insert has duplicate relationship',
        () async {
          final existingRelationship = _TestRelationship.forTest(
            leftModelId: leftModel1.id,
            rightModelId: rightModel1.id,
          );
          await relationshipDao.insertRelationship(existingRelationship);

          final relationships = [
            _TestRelationship.forTest(
              leftModelId: leftModel2.id,
              rightModelId: rightModel1.id,
            ),
            _TestRelationship.forTest(
              leftModelId: leftModel1.id,
              rightModelId: rightModel1.id,
            ), // Duplicate
            _TestRelationship.forTest(
              leftModelId: leftModel3.id,
              rightModelId: rightModel1.id,
            ),
          ];

          expect(
            () async =>
                await relationshipDao.batchInsertRelationships(relationships),
            throwsA(isA<DatabaseException>()),
          );

          // Verify rollback - only the original relationship exists
          final exists1 = await relationshipDao.relationshipExists(
            existingRelationship,
          );
          final exists2 = await relationshipDao.relationshipExists(
            relationships[0],
          );
          final exists3 = await relationshipDao.relationshipExists(
            relationships[2],
          );

          expect(exists1, isTrue); // Original remains
          expect(exists2, isFalse); // Not inserted due to rollback
          expect(exists3, isFalse); // Not inserted due to rollback
        },
      );

      test('should handle transaction-based batch insert correctly', () async {
        final relationships = [
          _TestRelationship.forTest(
            leftModelId: leftModel1.id,
            rightModelId: rightModel1.id,
          ),
          _TestRelationship.forTest(
            leftModelId: leftModel2.id,
            rightModelId: rightModel1.id,
          ),
        ];

        final db = await testDatabase.database;

        await db.transaction((txn) async {
          await relationshipDao.batchInsertRelationships(relationships, txn);

          for (final relationship in relationships) {
            final exists = await relationshipDao.relationshipExists(
              relationship,
              txn,
            );
            expect(exists, isTrue);
          }
        });

        // Verify they persisted after transaction
        for (final relationship in relationships) {
          final exists = await relationshipDao.relationshipExists(relationship);
          expect(exists, isTrue);
        }
      });
    });

    group('Read Operations (relationshipExists)', () {
      test('should return true when relationship exists', () async {
        final relationship = _TestRelationship.forTest(
          leftModelId: leftModel1.id,
          rightModelId: rightModel1.id,
        );
        await relationshipDao.insertRelationship(relationship);

        final exists = await relationshipDao.relationshipExists(relationship);

        expect(exists, isTrue);
      });

      test('should return false when relationship does not exist', () async {
        final relationship = _TestRelationship.forTest(
          leftModelId: leftModel1.id,
          rightModelId: rightModel1.id,
        );

        final exists = await relationshipDao.relationshipExists(relationship);

        expect(exists, isFalse);
      });

      test(
        'should correctly distinguish between different relationships',
        () async {
          final relationship = _TestRelationship.forTest(
            leftModelId: leftModel1.id,
            rightModelId: rightModel1.id,
          );
          await relationshipDao.insertRelationship(relationship);

          final existsCorrect = await relationshipDao.relationshipExists(
            relationship,
          );

          // Wrong right model
          final wrongRight = _TestRelationship.forTest(
            leftModelId: leftModel1.id,
            rightModelId: rightModel2.id,
          );
          final existsWrongRight = await relationshipDao.relationshipExists(
            wrongRight,
          );

          // Wrong left model
          final wrongLeft = _TestRelationship.forTest(
            leftModelId: leftModel2.id,
            rightModelId: rightModel1.id,
          );
          final existsWrongLeft = await relationshipDao.relationshipExists(
            wrongLeft,
          );

          expect(existsCorrect, isTrue);
          expect(existsWrongRight, isFalse);
          expect(existsWrongLeft, isFalse);
        },
      );

      test(
        'should handle transaction-based relationshipExists correctly',
        () async {
          final relationship = _TestRelationship.forTest(
            leftModelId: leftModel1.id,
            rightModelId: rightModel1.id,
          );
          await relationshipDao.insertRelationship(relationship);

          final db = await testDatabase.database;

          await db.transaction((txn) async {
            final exists = await relationshipDao.relationshipExists(
              relationship,
              txn,
            );
            expect(exists, isTrue);
          });
        },
      );
    });

    group('Delete Operations', () {
      test('should delete existing relationship successfully', () async {
        final relationship = _TestRelationship.forTest(
          leftModelId: leftModel1.id,
          rightModelId: rightModel1.id,
        );
        await relationshipDao.insertRelationship(relationship);

        await relationshipDao.delete(relationship);

        final exists = await relationshipDao.relationshipExists(relationship);
        expect(exists, isFalse);
      });

      test(
        'should throw exception when trying to delete non-existent relationship',
        () async {
          final relationship = _TestRelationship.forTest(
            leftModelId: leftModel1.id,
            rightModelId: rightModel1.id,
          );

          expect(
            () async => await relationshipDao.delete(relationship),
            throwsA(isA<Exception>()),
          );
        },
      );

      test('should only delete the specific relationship', () async {
        final relationship1 = _TestRelationship.forTest(
          leftModelId: leftModel1.id,
          rightModelId: rightModel1.id,
        );
        final relationship2 = _TestRelationship.forTest(
          leftModelId: leftModel2.id,
          rightModelId: rightModel1.id,
        );

        await relationshipDao.insertRelationship(relationship1);
        await relationshipDao.insertRelationship(relationship2);

        await relationshipDao.delete(relationship1);

        final exists1 = await relationshipDao.relationshipExists(relationship1);
        final exists2 = await relationshipDao.relationshipExists(relationship2);

        expect(exists1, isFalse);
        expect(exists2, isTrue); // Other relationship unchanged
      });

      test('should handle transaction-based delete correctly', () async {
        final relationship = _TestRelationship.forTest(
          leftModelId: leftModel1.id,
          rightModelId: rightModel1.id,
        );
        await relationshipDao.insertRelationship(relationship);

        final db = await testDatabase.database;

        await db.transaction((txn) async {
          await relationshipDao.delete(relationship, txn);

          final exists = await relationshipDao.relationshipExists(
            relationship,
            txn,
          );
          expect(exists, isFalse);
        });

        // Verify deletion persisted after transaction
        final exists = await relationshipDao.relationshipExists(relationship);
        expect(exists, isFalse);
      });
    });
  });
}
