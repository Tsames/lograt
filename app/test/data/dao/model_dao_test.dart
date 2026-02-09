import 'package:flutter_test/flutter_test.dart';
import 'package:lograt/data/dao/model_dao.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/model.dart';
import 'package:lograt/util/uuidv7.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// Test model for testing generic ModelDao functionality
class _TestModel implements Model {
  @override
  final String id;
  final String name;
  final int? value;

  static const tableName = 'test_models';
  static const idFieldName = 'id';
  static const nameFieldName = 'name';
  static const valueFieldName = 'value';

  const _TestModel({required this.id, required this.name, this.value});

  _TestModel.forTest({required String name, int? value})
    : this(id: uuidV7(), name: name, value: value);

  static _TestModel? fromMap(Map<String, dynamic> map) {
    final id = map[idFieldName];
    if (id == null || id is! String) return null;
    final name = map[nameFieldName];
    if (name == null || name is! String) return null;
    final value = map[valueFieldName];
    if (value != null && value is! int) return null;
    return _TestModel(id: id, name: name, value: value);
  }

  @override
  Map<String, dynamic> toMap() {
    return {idFieldName: id, nameFieldName: name, valueFieldName: value};
  }

  _TestModel copyWith({String? id, String? name, int? value}) {
    return _TestModel(
      id: id ?? this.id,
      name: name ?? this.name,
      value: value ?? this.value,
    );
  }

  @override
  String toString() => '_TestModel(id: $id, name: $name, value: $value)';
}

// Test database that includes the test table
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
        await db.execute('''
          CREATE TABLE ${_TestModel.tableName}(
            ${_TestModel.idFieldName} TEXT PRIMARY KEY,
            ${_TestModel.nameFieldName} TEXT NOT NULL,
            ${_TestModel.valueFieldName} INTEGER
          )
        ''');
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
}

void main() {
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  void expectModelsEqual(_TestModel? actual, _TestModel expected) {
    expect(actual, isNotNull, reason: 'Expected model to exist but got null');

    expect(
      actual!.id,
      equals(expected.id),
      reason: 'Field "id" does not match',
    );
    expect(
      actual.name,
      equals(expected.name),
      reason: 'Field "name" does not match',
    );
    expect(
      actual.value,
      equals(expected.value),
      reason: 'Field "value" does not match',
    );
  }

  group('ModelDao Tests', () {
    late _TestDatabase testDatabase;
    late ModelDao<_TestModel> modelDao;
    late _TestModel testModel;

    setUp(() async {
      testDatabase = _TestDatabase();
      modelDao = ModelDao<_TestModel>(
        db: testDatabase,
        modelName: 'test model',
        tableName: _TestModel.tableName,
        modelIdFieldName: _TestModel.idFieldName,
        fromMap: _TestModel.fromMap,
      );

      testModel = _TestModel.forTest(name: 'Test Name', value: 42);
    });

    tearDown(() async {
      await testDatabase.close();
    });

    group('Insert Operations', () {
      test('should insert a new model correctly', () async {
        await modelDao.insert(testModel);

        final retrieved = await modelDao.getById(testModel.id);
        expectModelsEqual(retrieved, testModel);
      });

      test(
        'should handle inserting model with minimal data (null optional fields)',
        () async {
          final minimalModel = _TestModel.forTest(name: 'Minimal');

          await modelDao.insert(minimalModel);

          final retrieved = await modelDao.getById(minimalModel.id);
          expectModelsEqual(retrieved, minimalModel);
          expect(retrieved!.value, isNull);
        },
      );

      test(
        'should throw exception when inserting model with duplicate id',
        () async {
          final duplicateModel = testModel.copyWith(name: 'Different Name');
          await modelDao.insert(testModel);

          expect(
            () async => await modelDao.insert(duplicateModel),
            throwsA(isA<Exception>()),
          );
        },
      );

      test('should handle transaction-based insert correctly', () async {
        final db = await testDatabase.database;

        await db.transaction((txn) async {
          await modelDao.insert(testModel, txn);
          final retrieved = await modelDao.getById(testModel.id, txn);
          expectModelsEqual(retrieved, testModel);
        });

        // Verify it persisted after transaction
        final retrieved = await modelDao.getById(testModel.id);
        expectModelsEqual(retrieved, testModel);
      });
    });

    group('Batch Insert Operations', () {
      test('should batch insert multiple models correctly', () async {
        final models = [
          _TestModel.forTest(name: 'Model 1', value: 1),
          _TestModel.forTest(name: 'Model 2', value: 2),
          _TestModel.forTest(name: 'Model 3', value: 3),
        ];

        await modelDao.batchInsert(models);

        for (final model in models) {
          final retrieved = await modelDao.getById(model.id);
          expectModelsEqual(retrieved, model);
        }
      });

      test('should handle empty list gracefully in batch insert', () async {
        // Should not throw
        await modelDao.batchInsert([]);

        // Database should still be empty
        final retrieved = await modelDao.getById('non-existent');
        expect(retrieved, isNull);
      });

      test(
        'should throw exception and rollback insertions when batch insert has duplicate id',
        () async {
          await modelDao.insert(testModel);

          final models = [
            _TestModel.forTest(name: 'New Model 1', value: 1),
            testModel.copyWith(name: 'Duplicate'), // duplicate id
            _TestModel.forTest(name: 'New Model 2', value: 2),
          ];

          expect(
            () async => await modelDao.batchInsert(models),
            throwsA(isA<DatabaseException>()),
          );

          // Verify rollback - only original testModel should exist
          final original = await modelDao.getById(testModel.id);
          expectModelsEqual(original, testModel);

          // New models should not have been inserted due to rollback
          final newModel1 = await modelDao.getById(models[0].id);
          expect(newModel1, isNull);
        },
      );

      test('should handle transaction-based batch insert correctly', () async {
        final models = [
          _TestModel.forTest(name: 'Model 1', value: 1),
          _TestModel.forTest(name: 'Model 2', value: 2),
        ];

        final db = await testDatabase.database;

        await db.transaction((txn) async {
          await modelDao.batchInsert(models, txn);

          for (final model in models) {
            final retrieved = await modelDao.getById(model.id, txn);
            expectModelsEqual(retrieved, model);
          }
        });

        // Verify they persisted after transaction
        for (final model in models) {
          final retrieved = await modelDao.getById(model.id);
          expectModelsEqual(retrieved, model);
        }
      });
    });

    group('Read Operations (getById)', () {
      setUp(() async {
        await modelDao.insert(testModel);
      });

      test('should retrieve model by id correctly', () async {
        final retrieved = await modelDao.getById(testModel.id);

        expectModelsEqual(retrieved, testModel);
      });

      test('should return null when model does not exist', () async {
        final nonExistent = await modelDao.getById('non-existent-id');

        expect(nonExistent, isNull);
      });

      test('should handle transaction-based getById correctly', () async {
        final db = await testDatabase.database;

        await db.transaction((txn) async {
          final retrieved = await modelDao.getById(testModel.id, txn);
          expectModelsEqual(retrieved, testModel);
        });
      });
    });

    group('Update Operations', () {
      setUp(() async {
        await modelDao.insert(testModel);
      });

      test('should update existing model successfully', () async {
        final updatedModel = testModel.copyWith(
          name: 'Updated Name',
          value: 100,
        );

        await modelDao.update(updatedModel);

        final retrieved = await modelDao.getById(testModel.id);
        expectModelsEqual(retrieved, updatedModel);
      });

      test(
        'should throw an exception when trying to update non-existent model',
        () async {
          final nonExistentModel = _TestModel(
            id: 'non-existent-id',
            name: 'Non-existent',
            value: 0,
          );

          expect(
            () async => await modelDao.update(nonExistentModel),
            throwsA(isA<Exception>()),
          );
        },
      );

      test('should handle transaction-based update correctly', () async {
        final updatedModel = testModel.copyWith(name: 'Updated Name');
        final db = await testDatabase.database;

        await db.transaction((txn) async {
          await modelDao.update(updatedModel, txn);
          final retrieved = await modelDao.getById(testModel.id, txn);
          expectModelsEqual(retrieved, updatedModel);
        });

        // Verify it persisted after transaction
        final retrieved = await modelDao.getById(testModel.id);
        expectModelsEqual(retrieved, updatedModel);
      });
    });

    group('Batch Update Operations', () {
      test('should batch update multiple models correctly', () async {
        final models = [
          _TestModel.forTest(name: 'Original 1', value: 1),
          _TestModel.forTest(name: 'Original 2', value: 2),
          _TestModel.forTest(name: 'Original 3', value: 3),
        ];

        await modelDao.batchInsert(models);

        final updatedModels = [
          models[0].copyWith(name: 'Updated 1', value: 10),
          models[1].copyWith(name: 'Updated 2', value: 20),
          models[2].copyWith(name: 'Updated 3', value: 30),
        ];

        await modelDao.batchUpdate(updatedModels);

        final retrieved1 = await modelDao.getById(models[0].id);
        final retrieved2 = await modelDao.getById(models[1].id);
        final retrieved3 = await modelDao.getById(models[2].id);

        expectModelsEqual(retrieved1, updatedModels[0]);
        expectModelsEqual(retrieved2, updatedModels[1]);
        expectModelsEqual(retrieved3, updatedModels[2]);
      });

      test('should handle empty list gracefully in batch update', () async {
        await modelDao.insert(testModel);

        await modelDao.batchUpdate([]);

        // Original model should be unchanged
        final retrieved = await modelDao.getById(testModel.id);
        expectModelsEqual(retrieved, testModel);
      });

      test(
        'should throw exception and rollback all updates when one model does not exist',
        () async {
          final existingModel = _TestModel.forTest(name: 'Existing', value: 1);
          await modelDao.insert(existingModel);

          final nonExistentModel = _TestModel(
            id: 'non-existent',
            name: 'Non-existent',
            value: 0,
          );
          final updatedExisting = existingModel.copyWith(
            name: 'Should not persist',
            value: 999,
          );

          expect(
            () async =>
                await modelDao.batchUpdate([updatedExisting, nonExistentModel]),
            throwsA(isA<Exception>()),
          );

          // Verify rollback - original data unchanged
          final retrieved = await modelDao.getById(existingModel.id);
          expect(retrieved!.name, equals('Existing'));
          expect(retrieved.value, equals(1));
        },
      );

      test('should handle transaction-based batch update correctly', () async {
        final models = [
          _TestModel.forTest(name: 'Original 1', value: 1),
          _TestModel.forTest(name: 'Original 2', value: 2),
        ];

        await modelDao.batchInsert(models);

        final updatedModels = [
          models[0].copyWith(name: 'Updated 1'),
          models[1].copyWith(name: 'Updated 2'),
        ];

        final db = await testDatabase.database;

        await db.transaction((txn) async {
          await modelDao.batchUpdate(updatedModels, txn);

          for (int i = 0; i < models.length; i++) {
            final retrieved = await modelDao.getById(models[i].id, txn);
            expectModelsEqual(retrieved, updatedModels[i]);
          }
        });

        // Verify they persisted after transaction
        for (int i = 0; i < models.length; i++) {
          final retrieved = await modelDao.getById(models[i].id);
          expectModelsEqual(retrieved, updatedModels[i]);
        }
      });
    });

    group('Delete Operations', () {
      setUp(() async {
        await modelDao.insert(testModel);
      });

      test('should delete existing model successfully', () async {
        await modelDao.delete(testModel.id);

        final retrieved = await modelDao.getById(testModel.id);
        expect(retrieved, isNull);
      });

      test(
        'should throw an exception when trying to delete non-existent model',
        () async {
          expect(
            () async => await modelDao.delete('non-existent-id'),
            throwsA(isA<Exception>()),
          );
        },
      );

      test('should handle transaction-based delete correctly', () async {
        final db = await testDatabase.database;

        await db.transaction((txn) async {
          await modelDao.delete(testModel.id, txn);
          final retrieved = await modelDao.getById(testModel.id, txn);
          expect(retrieved, isNull);
        });

        // Verify deletion persisted after transaction
        final retrieved = await modelDao.getById(testModel.id);
        expect(retrieved, isNull);
      });
    });

    group('Clear Table Operations', () {
      test('should clear all models from table', () async {
        final models = [
          _TestModel.forTest(name: 'Model 1', value: 1),
          _TestModel.forTest(name: 'Model 2', value: 2),
          _TestModel.forTest(name: 'Model 3', value: 3),
        ];

        await modelDao.batchInsert(models);

        // Verify models exist
        for (final model in models) {
          final retrieved = await modelDao.getById(model.id);
          expect(retrieved, isNotNull);
        }

        await modelDao.clearTable();

        // Verify all models are deleted
        for (final model in models) {
          final retrieved = await modelDao.getById(model.id);
          expect(retrieved, isNull);
        }
      });

      test('should handle clearing empty table gracefully', () async {
        // Should not throw
        await modelDao.clearTable();
      });

      test('should handle transaction-based clearTable correctly', () async {
        await modelDao.insert(testModel);

        final db = await testDatabase.database;

        await db.transaction((txn) async {
          await modelDao.clearTable(txn);
          final retrieved = await modelDao.getById(testModel.id, txn);
          expect(retrieved, isNull);
        });

        // Verify clear persisted after transaction
        final retrieved = await modelDao.getById(testModel.id);
        expect(retrieved, isNull);
      });
    });
  });
}
