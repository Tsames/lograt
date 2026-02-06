void main() {
  // setUpAll(() async {
  //   sqfliteFfiInit();
  //   databaseFactory = databaseFactoryFfi;
  // });
  //
  // void expectExerciseSetTemplatesEqual(
  //   ExerciseSetTemplateModel? actual,
  //   ExerciseSetTemplateModel expected,
  // ) {
  //   expect(
  //     actual,
  //     isNotNull,
  //     reason: 'Expected exercise set template to exist but got null',
  //   );
  //
  //   final actualMap = actual!.toMap();
  //   final expectedMap = expected.toMap();
  //
  //   for (final field in ExerciseSetTemplateFields.values) {
  //     expect(
  //       actualMap[field],
  //       equals(expectedMap[field]),
  //       reason: 'Field "$field" does not match',
  //     );
  //   }
  // }
  //
  // group('ExerciseSetTemplateDao Tests', () {
  //   late AppDatabase testDatabase;
  //   late ExerciseSetTemplateDao exerciseSetTemplateDao;
  //   late WorkoutTemplateDao workoutTemplateDao;
  //   late ExerciseTypeDao exerciseTypeDao;
  //   late ExerciseTemplateDao exerciseTemplateDao;
  //
  //   late WorkoutTemplateModel testWorkoutTemplate;
  //   late ExerciseTypeModel testExerciseType;
  //   late ExerciseTemplateModel testExerciseTemplate;
  //   late ExerciseSetTemplateModel testExerciseSetTemplate;
  //
  //   setUp(() async {
  //     testDatabase = AppDatabase.inMemory();
  //     exerciseSetTemplateDao = ExerciseSetTemplateDao(testDatabase);
  //     workoutTemplateDao = WorkoutTemplateDao(testDatabase);
  //     exerciseTypeDao = ExerciseTypeDao(testDatabase);
  //     exerciseTemplateDao = ExerciseTemplateDao(testDatabase);
  //
  //     testWorkoutTemplate = WorkoutTemplateModel.forTest(
  //       title: 'Test Workout Template',
  //     );
  //     await workoutTemplateDao.insert(testWorkoutTemplate);
  //
  //     testExerciseType = ExerciseTypeModel.forTest(
  //       name: 'Bench Press',
  //       description: 'Chest exercise',
  //     );
  //     await exerciseTypeDao.insert(testExerciseType);
  //
  //     testExerciseTemplate = ExerciseTemplateModel.forTest(
  //       workoutTemplateId: testWorkoutTemplate.id,
  //       exerciseTypeId: testExerciseType.id,
  //       order: 1,
  //     );
  //     await exerciseTemplateDao.insert(testExerciseTemplate);
  //
  //     testExerciseSetTemplate = ExerciseSetTemplateModel.forTest(
  //       exerciseTemplateId: testExerciseTemplate.id,
  //       order: 1,
  //       setType: SetType.working.name,
  //       units: Units.pounds.name,
  //     );
  //   });
  //
  //   tearDown(() async {
  //     await testDatabase.close();
  //   });
  //
  //   group('Insert Operations', () {
  //     test('should insert a new exercise set template correctly', () async {
  //       await exerciseSetTemplateDao.insert(testExerciseSetTemplate);
  //
  //       final retrieved = await exerciseSetTemplateDao.getById(
  //         testExerciseSetTemplate.id,
  //       );
  //       expectExerciseSetTemplatesEqual(retrieved, testExerciseSetTemplate);
  //     });
  //
  //     test(
  //       'should handle inserting exercise set template with minimal data',
  //       () async {
  //         final minimalExerciseSetTemplate = ExerciseSetTemplateModel.forTest(
  //           exerciseTemplateId: testExerciseTemplate.id,
  //         );
  //
  //         await exerciseSetTemplateDao.insert(minimalExerciseSetTemplate);
  //
  //         final retrieved = await exerciseSetTemplateDao.getById(
  //           minimalExerciseSetTemplate.id,
  //         );
  //         expectExerciseSetTemplatesEqual(
  //           retrieved,
  //           minimalExerciseSetTemplate,
  //         );
  //       },
  //     );
  //
  //     test(
  //       'should throw exception when inserting exercise set template with duplicate id',
  //       () async {
  //         final otherExerciseSetTemplate = testExerciseSetTemplate.copyWith(
  //           order: testExerciseSetTemplate.order + 1,
  //         );
  //         await exerciseSetTemplateDao.insert(testExerciseSetTemplate);
  //         expect(
  //           () async =>
  //               await exerciseSetTemplateDao.insert(otherExerciseSetTemplate),
  //           throwsA(isA<Exception>()),
  //         );
  //       },
  //     );
  //
  //     test('should handle transaction-based insert correctly', () async {
  //       final db = await testDatabase.database;
  //
  //       await db.transaction((txn) async {
  //         await exerciseSetTemplateDao.insert(testExerciseSetTemplate, txn);
  //         final retrieved = await exerciseSetTemplateDao.getById(
  //           testExerciseSetTemplate.id,
  //           txn,
  //         );
  //         expectExerciseSetTemplatesEqual(retrieved, testExerciseSetTemplate);
  //       });
  //
  //       // Verify it persisted after transaction
  //       final retrieved = await exerciseSetTemplateDao.getById(
  //         testExerciseSetTemplate.id,
  //       );
  //       expectExerciseSetTemplatesEqual(retrieved, testExerciseSetTemplate);
  //     });
  //   });
  //
  //   group('Batch Insert Operations', () {
  //     test(
  //       'should batch insert multiple exercise set templates correctly',
  //       () async {
  //         final exerciseSetTemplates = [
  //           ExerciseSetTemplateModel.forTest(
  //             exerciseTemplateId: testExerciseTemplate.id,
  //             order: 1,
  //             setType: SetType.warmup.name,
  //           ),
  //           ExerciseSetTemplateModel.forTest(
  //             exerciseTemplateId: testExerciseTemplate.id,
  //             order: 2,
  //             setType: SetType.working.name,
  //           ),
  //           ExerciseSetTemplateModel.forTest(
  //             exerciseTemplateId: testExerciseTemplate.id,
  //             order: 3,
  //             setType: SetType.working.name,
  //           ),
  //         ];
  //
  //         await exerciseSetTemplateDao.batchInsert(exerciseSetTemplates);
  //
  //         final allExerciseSetTemplates = await exerciseSetTemplateDao
  //             .getAllExerciseSetTemplatesWithExerciseTemplateId(
  //               testExerciseTemplate.id,
  //             );
  //         expect(allExerciseSetTemplates.length, equals(3));
  //         expect(
  //           allExerciseSetTemplates,
  //           everyElement(isA<ExerciseSetTemplateModel>()),
  //         );
  //         expectExerciseSetTemplatesEqual(
  //           allExerciseSetTemplates[0],
  //           exerciseSetTemplates[0],
  //         );
  //         expectExerciseSetTemplatesEqual(
  //           allExerciseSetTemplates[1],
  //           exerciseSetTemplates[1],
  //         );
  //         expectExerciseSetTemplatesEqual(
  //           allExerciseSetTemplates[2],
  //           exerciseSetTemplates[2],
  //         );
  //       },
  //     );
  //
  //     test('should handle empty list gracefully in batch insert', () async {
  //       await exerciseSetTemplateDao.batchInsert([]);
  //
  //       final allExerciseSetTemplates = await exerciseSetTemplateDao
  //           .getAllExerciseSetTemplatesWithExerciseTemplateId(
  //             testExerciseTemplate.id,
  //           );
  //       expect(allExerciseSetTemplates, isEmpty);
  //     });
  //
  //     test(
  //       'should batch insert exercise set templates across multiple exercise templates',
  //       () async {
  //         final exerciseTemplate2 = ExerciseTemplateModel.forTest(
  //           workoutTemplateId: testWorkoutTemplate.id,
  //           order: 2,
  //         );
  //         await exerciseTemplateDao.insert(exerciseTemplate2);
  //
  //         final exerciseSetTemplates = [
  //           ExerciseSetTemplateModel.forTest(
  //             exerciseTemplateId: testExerciseTemplate.id,
  //             order: 1,
  //           ),
  //           ExerciseSetTemplateModel.forTest(
  //             exerciseTemplateId: exerciseTemplate2.id,
  //             order: 1,
  //           ),
  //         ];
  //
  //         await exerciseSetTemplateDao.batchInsert(exerciseSetTemplates);
  //
  //         final template1Sets = await exerciseSetTemplateDao
  //             .getAllExerciseSetTemplatesWithExerciseTemplateId(
  //               testExerciseTemplate.id,
  //             );
  //         final template2Sets = await exerciseSetTemplateDao
  //             .getAllExerciseSetTemplatesWithExerciseTemplateId(
  //               exerciseTemplate2.id,
  //             );
  //
  //         expect(template1Sets.length, equals(1));
  //         expect(template2Sets.length, equals(1));
  //
  //         expectExerciseSetTemplatesEqual(
  //           template1Sets[0],
  //           exerciseSetTemplates[0],
  //         );
  //         expectExerciseSetTemplatesEqual(
  //           template2Sets[0],
  //           exerciseSetTemplates[1],
  //         );
  //       },
  //     );
  //
  //     test(
  //       'should throw exception when batch insert has duplicate id among valid exercise set templates',
  //       () async {
  //         await exerciseSetTemplateDao.insert(testExerciseSetTemplate);
  //
  //         final exerciseSetTemplates = [
  //           ExerciseSetTemplateModel.forTest(
  //             exerciseTemplateId: testExerciseTemplate.id,
  //             order: 1,
  //           ),
  //           testExerciseSetTemplate,
  //           ExerciseSetTemplateModel.forTest(
  //             exerciseTemplateId: testExerciseTemplate.id,
  //             order: 2,
  //           ),
  //         ];
  //
  //         expect(
  //           () async =>
  //               await exerciseSetTemplateDao.batchInsert(exerciseSetTemplates),
  //           throwsA(isA<DatabaseException>()),
  //         );
  //
  //         final allExerciseSetTemplates = await exerciseSetTemplateDao
  //             .getAllExerciseSetTemplatesWithExerciseTemplateId(
  //               testExerciseTemplate.id,
  //             );
  //         expect(allExerciseSetTemplates.length, equals(1));
  //         expectExerciseSetTemplatesEqual(
  //           allExerciseSetTemplates.first,
  //           testExerciseSetTemplate,
  //         );
  //       },
  //     );
  //   });
  //
  //   group('Read Operations', () {
  //     setUp(() async {
  //       await exerciseSetTemplateDao.insert(testExerciseSetTemplate);
  //     });
  //
  //     test('should retrieve exercise set template by id correctly', () async {
  //       final retrieved = await exerciseSetTemplateDao.getById(
  //         testExerciseSetTemplate.id,
  //       );
  //
  //       expectExerciseSetTemplatesEqual(retrieved, testExerciseSetTemplate);
  //     });
  //
  //     test(
  //       'should return null when exercise set template does not exist',
  //       () async {
  //         final nonExistent = await exerciseSetTemplateDao.getById('99999');
  //
  //         expect(nonExistent, isNull);
  //       },
  //     );
  //
  //     test(
  //       'should retrieve all exercise set templates for an exercise template',
  //       () async {
  //         final exerciseTemplate2 = ExerciseTemplateModel.forTest(
  //           workoutTemplateId: testWorkoutTemplate.id,
  //           order: 2,
  //         );
  //         await exerciseTemplateDao.insert(exerciseTemplate2);
  //
  //         final exerciseSetTemplate2 = ExerciseSetTemplateModel.forTest(
  //           exerciseTemplateId: testExerciseTemplate.id,
  //           order: 2,
  //         );
  //         final exerciseSetTemplate3 = ExerciseSetTemplateModel.forTest(
  //           exerciseTemplateId: testExerciseTemplate.id,
  //           order: 3,
  //         );
  //         final exerciseSetTemplate4 = ExerciseSetTemplateModel.forTest(
  //           exerciseTemplateId: exerciseTemplate2.id,
  //           order: 1,
  //         );
  //
  //         await exerciseSetTemplateDao.insert(exerciseSetTemplate2);
  //         await exerciseSetTemplateDao.insert(exerciseSetTemplate3);
  //         await exerciseSetTemplateDao.insert(exerciseSetTemplate4);
  //
  //         final allExerciseSetTemplates = await exerciseSetTemplateDao
  //             .getAllExerciseSetTemplatesWithExerciseTemplateId(
  //               testExerciseTemplate.id,
  //             );
  //
  //         expect(allExerciseSetTemplates.length, equals(3));
  //         expect(
  //           allExerciseSetTemplates,
  //           everyElement(isA<ExerciseSetTemplateModel>()),
  //         );
  //         expectExerciseSetTemplatesEqual(
  //           allExerciseSetTemplates[0],
  //           testExerciseSetTemplate,
  //         );
  //         expectExerciseSetTemplatesEqual(
  //           allExerciseSetTemplates[1],
  //           exerciseSetTemplate2,
  //         );
  //         expectExerciseSetTemplatesEqual(
  //           allExerciseSetTemplates[2],
  //           exerciseSetTemplate3,
  //         );
  //       },
  //     );
  //
  //     test(
  //       'should return empty list when exercise template has no set templates',
  //       () async {
  //         final emptyExerciseTemplate = ExerciseTemplateModel.forTest(
  //           workoutTemplateId: testWorkoutTemplate.id,
  //           order: 2,
  //         );
  //         await exerciseTemplateDao.insert(emptyExerciseTemplate);
  //
  //         final exerciseSetTemplates = await exerciseSetTemplateDao
  //             .getAllExerciseSetTemplatesWithExerciseTemplateId(
  //               emptyExerciseTemplate.id,
  //             );
  //
  //         expect(exerciseSetTemplates, isEmpty);
  //         expect(exerciseSetTemplates, isA<List<ExerciseSetTemplateModel>>());
  //       },
  //     );
  //   });
  //
  //   group('Update Operations', () {
  //     setUp(() async {
  //       await exerciseSetTemplateDao.insert(testExerciseSetTemplate);
  //     });
  //
  //     test(
  //       'should update existing exercise set template successfully',
  //       () async {
  //         final updatedExerciseSetTemplate = testExerciseSetTemplate.copyWith(
  //           setType: SetType.failure.name,
  //           units: Units.kilograms.name,
  //         );
  //
  //         await exerciseSetTemplateDao.update(updatedExerciseSetTemplate);
  //
  //         final retrieved = await exerciseSetTemplateDao.getById(
  //           testExerciseSetTemplate.id,
  //         );
  //         expectExerciseSetTemplatesEqual(
  //           retrieved,
  //           updatedExerciseSetTemplate,
  //         );
  //       },
  //     );
  //
  //     test(
  //       'should throw an exception when trying to update non-existent exercise set template',
  //       () async {
  //         final nonExistentExerciseSetTemplate = ExerciseSetTemplateModel(
  //           id: '99999',
  //           exerciseTemplateId: testExerciseTemplate.id,
  //           order: 1,
  //         );
  //
  //         expect(
  //           () async => await exerciseSetTemplateDao.update(
  //             nonExistentExerciseSetTemplate,
  //           ),
  //           throwsA(isA<Exception>()),
  //         );
  //       },
  //     );
  //   });
  //
  //   group('Batch Update Operations', () {
  //     test(
  //       'should batch update multiple exercise set templates correctly',
  //       () async {
  //         final exerciseSetTemplates = [
  //           ExerciseSetTemplateModel.forTest(
  //             exerciseTemplateId: testExerciseTemplate.id,
  //             order: 1,
  //             setType: SetType.warmup.name,
  //           ),
  //           ExerciseSetTemplateModel.forTest(
  //             exerciseTemplateId: testExerciseTemplate.id,
  //             order: 2,
  //             setType: SetType.working.name,
  //           ),
  //           ExerciseSetTemplateModel.forTest(
  //             exerciseTemplateId: testExerciseTemplate.id,
  //             order: 3,
  //             setType: SetType.working.name,
  //           ),
  //         ];
  //
  //         await exerciseSetTemplateDao.batchInsert(exerciseSetTemplates);
  //
  //         final updatedExerciseSetTemplates = [
  //           exerciseSetTemplates[0].copyWith(setType: SetType.working.name),
  //           exerciseSetTemplates[1].copyWith(setType: SetType.dropSet.name),
  //           exerciseSetTemplates[2].copyWith(setType: SetType.failure.name),
  //         ];
  //
  //         await exerciseSetTemplateDao.batchUpdate(updatedExerciseSetTemplates);
  //
  //         final retrieved1 = await exerciseSetTemplateDao.getById(
  //           exerciseSetTemplates[0].id,
  //         );
  //         final retrieved2 = await exerciseSetTemplateDao.getById(
  //           exerciseSetTemplates[1].id,
  //         );
  //         final retrieved3 = await exerciseSetTemplateDao.getById(
  //           exerciseSetTemplates[2].id,
  //         );
  //
  //         expectExerciseSetTemplatesEqual(
  //           retrieved1,
  //           updatedExerciseSetTemplates[0],
  //         );
  //         expectExerciseSetTemplatesEqual(
  //           retrieved2,
  //           updatedExerciseSetTemplates[1],
  //         );
  //         expectExerciseSetTemplatesEqual(
  //           retrieved3,
  //           updatedExerciseSetTemplates[2],
  //         );
  //       },
  //     );
  //
  //     test('should handle empty list gracefully in batch update', () async {
  //       await exerciseSetTemplateDao.insert(testExerciseSetTemplate);
  //
  //       await exerciseSetTemplateDao.batchUpdate([]);
  //
  //       final retrieved = await exerciseSetTemplateDao.getById(
  //         testExerciseSetTemplate.id,
  //       );
  //       expectExerciseSetTemplatesEqual(retrieved, testExerciseSetTemplate);
  //     });
  //
  //     test(
  //       'should throw exception and rollback all updates when one exercise set template does not exist',
  //       () async {
  //         final existingExerciseSetTemplate = ExerciseSetTemplateModel.forTest(
  //           exerciseTemplateId: testExerciseTemplate.id,
  //           order: 1,
  //           setType: SetType.warmup.name,
  //         );
  //         await exerciseSetTemplateDao.insert(existingExerciseSetTemplate);
  //
  //         final nonExistentExerciseSetTemplate = ExerciseSetTemplateModel(
  //           id: 'non-existent',
  //           exerciseTemplateId: testExerciseTemplate.id,
  //           order: 2,
  //         );
  //         final updatedExisting = existingExerciseSetTemplate.copyWith(
  //           setType: SetType.working.name,
  //         );
  //
  //         expect(
  //           () async => await exerciseSetTemplateDao.batchUpdate([
  //             updatedExisting,
  //             nonExistentExerciseSetTemplate,
  //           ]),
  //           throwsA(isA<Exception>()),
  //         );
  //
  //         // Verify rollback - original data unchanged
  //         final retrieved = await exerciseSetTemplateDao.getById(
  //           existingExerciseSetTemplate.id,
  //         );
  //         expect(retrieved!.setType, equals(SetType.warmup.name));
  //       },
  //     );
  //   });
  //
  //   group('Delete Operations', () {
  //     setUp(() async {
  //       await exerciseSetTemplateDao.insert(testExerciseSetTemplate);
  //     });
  //
  //     test(
  //       'should delete existing exercise set template successfully',
  //       () async {
  //         await exerciseSetTemplateDao.delete(testExerciseSetTemplate.id);
  //         final retrieved = await exerciseSetTemplateDao.getById(
  //           testExerciseSetTemplate.id,
  //         );
  //         expect(retrieved, isNull);
  //       },
  //     );
  //
  //     test(
  //       'should throw an exception when trying to delete non-existent exercise set template',
  //       () async {
  //         expect(
  //           () async => await exerciseSetTemplateDao.delete('99999'),
  //           throwsA(isA<Exception>()),
  //         );
  //       },
  //     );
  //   });
  //
  //   group('Foreign Key Constraints', () {
  //     test(
  //       'should CASCADE delete exercise set templates when exercise template is deleted',
  //       () async {
  //         await exerciseSetTemplateDao.insert(testExerciseSetTemplate);
  //
  //         // Verify exercise set template exists
  //         final beforeDelete = await exerciseSetTemplateDao.getById(
  //           testExerciseSetTemplate.id,
  //         );
  //         expect(beforeDelete, isNotNull);
  //
  //         // Delete the exercise template
  //         await exerciseTemplateDao.delete(testExerciseTemplate.id);
  //
  //         // Exercise set template should be automatically deleted due to CASCADE
  //         final afterDelete = await exerciseSetTemplateDao.getById(
  //           testExerciseSetTemplate.id,
  //         );
  //         expect(afterDelete, isNull);
  //       },
  //     );
  //   });
  // });
}
