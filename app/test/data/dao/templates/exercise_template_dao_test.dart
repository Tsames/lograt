void main() {
  // setUpAll(() async {
  //   sqfliteFfiInit();
  //   databaseFactory = databaseFactoryFfi;
  // });
  //
  // void expectExerciseTemplatesEqual(
  //   ExerciseTemplateModel? actual,
  //   ExerciseTemplateModel expected,
  // ) {
  //   expect(
  //     actual,
  //     isNotNull,
  //     reason: 'Expected exercise template to exist but got null',
  //   );
  //
  //   final actualMap = actual!.toMap();
  //   final expectedMap = expected.toMap();
  //
  //   for (final field in ExerciseTemplateFields.values) {
  //     expect(
  //       actualMap[field],
  //       equals(expectedMap[field]),
  //       reason: 'Field "$field" does not match',
  //     );
  //   }
  // }
  //
  // group('ExerciseTemplateDao Tests', () {
  //   late AppDatabase testDatabase;
  //   late ExerciseTemplateDao exerciseTemplateDao;
  //   late WorkoutTemplateDao workoutTemplateDao;
  //   late ExerciseTypeDao exerciseTypeDao;
  //
  //   late WorkoutTemplateModel testWorkoutTemplate;
  //   late ExerciseTypeModel testExerciseType;
  //   late ExerciseTemplateModel testExerciseTemplate;
  //
  //   setUp(() async {
  //     testDatabase = AppDatabase.inMemory();
  //     exerciseTemplateDao = ExerciseTemplateDao(testDatabase);
  //     workoutTemplateDao = WorkoutTemplateDao(testDatabase);
  //     exerciseTypeDao = ExerciseTypeDao(testDatabase);
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
  //   });
  //
  //   tearDown(() async {
  //     await testDatabase.close();
  //   });
  //
  //   group('Insert Operations', () {
  //     test('should insert a new exercise template correctly', () async {
  //       await exerciseTemplateDao.insert(testExerciseTemplate);
  //
  //       final retrieved = await exerciseTemplateDao.getById(
  //         testExerciseTemplate.id,
  //       );
  //       expectExerciseTemplatesEqual(retrieved, testExerciseTemplate);
  //     });
  //
  //     test(
  //       'should handle inserting exercise template with minimal data',
  //       () async {
  //         final minimalExerciseTemplate = ExerciseTemplateModel.forTest(
  //           workoutTemplateId: testWorkoutTemplate.id,
  //         );
  //
  //         await exerciseTemplateDao.insert(minimalExerciseTemplate);
  //
  //         final retrieved = await exerciseTemplateDao.getById(
  //           minimalExerciseTemplate.id,
  //         );
  //         expectExerciseTemplatesEqual(retrieved, minimalExerciseTemplate);
  //       },
  //     );
  //
  //     test(
  //       'should throw exception when inserting exercise template with duplicate id',
  //       () async {
  //         final otherExerciseTemplate = testExerciseTemplate.copyWith(
  //           order: testExerciseTemplate.order + 1,
  //         );
  //         await exerciseTemplateDao.insert(testExerciseTemplate);
  //         expect(
  //           () async => await exerciseTemplateDao.insert(otherExerciseTemplate),
  //           throwsA(isA<Exception>()),
  //         );
  //       },
  //     );
  //
  //     test('should handle transaction-based insert correctly', () async {
  //       final db = await testDatabase.database;
  //
  //       await db.transaction((txn) async {
  //         await exerciseTemplateDao.insert(testExerciseTemplate, txn);
  //         final retrieved = await exerciseTemplateDao.getById(
  //           testExerciseTemplate.id,
  //           txn,
  //         );
  //         expectExerciseTemplatesEqual(retrieved, testExerciseTemplate);
  //       });
  //
  //       // Verify it persisted after transaction
  //       final retrieved = await exerciseTemplateDao.getById(
  //         testExerciseTemplate.id,
  //       );
  //       expectExerciseTemplatesEqual(retrieved, testExerciseTemplate);
  //     });
  //   });
  //
  //   group('Batch Insert Operations', () {
  //     test(
  //       'should batch insert multiple exercise templates correctly',
  //       () async {
  //         final exerciseTemplates = [
  //           ExerciseTemplateModel.forTest(
  //             workoutTemplateId: testWorkoutTemplate.id,
  //             order: 1,
  //           ),
  //           ExerciseTemplateModel.forTest(
  //             workoutTemplateId: testWorkoutTemplate.id,
  //             order: 2,
  //           ),
  //           ExerciseTemplateModel.forTest(
  //             workoutTemplateId: testWorkoutTemplate.id,
  //             order: 3,
  //           ),
  //         ];
  //
  //         await exerciseTemplateDao.batchInsert(exerciseTemplates);
  //
  //         final allExerciseTemplates = await exerciseTemplateDao
  //             .getAllExerciseTemplatesWithWorkoutTemplateId(
  //               testWorkoutTemplate.id,
  //             );
  //         expect(allExerciseTemplates.length, equals(3));
  //         expect(
  //           allExerciseTemplates,
  //           everyElement(isA<ExerciseTemplateModel>()),
  //         );
  //         expectExerciseTemplatesEqual(
  //           allExerciseTemplates[0],
  //           exerciseTemplates[0],
  //         );
  //         expectExerciseTemplatesEqual(
  //           allExerciseTemplates[1],
  //           exerciseTemplates[1],
  //         );
  //         expectExerciseTemplatesEqual(
  //           allExerciseTemplates[2],
  //           exerciseTemplates[2],
  //         );
  //       },
  //     );
  //
  //     test('should handle empty list gracefully in batch insert', () async {
  //       await exerciseTemplateDao.batchInsert([]);
  //
  //       final allExerciseTemplates = await exerciseTemplateDao
  //           .getAllExerciseTemplatesWithWorkoutTemplateId(
  //             testWorkoutTemplate.id,
  //           );
  //       expect(allExerciseTemplates, isEmpty);
  //     });
  //
  //     test(
  //       'should batch insert exercise templates across multiple workout templates',
  //       () async {
  //         final workoutTemplate2 = WorkoutTemplateModel.forTest(
  //           title: 'Workout Template 2',
  //         );
  //         await workoutTemplateDao.insert(workoutTemplate2);
  //
  //         final exerciseTemplates = [
  //           ExerciseTemplateModel.forTest(
  //             workoutTemplateId: testWorkoutTemplate.id,
  //             order: 1,
  //           ),
  //           ExerciseTemplateModel.forTest(
  //             workoutTemplateId: workoutTemplate2.id,
  //             order: 1,
  //           ),
  //         ];
  //
  //         await exerciseTemplateDao.batchInsert(exerciseTemplates);
  //
  //         final template1Exercises = await exerciseTemplateDao
  //             .getAllExerciseTemplatesWithWorkoutTemplateId(
  //               testWorkoutTemplate.id,
  //             );
  //         final template2Exercises = await exerciseTemplateDao
  //             .getAllExerciseTemplatesWithWorkoutTemplateId(
  //               workoutTemplate2.id,
  //             );
  //
  //         expect(template1Exercises.length, equals(1));
  //         expect(template2Exercises.length, equals(1));
  //
  //         expectExerciseTemplatesEqual(
  //           template1Exercises[0],
  //           exerciseTemplates[0],
  //         );
  //         expectExerciseTemplatesEqual(
  //           template2Exercises[0],
  //           exerciseTemplates[1],
  //         );
  //       },
  //     );
  //
  //     test(
  //       'should throw exception when batch insert has duplicate id among valid exercise templates',
  //       () async {
  //         await exerciseTemplateDao.insert(testExerciseTemplate);
  //
  //         final exerciseTemplates = [
  //           ExerciseTemplateModel.forTest(
  //             workoutTemplateId: testWorkoutTemplate.id,
  //             order: 1,
  //           ),
  //           testExerciseTemplate,
  //           ExerciseTemplateModel.forTest(
  //             workoutTemplateId: testWorkoutTemplate.id,
  //             order: 2,
  //           ),
  //         ];
  //
  //         expect(
  //           () async =>
  //               await exerciseTemplateDao.batchInsert(exerciseTemplates),
  //           throwsA(isA<DatabaseException>()),
  //         );
  //
  //         final allExerciseTemplates = await exerciseTemplateDao
  //             .getAllExerciseTemplatesWithWorkoutTemplateId(
  //               testWorkoutTemplate.id,
  //             );
  //         expect(allExerciseTemplates.length, equals(1));
  //         expectExerciseTemplatesEqual(
  //           allExerciseTemplates.first,
  //           testExerciseTemplate,
  //         );
  //       },
  //     );
  //   });
  //
  //   group('Read Operations', () {
  //     setUp(() async {
  //       await exerciseTemplateDao.insert(testExerciseTemplate);
  //     });
  //
  //     test('should retrieve exercise template by id correctly', () async {
  //       final retrieved = await exerciseTemplateDao.getById(
  //         testExerciseTemplate.id,
  //       );
  //
  //       expectExerciseTemplatesEqual(retrieved, testExerciseTemplate);
  //     });
  //
  //     test(
  //       'should return null when exercise template does not exist',
  //       () async {
  //         final nonExistent = await exerciseTemplateDao.getById('99999');
  //
  //         expect(nonExistent, isNull);
  //       },
  //     );
  //
  //     test(
  //       'should retrieve all exercise templates for a workout template',
  //       () async {
  //         final workoutTemplate2 = WorkoutTemplateModel.forTest(
  //           title: 'Other Workout Template',
  //         );
  //         await workoutTemplateDao.insert(workoutTemplate2);
  //
  //         final exerciseTemplate2 = ExerciseTemplateModel.forTest(
  //           workoutTemplateId: testWorkoutTemplate.id,
  //           order: 2,
  //         );
  //         final exerciseTemplate3 = ExerciseTemplateModel.forTest(
  //           workoutTemplateId: testWorkoutTemplate.id,
  //           order: 3,
  //         );
  //         final exerciseTemplate4 = ExerciseTemplateModel.forTest(
  //           workoutTemplateId: workoutTemplate2.id,
  //           order: 1,
  //         );
  //
  //         await exerciseTemplateDao.insert(exerciseTemplate2);
  //         await exerciseTemplateDao.insert(exerciseTemplate3);
  //         await exerciseTemplateDao.insert(exerciseTemplate4);
  //
  //         final allExerciseTemplates = await exerciseTemplateDao
  //             .getAllExerciseTemplatesWithWorkoutTemplateId(
  //               testWorkoutTemplate.id,
  //             );
  //
  //         expect(allExerciseTemplates.length, equals(3));
  //         expect(
  //           allExerciseTemplates,
  //           everyElement(isA<ExerciseTemplateModel>()),
  //         );
  //         expectExerciseTemplatesEqual(
  //           allExerciseTemplates[0],
  //           testExerciseTemplate,
  //         );
  //         expectExerciseTemplatesEqual(
  //           allExerciseTemplates[1],
  //           exerciseTemplate2,
  //         );
  //         expectExerciseTemplatesEqual(
  //           allExerciseTemplates[2],
  //           exerciseTemplate3,
  //         );
  //       },
  //     );
  //
  //     test(
  //       'should return empty list when workout template has no exercise templates',
  //       () async {
  //         final emptyWorkoutTemplate = WorkoutTemplateModel.forTest(
  //           title: 'Empty Workout Template',
  //         );
  //         await workoutTemplateDao.insert(emptyWorkoutTemplate);
  //
  //         final exerciseTemplates = await exerciseTemplateDao
  //             .getAllExerciseTemplatesWithWorkoutTemplateId(
  //               emptyWorkoutTemplate.id,
  //             );
  //
  //         expect(exerciseTemplates, isEmpty);
  //         expect(exerciseTemplates, isA<List<ExerciseTemplateModel>>());
  //       },
  //     );
  //   });
  //
  //   group('Update Operations', () {
  //     setUp(() async {
  //       await exerciseTemplateDao.insert(testExerciseTemplate);
  //     });
  //
  //     test('should update existing exercise template successfully', () async {
  //       final updatedExerciseTemplate = testExerciseTemplate.copyWith(order: 5);
  //
  //       await exerciseTemplateDao.update(updatedExerciseTemplate);
  //
  //       final retrieved = await exerciseTemplateDao.getById(
  //         testExerciseTemplate.id,
  //       );
  //       expectExerciseTemplatesEqual(retrieved, updatedExerciseTemplate);
  //     });
  //
  //     test(
  //       'should throw an exception when trying to update non-existent exercise template',
  //       () async {
  //         final nonExistentExerciseTemplate = ExerciseTemplateModel(
  //           id: '99999',
  //           workoutTemplateId: testWorkoutTemplate.id,
  //           order: 1,
  //         );
  //
  //         expect(
  //           () async =>
  //               await exerciseTemplateDao.update(nonExistentExerciseTemplate),
  //           throwsA(isA<Exception>()),
  //         );
  //       },
  //     );
  //   });
  //
  //   group('Batch Update Operations', () {
  //     test(
  //       'should batch update multiple exercise templates correctly',
  //       () async {
  //         final exerciseTemplates = [
  //           ExerciseTemplateModel.forTest(
  //             workoutTemplateId: testWorkoutTemplate.id,
  //             order: 1,
  //           ),
  //           ExerciseTemplateModel.forTest(
  //             workoutTemplateId: testWorkoutTemplate.id,
  //             order: 2,
  //           ),
  //           ExerciseTemplateModel.forTest(
  //             workoutTemplateId: testWorkoutTemplate.id,
  //             order: 3,
  //           ),
  //         ];
  //
  //         await exerciseTemplateDao.batchInsert(exerciseTemplates);
  //
  //         final updatedExerciseTemplates = [
  //           exerciseTemplates[0].copyWith(order: 10),
  //           exerciseTemplates[1].copyWith(order: 20),
  //           exerciseTemplates[2].copyWith(order: 30),
  //         ];
  //
  //         await exerciseTemplateDao.batchUpdate(updatedExerciseTemplates);
  //
  //         final retrieved1 = await exerciseTemplateDao.getById(
  //           exerciseTemplates[0].id,
  //         );
  //         final retrieved2 = await exerciseTemplateDao.getById(
  //           exerciseTemplates[1].id,
  //         );
  //         final retrieved3 = await exerciseTemplateDao.getById(
  //           exerciseTemplates[2].id,
  //         );
  //
  //         expectExerciseTemplatesEqual(retrieved1, updatedExerciseTemplates[0]);
  //         expectExerciseTemplatesEqual(retrieved2, updatedExerciseTemplates[1]);
  //         expectExerciseTemplatesEqual(retrieved3, updatedExerciseTemplates[2]);
  //       },
  //     );
  //
  //     test('should handle empty list gracefully in batch update', () async {
  //       await exerciseTemplateDao.insert(testExerciseTemplate);
  //
  //       await exerciseTemplateDao.batchUpdate([]);
  //
  //       final retrieved = await exerciseTemplateDao.getById(
  //         testExerciseTemplate.id,
  //       );
  //       expectExerciseTemplatesEqual(retrieved, testExerciseTemplate);
  //     });
  //
  //     test(
  //       'should throw exception and rollback all updates when one exercise template does not exist',
  //       () async {
  //         final existingExerciseTemplate = ExerciseTemplateModel.forTest(
  //           workoutTemplateId: testWorkoutTemplate.id,
  //           order: 1,
  //         );
  //         await exerciseTemplateDao.insert(existingExerciseTemplate);
  //
  //         final nonExistentExerciseTemplate = ExerciseTemplateModel(
  //           id: 'non-existent',
  //           workoutTemplateId: testWorkoutTemplate.id,
  //           order: 2,
  //         );
  //         final updatedExisting = existingExerciseTemplate.copyWith(order: 10);
  //
  //         expect(
  //           () async => await exerciseTemplateDao.batchUpdate([
  //             updatedExisting,
  //             nonExistentExerciseTemplate,
  //           ]),
  //           throwsA(isA<Exception>()),
  //         );
  //
  //         // Verify rollback - original data unchanged
  //         final retrieved = await exerciseTemplateDao.getById(
  //           existingExerciseTemplate.id,
  //         );
  //         expect(retrieved!.order, equals(1));
  //       },
  //     );
  //   });
  //
  //   group('Delete Operations', () {
  //     setUp(() async {
  //       await exerciseTemplateDao.insert(testExerciseTemplate);
  //     });
  //
  //     test('should delete existing exercise template successfully', () async {
  //       await exerciseTemplateDao.delete(testExerciseTemplate.id);
  //       final retrieved = await exerciseTemplateDao.getById(
  //         testExerciseTemplate.id,
  //       );
  //       expect(retrieved, isNull);
  //     });
  //
  //     test(
  //       'should throw an exception when trying to delete non-existent exercise template',
  //       () async {
  //         expect(
  //           () async => await exerciseTemplateDao.delete('99999'),
  //           throwsA(isA<Exception>()),
  //         );
  //       },
  //     );
  //   });
  //
  //   group('Foreign Key Constraints', () {
  //     test(
  //       'should CASCADE delete exercise templates when workout template is deleted',
  //       () async {
  //         await exerciseTemplateDao.insert(testExerciseTemplate);
  //
  //         // Verify exercise template exists
  //         final beforeDelete = await exerciseTemplateDao.getById(
  //           testExerciseTemplate.id,
  //         );
  //         expect(beforeDelete, isNotNull);
  //
  //         // Delete the workout template
  //         await workoutTemplateDao.delete(testWorkoutTemplate.id);
  //
  //         // Exercise template should be automatically deleted due to CASCADE
  //         final afterDelete = await exerciseTemplateDao.getById(
  //           testExerciseTemplate.id,
  //         );
  //         expect(afterDelete, isNull);
  //       },
  //     );
  //
  //     test(
  //       'should CASCADE delete exercise templates when exercise type is deleted',
  //       () async {
  //         await exerciseTemplateDao.insert(testExerciseTemplate);
  //
  //         // Verify exercise template exists
  //         final beforeDelete = await exerciseTemplateDao.getById(
  //           testExerciseTemplate.id,
  //         );
  //         expect(beforeDelete, isNotNull);
  //
  //         // Delete the exercise type
  //         await exerciseTypeDao.delete(testExerciseType.id);
  //
  //         // Exercise template should be automatically deleted due to CASCADE
  //         final afterDelete = await exerciseTemplateDao.getById(
  //           testExerciseTemplate.id,
  //         );
  //         expect(afterDelete, isNull);
  //       },
  //     );
  //   });
  // });
}
