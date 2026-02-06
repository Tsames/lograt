void main() {
  // setUpAll(() async {
  //   sqfliteFfiInit();
  //   databaseFactory = databaseFactoryFfi;
  // });
  //
  // void expectExerciseSetsEqual(
  //   ExerciseSetModel? actual,
  //   ExerciseSetModel expected,
  // ) {
  //   expect(
  //     actual,
  //     isNotNull,
  //     reason: 'Expected exercise set to exist but got null',
  //   );
  //
  //   final actualMap = actual!.toMap();
  //   final expectedMap = expected.toMap();
  //
  //   for (final field in ExerciseSetFields.values) {
  //     expect(
  //       actualMap[field],
  //       equals(expectedMap[field]),
  //       reason: 'Field "$field" does not match',
  //     );
  //   }
  // }
  //
  // group('ExerciseSetDao Tests', () {
  //   late AppDatabase testDatabase;
  //   late ExerciseSetDao exerciseSetDao;
  //   late WorkoutDao workoutDao;
  //   late ExerciseTypeDao exerciseTypeDao;
  //   late ExerciseDao exerciseDao;
  //
  //   late WorkoutModel testWorkout;
  //   late ExerciseTypeModel testExerciseType;
  //   late ExerciseModel testExercise;
  //   late ExerciseSetModel testExerciseSet;
  //
  //   setUp(() async {
  //     testDatabase = AppDatabase.inMemory();
  //     exerciseSetDao = ExerciseSetDao(testDatabase);
  //     workoutDao = WorkoutDao(testDatabase);
  //     exerciseTypeDao = ExerciseTypeDao(testDatabase);
  //     exerciseDao = ExerciseDao(testDatabase);
  //
  //     testWorkout = WorkoutModel.forTest(title: 'Test Workout');
  //     await workoutDao.insert(testWorkout);
  //
  //     testExerciseType = ExerciseTypeModel.forTest(
  //       name: 'Bench Press',
  //       description: 'Chest exercise',
  //     );
  //     await exerciseTypeDao.insert(testExerciseType);
  //
  //     testExercise = ExerciseModel.forTest(
  //       workoutId: testWorkout.id,
  //       exerciseTypeId: testExerciseType.id,
  //       order: 1,
  //       notes: 'Test exercise',
  //     );
  //     await exerciseDao.insert(testExercise);
  //
  //     testExerciseSet = ExerciseSetModel.forTest(
  //       exerciseId: testExercise.id,
  //       order: 1,
  //       weight: 135.0,
  //       reps: 10,
  //     );
  //   });
  //
  //   tearDown(() async {
  //     await testDatabase.close();
  //   });
  //
  //   group('Insert Operations', () {
  //     test('should insert a new exercise set correctly', () async {
  //       await exerciseSetDao.insert(testExerciseSet);
  //
  //       final retrieved = await exerciseSetDao.getById(testExerciseSet.id);
  //       expectExerciseSetsEqual(retrieved, testExerciseSet);
  //     });
  //
  //     test('should handle inserting exercise set with minimal data', () async {
  //       final minimalExerciseSet = ExerciseSetModel.forTest(
  //         exerciseId: testExercise.id,
  //       );
  //
  //       await exerciseSetDao.insert(minimalExerciseSet);
  //
  //       final retrieved = await exerciseSetDao.getById(minimalExerciseSet.id);
  //       expectExerciseSetsEqual(retrieved, minimalExerciseSet);
  //     });
  //
  //     test(
  //       'should throw exception when inserting exercise set with duplicate id',
  //       () async {
  //         final otherExerciseSet = testExerciseSet.copyWith(
  //           order: testExerciseSet.order + 1,
  //         );
  //         await exerciseSetDao.insert(testExerciseSet);
  //         expect(
  //           () async => await exerciseSetDao.insert(otherExerciseSet),
  //           throwsA(isA<Exception>()),
  //         );
  //       },
  //     );
  //
  //     test('should handle transaction-based insert correctly', () async {
  //       final db = await testDatabase.database;
  //
  //       await db.transaction((txn) async {
  //         await exerciseSetDao.insert(testExerciseSet, txn);
  //         final retrieved = await exerciseSetDao.getById(
  //           testExerciseSet.id,
  //           txn,
  //         );
  //         expectExerciseSetsEqual(retrieved, testExerciseSet);
  //       });
  //
  //       // Verify it persisted after transaction
  //       final retrieved = await exerciseSetDao.getById(testExerciseSet.id);
  //       expectExerciseSetsEqual(retrieved, testExerciseSet);
  //     });
  //   });
  //
  //   group('Batch Insert Operations', () {
  //     test('should batch insert multiple exercise sets correctly', () async {
  //       final exerciseSets = [
  //         ExerciseSetModel.forTest(
  //           exerciseId: testExercise.id,
  //           order: 1,
  //           weight: 135.0,
  //         ),
  //         ExerciseSetModel.forTest(
  //           exerciseId: testExercise.id,
  //           order: 2,
  //           weight: 145.0,
  //         ),
  //         ExerciseSetModel.forTest(
  //           exerciseId: testExercise.id,
  //           order: 3,
  //           weight: 155.0,
  //         ),
  //       ];
  //
  //       await exerciseSetDao.batchInsert(exerciseSets);
  //
  //       final allExerciseSets = await exerciseSetDao.getAllSetsWithExerciseId(
  //         testExercise.id,
  //       );
  //       expect(allExerciseSets.length, equals(3));
  //       expect(allExerciseSets, everyElement(isA<ExerciseSetModel>()));
  //
  //       // Verify they're sorted by order ASC
  //       expectExerciseSetsEqual(allExerciseSets[0], exerciseSets[0]);
  //       expectExerciseSetsEqual(allExerciseSets[1], exerciseSets[1]);
  //       expectExerciseSetsEqual(allExerciseSets[2], exerciseSets[2]);
  //     });
  //
  //     test('should handle empty list gracefully in batch insert', () async {
  //       await exerciseSetDao.batchInsert([]);
  //
  //       final allExerciseSets = await exerciseSetDao.getAllSetsWithExerciseId(
  //         testExercise.id,
  //       );
  //       expect(allExerciseSets, isEmpty);
  //     });
  //
  //     test(
  //       'should batch insert exercise sets across multiple exercises',
  //       () async {
  //         final exercise2 = ExerciseModel.forTest(
  //           workoutId: testWorkout.id,
  //           order: 2,
  //         );
  //         await exerciseDao.insert(exercise2);
  //
  //         final exerciseSets = [
  //           ExerciseSetModel.forTest(exerciseId: testExercise.id, order: 1),
  //           ExerciseSetModel.forTest(exerciseId: exercise2.id, order: 1),
  //         ];
  //
  //         await exerciseSetDao.batchInsert(exerciseSets);
  //
  //         final exercise1Sets = await exerciseSetDao.getAllSetsWithExerciseId(
  //           testExercise.id,
  //         );
  //         final exercise2Sets = await exerciseSetDao.getAllSetsWithExerciseId(
  //           exercise2.id,
  //         );
  //
  //         expect(exercise1Sets.length, equals(1));
  //         expect(exercise2Sets.length, equals(1));
  //
  //         expectExerciseSetsEqual(exercise1Sets[0], exerciseSets[0]);
  //         expectExerciseSetsEqual(exercise2Sets[0], exerciseSets[1]);
  //       },
  //     );
  //
  //     test(
  //       'should throw exception when batch insert has duplicate id among valid exercise sets',
  //       () async {
  //         await exerciseSetDao.insert(testExerciseSet);
  //
  //         final exerciseSets = [
  //           ExerciseSetModel.forTest(exerciseId: testExercise.id, order: 1),
  //           testExerciseSet,
  //           ExerciseSetModel.forTest(exerciseId: testExercise.id, order: 2),
  //         ];
  //
  //         expect(
  //           () async => await exerciseSetDao.batchInsert(exerciseSets),
  //           throwsA(isA<DatabaseException>()),
  //         );
  //
  //         final allExerciseSets = await exerciseSetDao.getAllSetsWithExerciseId(
  //           testExercise.id,
  //         );
  //         expect(allExerciseSets.length, equals(1));
  //         expectExerciseSetsEqual(allExerciseSets.first, testExerciseSet);
  //       },
  //     );
  //   });
  //
  //   group('Read Operations', () {
  //     setUp(() async {
  //       await exerciseSetDao.insert(testExerciseSet);
  //     });
  //
  //     test('should retrieve exercise set by id correctly', () async {
  //       final retrieved = await exerciseSetDao.getById(testExerciseSet.id);
  //
  //       expectExerciseSetsEqual(retrieved, testExerciseSet);
  //     });
  //
  //     test('should return null when exercise set does not exist', () async {
  //       final nonExistent = await exerciseSetDao.getById('99999');
  //
  //       expect(nonExistent, isNull);
  //     });
  //
  //     test('should retrieve all exercise sets for an exercise', () async {
  //       final exercise2 = ExerciseModel.forTest(
  //         workoutId: testWorkout.id,
  //         order: 2,
  //       );
  //       await exerciseDao.insert(exercise2);
  //
  //       final exerciseSet2 = ExerciseSetModel.forTest(
  //         exerciseId: testExercise.id,
  //         order: 2,
  //       );
  //       final exerciseSet3 = ExerciseSetModel.forTest(
  //         exerciseId: testExercise.id,
  //         order: 3,
  //       );
  //       final exerciseSet4 = ExerciseSetModel.forTest(
  //         exerciseId: exercise2.id,
  //         order: 1,
  //       );
  //
  //       await exerciseSetDao.insert(exerciseSet2);
  //       await exerciseSetDao.insert(exerciseSet3);
  //       await exerciseSetDao.insert(exerciseSet4);
  //
  //       final allExerciseSets = await exerciseSetDao.getAllSetsWithExerciseId(
  //         testExercise.id,
  //       );
  //
  //       expect(allExerciseSets.length, equals(3));
  //       expect(allExerciseSets, everyElement(isA<ExerciseSetModel>()));
  //       expectExerciseSetsEqual(allExerciseSets[0], testExerciseSet);
  //       expectExerciseSetsEqual(allExerciseSets[1], exerciseSet2);
  //       expectExerciseSetsEqual(allExerciseSets[2], exerciseSet3);
  //     });
  //
  //     test('should return empty list when exercise has no sets', () async {
  //       final emptyExercise = ExerciseModel.forTest(
  //         workoutId: testWorkout.id,
  //         order: 2,
  //       );
  //       await exerciseDao.insert(emptyExercise);
  //
  //       final exerciseSets = await exerciseSetDao.getAllSetsWithExerciseId(
  //         emptyExercise.id,
  //       );
  //
  //       expect(exerciseSets, isEmpty);
  //       expect(exerciseSets, isA<List<ExerciseSetModel>>());
  //     });
  //   });
  //
  //   group('Update Operations', () {
  //     setUp(() async {
  //       await exerciseSetDao.insert(testExerciseSet);
  //     });
  //
  //     test('should update existing exercise set successfully', () async {
  //       final updatedExerciseSet = testExerciseSet.copyWith(
  //         weight: 145.0,
  //         reps: 12,
  //       );
  //
  //       await exerciseSetDao.update(updatedExerciseSet);
  //
  //       final retrieved = await exerciseSetDao.getById(testExerciseSet.id);
  //       expectExerciseSetsEqual(retrieved, updatedExerciseSet);
  //     });
  //
  //     test(
  //       'should throw an exception when trying to update non-existent exercise set',
  //       () async {
  //         final nonExistentExerciseSet = ExerciseSetModel(
  //           id: '99999',
  //           exerciseId: testExercise.id,
  //           order: 1,
  //         );
  //
  //         expect(
  //           () async => await exerciseSetDao.update(nonExistentExerciseSet),
  //           throwsA(isA<Exception>()),
  //         );
  //       },
  //     );
  //   });
  //
  //   group('Batch Update Operations', () {
  //     test('should batch update multiple exercise sets correctly', () async {
  //       final exerciseSets = [
  //         ExerciseSetModel.forTest(
  //           exerciseId: testExercise.id,
  //           order: 1,
  //           weight: 135.0,
  //         ),
  //         ExerciseSetModel.forTest(
  //           exerciseId: testExercise.id,
  //           order: 2,
  //           weight: 145.0,
  //         ),
  //         ExerciseSetModel.forTest(
  //           exerciseId: testExercise.id,
  //           order: 3,
  //           weight: 155.0,
  //         ),
  //       ];
  //
  //       await exerciseSetDao.batchInsert(exerciseSets);
  //
  //       final updatedExerciseSets = [
  //         exerciseSets[0].copyWith(weight: 140.0),
  //         exerciseSets[1].copyWith(weight: 150.0),
  //         exerciseSets[2].copyWith(weight: 160.0),
  //       ];
  //
  //       await exerciseSetDao.batchUpdate(updatedExerciseSets);
  //
  //       final retrieved1 = await exerciseSetDao.getById(exerciseSets[0].id);
  //       final retrieved2 = await exerciseSetDao.getById(exerciseSets[1].id);
  //       final retrieved3 = await exerciseSetDao.getById(exerciseSets[2].id);
  //
  //       expectExerciseSetsEqual(retrieved1, updatedExerciseSets[0]);
  //       expectExerciseSetsEqual(retrieved2, updatedExerciseSets[1]);
  //       expectExerciseSetsEqual(retrieved3, updatedExerciseSets[2]);
  //     });
  //
  //     test('should handle empty list gracefully in batch update', () async {
  //       await exerciseSetDao.insert(testExerciseSet);
  //
  //       await exerciseSetDao.batchUpdate([]);
  //
  //       final retrieved = await exerciseSetDao.getById(testExerciseSet.id);
  //       expectExerciseSetsEqual(retrieved, testExerciseSet);
  //     });
  //
  //     test(
  //       'should throw exception and rollback all updates when one exercise set does not exist',
  //       () async {
  //         final existingExerciseSet = ExerciseSetModel.forTest(
  //           exerciseId: testExercise.id,
  //           order: 1,
  //           weight: 135.0,
  //         );
  //         await exerciseSetDao.insert(existingExerciseSet);
  //
  //         final nonExistentExerciseSet = ExerciseSetModel(
  //           id: 'non-existent',
  //           exerciseId: testExercise.id,
  //           order: 2,
  //         );
  //         final updatedExisting = existingExerciseSet.copyWith(weight: 200.0);
  //
  //         expect(
  //           () async => await exerciseSetDao.batchUpdate([
  //             updatedExisting,
  //             nonExistentExerciseSet,
  //           ]),
  //           throwsA(isA<Exception>()),
  //         );
  //
  //         // Verify rollback - original data unchanged
  //         final retrieved = await exerciseSetDao.getById(
  //           existingExerciseSet.id,
  //         );
  //         expect(retrieved!.weight, equals(135.0));
  //       },
  //     );
  //   });
  //
  //   group('Delete Operations', () {
  //     setUp(() async {
  //       await exerciseSetDao.insert(testExerciseSet);
  //     });
  //
  //     test('should delete existing exercise set successfully', () async {
  //       await exerciseSetDao.delete(testExerciseSet.id);
  //       final retrieved = await exerciseSetDao.getById(testExerciseSet.id);
  //       expect(retrieved, isNull);
  //     });
  //
  //     test(
  //       'should throw an exception when trying to delete non-existent exercise set',
  //       () async {
  //         expect(
  //           () async => await exerciseSetDao.delete('99999'),
  //           throwsA(isA<Exception>()),
  //         );
  //       },
  //     );
  //   });
  //
  //   group('Foreign Key Constraints', () {
  //     test(
  //       'should CASCADE delete exercise sets when exercise is deleted',
  //       () async {
  //         await exerciseSetDao.insert(testExerciseSet);
  //
  //         // Verify exercise set exists
  //         final beforeDelete = await exerciseSetDao.getById(testExerciseSet.id);
  //         expect(beforeDelete, isNotNull);
  //
  //         // Delete the exercise
  //         await exerciseDao.delete(testExercise.id);
  //
  //         // Exercise set should be automatically deleted due to CASCADE
  //         final afterDelete = await exerciseSetDao.getById(testExerciseSet.id);
  //         expect(afterDelete, isNull);
  //       },
  //     );
  //   });
  // });
}
