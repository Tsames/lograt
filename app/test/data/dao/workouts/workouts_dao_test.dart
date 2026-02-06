void main() {
  // setUpAll(() async {
  //   sqfliteFfiInit();
  //   databaseFactory = databaseFactoryFfi;
  // });
  //
  // void expectWorkoutsEqual(WorkoutModel? actual, WorkoutModel expected) {
  //   expect(actual, isNotNull, reason: 'Expected workout to exist but got null');
  //
  //   final actualMap = actual!.toMap();
  //   final expectedMap = expected.toMap();
  //
  //   for (final field in WorkoutFields.values) {
  //     expect(
  //       actualMap[field],
  //       equals(expectedMap[field]),
  //       reason: 'Field "$field" does not match',
  //     );
  //   }
  // }
  //
  // group('WorkoutDao Tests', () {
  //   late AppDatabase testDatabase;
  //   late WorkoutDao workoutDao;
  //   late WorkoutModel testWorkout;
  //
  //   setUp(() async {
  //     testDatabase = AppDatabase.inMemory();
  //     workoutDao = WorkoutDao(testDatabase);
  //
  //     testWorkout = WorkoutModel.forTest(
  //       title: 'Test Workout',
  //       notes: 'Test notes',
  //     );
  //   });
  //
  //   tearDown(() async {
  //     await testDatabase.close();
  //   });
  //
  //   group('Insert Operations', () {
  //     test('should insert a new workout correctly', () async {
  //       await workoutDao.insert(testWorkout);
  //
  //       final retrieved = await workoutDao.getById(testWorkout.id);
  //       expectWorkoutsEqual(retrieved, testWorkout);
  //     });
  //
  //     test('should handle inserting workout with minimal data', () async {
  //       final minimalWorkout = WorkoutModel.forTest();
  //
  //       await workoutDao.insert(minimalWorkout);
  //
  //       final retrieved = await workoutDao.getById(minimalWorkout.id);
  //       expectWorkoutsEqual(retrieved, minimalWorkout);
  //     });
  //
  //     test(
  //       'should throw exception when inserting workout with duplicate id',
  //       () async {
  //         final otherWorkout = testWorkout.copyWith(title: 'Different Title');
  //         await workoutDao.insert(testWorkout);
  //         expect(
  //           () async => await workoutDao.insert(otherWorkout),
  //           throwsA(isA<Exception>()),
  //         );
  //       },
  //     );
  //
  //     test('should handle transaction-based insert correctly', () async {
  //       final db = await testDatabase.database;
  //
  //       await db.transaction((txn) async {
  //         await workoutDao.insert(testWorkout, txn);
  //         final retrieved = await workoutDao.getById(testWorkout.id, txn);
  //         expectWorkoutsEqual(retrieved, testWorkout);
  //       });
  //
  //       // Verify it persisted after transaction
  //       final retrieved = await workoutDao.getById(testWorkout.id);
  //       expectWorkoutsEqual(retrieved, testWorkout);
  //     });
  //   });
  //
  //   group('Batch Insert Operations', () {
  //     test('should batch insert multiple workouts correctly', () async {
  //       final now = DateTime.now();
  //
  //       final workouts = [
  //         WorkoutModel.forTest(title: 'Workout 1'),
  //         WorkoutModel.forTest(
  //           title: 'Workout 2',
  //           date: now.add(Duration(days: 1)),
  //         ),
  //         WorkoutModel.forTest(
  //           title: 'Workout 3',
  //           date: now.add(Duration(days: 2)),
  //         ),
  //       ];
  //
  //       await workoutDao.batchInsert(workouts);
  //
  //       final allWorkouts = await workoutDao.getAllPaginatedOrderedByDate();
  //       expect(allWorkouts.length, equals(3));
  //       expect(allWorkouts, everyElement(isA<WorkoutModel>()));
  //
  //       // Verify they're sorted by date DESC (most recent first)
  //       expect(allWorkouts[0].title, equals('Workout 3'));
  //       expect(allWorkouts[1].title, equals('Workout 2'));
  //       expect(allWorkouts[2].title, equals('Workout 1'));
  //     });
  //
  //     test('should handle empty list gracefully in batch insert', () async {
  //       await workoutDao.batchInsert([]);
  //
  //       final allWorkouts = await workoutDao.getAllPaginatedOrderedByDate();
  //       expect(allWorkouts, isEmpty);
  //     });
  //
  //     test(
  //       'should throw database exception when batch insert has duplicate id among valid workouts',
  //       () async {
  //         await workoutDao.insert(testWorkout);
  //
  //         final workouts = [
  //           WorkoutModel.forTest(title: 'Workout 1'),
  //           testWorkout,
  //           WorkoutModel.forTest(title: 'Workout 2'),
  //         ];
  //
  //         expect(
  //           () async => await workoutDao.batchInsert(workouts),
  //           throwsA(isA<DatabaseException>()),
  //         );
  //
  //         final allWorkouts = await workoutDao.getAllPaginatedOrderedByDate();
  //         expect(allWorkouts.length, equals(1));
  //         expectWorkoutsEqual(allWorkouts.first, testWorkout);
  //       },
  //     );
  //   });
  //
  //   group('Read Operations', () {
  //     setUp(() async {
  //       await workoutDao.insert(testWorkout);
  //     });
  //
  //     test('should retrieve workout by id correctly', () async {
  //       final retrieved = await workoutDao.getById(testWorkout.id);
  //
  //       expectWorkoutsEqual(retrieved, testWorkout);
  //     });
  //
  //     test('should return null when workout does not exist', () async {
  //       final nonExistent = await workoutDao.getById('99999');
  //
  //       expect(nonExistent, isNull);
  //     });
  //
  //     test(
  //       'should retrieve all workouts ordered by creation date descending',
  //       () async {
  //         final workout1 = WorkoutModel(
  //           id: 'workout-1',
  //           date: DateTime(2024, 1, 1),
  //           title: 'Old Workout',
  //         );
  //         final workout2 = WorkoutModel(
  //           id: 'workout-2',
  //           date: DateTime(2024, 6, 1),
  //           title: 'Mid Workout',
  //         );
  //         final workout3 = WorkoutModel(
  //           id: 'workout-3',
  //           date: DateTime(2024, 12, 1),
  //           title: 'Recent Workout',
  //         );
  //
  //         await workoutDao.insert(workout1);
  //         await workoutDao.insert(workout2);
  //         await workoutDao.insert(workout3);
  //
  //         final allWorkouts = await workoutDao.getAllPaginatedOrderedByDate();
  //
  //         expect(allWorkouts.length, equals(4)); // Including testWorkout
  //         expect(allWorkouts, everyElement(isA<WorkoutModel>()));
  //
  //         // Verify descending order (most recent first)
  //         expectWorkoutsEqual(allWorkouts[0], testWorkout);
  //         expectWorkoutsEqual(allWorkouts[1], workout3);
  //         expectWorkoutsEqual(allWorkouts[2], workout2);
  //         expectWorkoutsEqual(allWorkouts[3], workout1);
  //       },
  //     );
  //
  //     test('should return empty list when no workouts exist', () async {
  //       await workoutDao.delete(testWorkout.id);
  //
  //       final workouts = await workoutDao.getAllPaginatedOrderedByDate();
  //
  //       expect(workouts, isEmpty);
  //       expect(workouts, isA<List<WorkoutModel>>());
  //     });
  //
  //     test('should respect pagination limit and offset', () async {
  //       final workouts = [
  //         WorkoutModel(
  //           id: 'w1',
  //           date: DateTime(2024, 1, 1),
  //           title: 'Workout 1',
  //         ),
  //         WorkoutModel(
  //           id: 'w2',
  //           date: DateTime(2024, 2, 1),
  //           title: 'Workout 2',
  //         ),
  //         WorkoutModel(
  //           id: 'w3',
  //           date: DateTime(2024, 3, 1),
  //           title: 'Workout 3',
  //         ),
  //         WorkoutModel(
  //           id: 'w4',
  //           date: DateTime(2024, 4, 1),
  //           title: 'Workout 4',
  //         ),
  //       ];
  //
  //       await workoutDao.batchInsert(workouts);
  //
  //       // Get first 2 (most recent)
  //       final page1 = await workoutDao.getAllPaginatedOrderedByDate(
  //         limit: 2,
  //         offset: 0,
  //       );
  //       expect(page1.length, equals(2));
  //       expectWorkoutsEqual(page1[0], testWorkout);
  //       expectWorkoutsEqual(page1[1], workouts[3]);
  //
  //       // Get next 2
  //       final page2 = await workoutDao.getAllPaginatedOrderedByDate(
  //         limit: 2,
  //         offset: 2,
  //       );
  //       expect(page2.length, equals(2));
  //       expectWorkoutsEqual(page2[0], workouts[2]);
  //       expectWorkoutsEqual(page2[1], workouts[1]);
  //     });
  //   });
  //
  //   group('Update Operations', () {
  //     setUp(() async {
  //       await workoutDao.insert(testWorkout);
  //     });
  //
  //     test('should update existing workout successfully', () async {
  //       final updatedWorkout = testWorkout.copyWith(
  //         title: 'Updated Title',
  //         notes: 'Updated notes',
  //       );
  //
  //       await workoutDao.update(updatedWorkout);
  //
  //       final retrieved = await workoutDao.getById(testWorkout.id);
  //       expectWorkoutsEqual(retrieved, updatedWorkout);
  //     });
  //
  //     test(
  //       'should throw an exception when trying to update non-existent workout',
  //       () async {
  //         final nonExistentWorkout = WorkoutModel(
  //           id: '99999',
  //           date: DateTime.now(),
  //         );
  //
  //         expect(
  //           () async => await workoutDao.update(nonExistentWorkout),
  //           throwsA(isA<Exception>()),
  //         );
  //       },
  //     );
  //   });
  //
  //   group('Batch Update Operations', () {
  //     test('should batch update multiple workouts correctly', () async {
  //       final workouts = [
  //         WorkoutModel.forTest(title: 'Original 1'),
  //         WorkoutModel.forTest(title: 'Original 2'),
  //         WorkoutModel.forTest(title: 'Original 3'),
  //       ];
  //
  //       await workoutDao.batchInsert(workouts);
  //
  //       final updatedWorkouts = [
  //         workouts[0].copyWith(title: 'Updated 1'),
  //         workouts[1].copyWith(title: 'Updated 2'),
  //         workouts[2].copyWith(title: 'Updated 3'),
  //       ];
  //
  //       await workoutDao.batchUpdate(updatedWorkouts);
  //
  //       final retrieved1 = await workoutDao.getById(workouts[0].id);
  //       final retrieved2 = await workoutDao.getById(workouts[1].id);
  //       final retrieved3 = await workoutDao.getById(workouts[2].id);
  //
  //       expectWorkoutsEqual(retrieved1, updatedWorkouts[0]);
  //       expectWorkoutsEqual(retrieved2, updatedWorkouts[1]);
  //       expectWorkoutsEqual(retrieved3, updatedWorkouts[2]);
  //     });
  //
  //     test('should handle empty list gracefully in batch update', () async {
  //       await workoutDao.insert(testWorkout);
  //
  //       await workoutDao.batchUpdate([]);
  //
  //       final retrieved = await workoutDao.getById(testWorkout.id);
  //       expectWorkoutsEqual(retrieved, testWorkout);
  //     });
  //
  //     test(
  //       'should throw exception and rollback all updates when one workout does not exist',
  //       () async {
  //         final existingWorkout = WorkoutModel.forTest(title: 'Original');
  //         await workoutDao.insert(existingWorkout);
  //
  //         final nonExistentWorkout = WorkoutModel(
  //           id: 'non-existent',
  //           date: DateTime.now(),
  //         );
  //         final updatedExisting = existingWorkout.copyWith(
  //           title: 'Should not persist',
  //         );
  //
  //         expect(
  //           () async => await workoutDao.batchUpdate([
  //             updatedExisting,
  //             nonExistentWorkout,
  //           ]),
  //           throwsA(isA<Exception>()),
  //         );
  //
  //         // Verify rollback - original data unchanged
  //         final retrieved = await workoutDao.getById(existingWorkout.id);
  //         expect(retrieved!.title, equals('Original'));
  //       },
  //     );
  //   });
  //
  //   group('Delete Operations', () {
  //     setUp(() async {
  //       await workoutDao.insert(testWorkout);
  //     });
  //
  //     test('should delete existing workout successfully', () async {
  //       await workoutDao.delete(testWorkout.id);
  //       final retrieved = await workoutDao.getById(testWorkout.id);
  //       expect(retrieved, isNull);
  //     });
  //
  //     test(
  //       'should throw an exception when trying to delete non-existent workout',
  //       () async {
  //         expect(
  //           () async => await workoutDao.delete('99999'),
  //           throwsA(isA<Exception>()),
  //         );
  //       },
  //     );
  //   });
  //
  //   group('Foreign Key Constraints', () {
  //     late WorkoutTemplateDao workoutTemplateDao;
  //
  //     setUp(() {
  //       workoutTemplateDao = WorkoutTemplateDao(testDatabase);
  //     });
  //
  //     test(
  //       'should SET NULL on workout templateId when template is deleted',
  //       () async {
  //         final template = WorkoutTemplateModel.forTest(title: 'Test Template');
  //         await workoutTemplateDao.insert(template);
  //
  //         final workoutWithTemplate = WorkoutModel.forTest(
  //           title: 'Workout from template',
  //           templateId: template.id,
  //         );
  //         await workoutDao.insert(workoutWithTemplate);
  //
  //         // Verify workout has template
  //         final beforeDelete = await workoutDao.getById(workoutWithTemplate.id);
  //         expect(beforeDelete!.templateId, equals(template.id));
  //
  //         // Delete the template
  //         await workoutTemplateDao.delete(template.id);
  //
  //         // Workout should still exist but templateId should be null
  //         final afterDelete = await workoutDao.getById(workoutWithTemplate.id);
  //         expect(afterDelete, isNotNull);
  //         expect(afterDelete!.templateId, isNull);
  //       },
  //     );
  //   });
  // });
}
