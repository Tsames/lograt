// import 'package:flutter_test/flutter_test.dart';
// import 'package:lograt/data/dao/muscle_group/muscle_group_to_exercise_type_dao.dart';
// import 'package:lograt/data/dao/muscle_group/muscle_group_to_workout_dao.dart';
// import 'package:lograt/data/dao/muscle_group/muscle_group_to_workout_template_dao.dart';
// import 'package:lograt/data/dao/muscle_group/muscle_groups_dao.dart';
// import 'package:lograt/data/dao/templates/exercise_set_template_dao.dart';
// import 'package:lograt/data/dao/templates/exercise_template_dao.dart';
// import 'package:lograt/data/dao/templates/workout_template_dao.dart';
// import 'package:lograt/data/dao/workout/exercise_dao.dart';
// import 'package:lograt/data/dao/workout/exercise_set_dao.dart';
// import 'package:lograt/data/dao/workout/exercise_type_dao.dart';
// import 'package:lograt/data/dao/workout/workout_dao.dart';
// import 'package:lograt/data/database/app_database.dart';
// import 'package:lograt/data/models/muscle_group/muscle_group_model.dart';
// import 'package:lograt/data/models/muscle_group/muscle_group_to_workout_model.dart';
// import 'package:lograt/data/models/templates/workout_template_model.dart';
// import 'package:lograt/data/models/workouts/workout_model.dart';
// import 'package:lograt/data/repositories/workout_repository.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // setUpAll(() async {
  //   sqfliteFfiInit();
  //   databaseFactory = databaseFactoryFfi;
  // });
  //
  // group('WorkoutRepository.getWorkoutSummariesPaginated Tests', () {
  //   late AppDatabase testDatabase;
  //   late WorkoutRepository repository;
  //   late WorkoutDao workoutDao;
  //   late ExerciseTypeDao exerciseTypeDao;
  //   late ExerciseDao exerciseDao;
  //   late ExerciseSetDao exerciseSetDao;
  //
  //   late WorkoutTemplateDao workoutTemplateDao;
  //   late ExerciseTemplateDao exerciseTemplateDao;
  //   late ExerciseSetTemplateDao exerciseSetTemplateDao;
  //
  //   late MuscleGroupDao muscleGroupDao;
  //   late MuscleGroupToWorkoutDao muscleGroupToWorkoutDao;
  //   late MuscleGroupToWorkoutTemplateDao muscleGroupToWorkoutTemplateDao;
  //   late MuscleGroupToExerciseTypeDao muscleGroupToExerciseTypeDao;
  //
  //   setUp(() async {
  //     testDatabase = AppDatabase.inMemory();
  //     workoutDao = WorkoutDao(testDatabase);
  //     exerciseTypeDao = ExerciseTypeDao(testDatabase);
  //     exerciseDao = ExerciseDao(testDatabase);
  //     exerciseSetDao = ExerciseSetDao(testDatabase);
  //
  //     workoutTemplateDao = WorkoutTemplateDao(testDatabase);
  //     exerciseTemplateDao = ExerciseTemplateDao(testDatabase);
  //     exerciseSetTemplateDao = ExerciseSetTemplateDao(testDatabase);
  //
  //     muscleGroupDao = MuscleGroupDao(testDatabase);
  //     muscleGroupToWorkoutDao = MuscleGroupToWorkoutDao(testDatabase);
  //     muscleGroupToWorkoutTemplateDao = MuscleGroupToWorkoutTemplateDao(
  //       testDatabase,
  //     );
  //     muscleGroupToExerciseTypeDao = MuscleGroupToExerciseTypeDao(testDatabase);
  //
  //     repository = WorkoutRepository(
  //       databaseConnection: testDatabase,
  //       workoutDao: workoutDao,
  //       exerciseDao: exerciseDao,
  //       exerciseTypeDao: exerciseTypeDao,
  //       exerciseSetDao: exerciseSetDao,
  //       workoutTemplateDao: workoutTemplateDao,
  //       exerciseTemplateDao: exerciseTemplateDao,
  //       exerciseSetTemplateDao: exerciseSetTemplateDao,
  //       muscleGroupDao: muscleGroupDao,
  //       muscleGroupToWorkoutDao: muscleGroupToWorkoutDao,
  //       muscleGroupToWorkoutTemplateDao: muscleGroupToWorkoutTemplateDao,
  //       muscleGroupToExerciseTypeDao: muscleGroupToExerciseTypeDao,
  //     );
  //   });
  //
  //   tearDown(() async {
  //     await testDatabase.close();
  //   });
  //
  //   test('should return empty list when no workouts exist', () async {
  //     final results = await repository.getPaginatedSortedWorkoutSummaries();
  //
  //     expect(results, isEmpty);
  //   });
  //
  //   test('should return workouts with templates and muscle groups', () async {
  //     // Create test data
  //     final template = WorkoutTemplateModel.forTest(title: 'Push Day Template');
  //     await workoutTemplateDao.insert(template);
  //
  //     final muscleGroup1 = MuscleGroupModel.forTest(label: 'Chest');
  //     final muscleGroup2 = MuscleGroupModel.forTest(label: 'Triceps');
  //     await muscleGroupDao.batchInsert([muscleGroup1, muscleGroup2]);
  //
  //     final workout = WorkoutModel.forTest(
  //       title: 'Push Day',
  //       templateId: template.id,
  //     );
  //     await workoutDao.insert(workout);
  //
  //     await muscleGroupToWorkoutDao.batchInsertRelationships([
  //       MuscleGroupToWorkoutModel.createWithId(
  //         muscleGroupId: muscleGroup1.id,
  //         workoutId: workout.id,
  //       ),
  //       MuscleGroupToWorkoutModel.createWithId(
  //         muscleGroupId: muscleGroup2.id,
  //         workoutId: workout.id,
  //       ),
  //     ]);
  //
  //     // Test
  //     final results = await repository.getPaginatedSortedWorkoutSummaries();
  //
  //     expect(results.length, equals(1));
  //     expect(results[0].id, equals(workout.id));
  //     expect(results[0].title, equals('Push Day'));
  //     expect(results[0].template, isNotNull);
  //     expect(results[0].template!.id, equals(template.id));
  //     expect(results[0].template!.title, equals('Push Day Template'));
  //     expect(results[0].muscleGroups.length, equals(2));
  //     expect(
  //       results[0].muscleGroups.map((mg) => mg.label),
  //       containsAll(['Chest', 'Triceps']),
  //     );
  //   });
  //
  //   test(
  //     'should return workouts without templates when templateId is null',
  //     () async {
  //       final muscleGroup = MuscleGroupModel.forTest(label: 'Legs');
  //       await muscleGroupDao.insert(muscleGroup);
  //
  //       final workout = WorkoutModel.forTest(
  //         title: 'Leg Day',
  //         templateId: null,
  //       );
  //       await workoutDao.insert(workout);
  //
  //       await muscleGroupToWorkoutDao.insertRelationship(
  //         muscleGroupId: muscleGroup.id,
  //         workoutId: workout.id,
  //       );
  //
  //       final results = await repository.getPaginatedSortedWorkoutSummaries();
  //
  //       expect(results.length, equals(1));
  //       expect(results[0].template, isNull);
  //       expect(results[0].muscleGroups.length, equals(1));
  //       expect(results[0].muscleGroups[0].label, equals('Legs'));
  //     },
  //   );
  //
  //   test(
  //     'should return workouts without muscle groups when none assigned',
  //     () async {
  //       final template = WorkoutTemplateModel.forTest(title: 'Cardio Template');
  //       await workoutTemplateDao.insert(template);
  //
  //       final workout = WorkoutModel.forTest(
  //         title: 'Cardio Day',
  //         templateId: template.id,
  //       );
  //       await workoutDao.insert(workout);
  //
  //       final results = await repository.getPaginatedSortedWorkoutSummaries();
  //
  //       expect(results.length, equals(1));
  //       expect(results[0].template, isNotNull);
  //       expect(results[0].template!.title, equals('Cardio Template'));
  //       expect(results[0].muscleGroups, isEmpty);
  //     },
  //   );
  //
  //   test(
  //     'should handle mixed workouts - some with templates, some without',
  //     () async {
  //       final template = WorkoutTemplateModel.forTest(title: 'Upper Body');
  //       await workoutTemplateDao.insert(template);
  //
  //       final muscleGroup = MuscleGroupModel.forTest(label: 'Back');
  //       await muscleGroupDao.insert(muscleGroup);
  //
  //       final workoutWithTemplate = WorkoutModel.forTest(
  //         title: 'Pull Day',
  //         templateId: template.id,
  //         date: DateTime.now().subtract(Duration(days: 1)),
  //       );
  //       await workoutDao.insert(workoutWithTemplate);
  //
  //       final workoutWithoutTemplate = WorkoutModel.forTest(
  //         title: 'Custom Workout',
  //         templateId: null,
  //       );
  //       await workoutDao.insert(workoutWithoutTemplate);
  //
  //       await muscleGroupToWorkoutDao.insertRelationship(
  //         muscleGroupId: muscleGroup.id,
  //         workoutId: workoutWithTemplate.id,
  //       );
  //
  //       final results = await repository.getPaginatedSortedWorkoutSummaries();
  //
  //       expect(results.length, equals(2));
  //
  //       final withTemplate = results.firstWhere(
  //         (w) => w.id == workoutWithTemplate.id,
  //       );
  //       final withoutTemplate = results.firstWhere(
  //         (w) => w.id == workoutWithoutTemplate.id,
  //       );
  //
  //       expect(withTemplate.template, isNotNull);
  //       expect(withTemplate.muscleGroups.length, equals(1));
  //       expect(withoutTemplate.template, isNull);
  //       expect(withoutTemplate.muscleGroups, isEmpty);
  //     },
  //   );
  //
  //   test('should respect pagination limit', () async {
  //     final muscleGroup = MuscleGroupModel.forTest(label: 'Shoulders');
  //     await muscleGroupDao.insert(muscleGroup);
  //
  //     // Create 5 workouts
  //     for (int i = 0; i < 5; i++) {
  //       final workout = WorkoutModel.forTest(
  //         title: 'Workout $i',
  //         date: DateTime.now().subtract(Duration(days: i)),
  //       );
  //       await workoutDao.insert(workout);
  //       await muscleGroupToWorkoutDao.insertRelationship(
  //         muscleGroupId: muscleGroup.id,
  //         workoutId: workout.id,
  //       );
  //     }
  //
  //     final results = await repository.getPaginatedSortedWorkoutSummaries(
  //       limit: 3,
  //     );
  //
  //     expect(results.length, equals(3));
  //   });
  //
  //   test('should respect pagination offset', () async {
  //     // Create 5 workouts with distinct dates for ordering
  //     final workoutIds = <String>[];
  //     for (int i = 0; i < 5; i++) {
  //       final workout = WorkoutModel.forTest(
  //         title: 'Workout $i',
  //         date: DateTime.now().subtract(Duration(days: i)),
  //       );
  //       await workoutDao.insert(workout);
  //       workoutIds.add(workout.id);
  //     }
  //
  //     final firstPage = await repository.getPaginatedSortedWorkoutSummaries(
  //       limit: 2,
  //       offset: 0,
  //     );
  //     final secondPage = await repository.getPaginatedSortedWorkoutSummaries(
  //       limit: 2,
  //       offset: 2,
  //     );
  //
  //     expect(firstPage.length, equals(2));
  //     expect(secondPage.length, equals(2));
  //
  //     // Verify no overlap
  //     expect(firstPage[0].id, isNot(equals(secondPage[0].id)));
  //     expect(firstPage[0].id, isNot(equals(secondPage[1].id)));
  //     expect(firstPage[1].id, isNot(equals(secondPage[0].id)));
  //     expect(firstPage[1].id, isNot(equals(secondPage[1].id)));
  //   });
  //
  //   test('should order workouts by date descending (newest first)', () async {
  //     final oldWorkout = WorkoutModel.forTest(
  //       title: 'Old',
  //       date: DateTime(2023, 1, 1),
  //     );
  //     final middleWorkout = WorkoutModel.forTest(
  //       title: 'Middle',
  //       date: DateTime(2023, 6, 1),
  //     );
  //     final newestWorkout = WorkoutModel.forTest(
  //       title: 'Newest',
  //       date: DateTime(2023, 12, 1),
  //     );
  //
  //     await workoutDao.insert(middleWorkout);
  //     await workoutDao.insert(oldWorkout);
  //     await workoutDao.insert(newestWorkout);
  //
  //     final results = await repository.getPaginatedSortedWorkoutSummaries();
  //
  //     expect(results.length, equals(3));
  //     expect(results[0].title, equals('Newest'));
  //     expect(results[1].title, equals('Middle'));
  //     expect(results[2].title, equals('Old'));
  //   });
  //
  //   test('should handle multiple workouts sharing the same template', () async {
  //     final template = WorkoutTemplateModel.forTest(title: 'Shared Template');
  //     await workoutTemplateDao.insert(template);
  //
  //     final workout1 = WorkoutModel.forTest(
  //       title: 'Workout 1',
  //       templateId: template.id,
  //       date: DateTime.now().subtract(Duration(days: 1)),
  //     );
  //     final workout2 = WorkoutModel.forTest(
  //       title: 'Workout 2',
  //       templateId: template.id,
  //     );
  //
  //     await workoutDao.insert(workout1);
  //     await workoutDao.insert(workout2);
  //
  //     final results = await repository.getPaginatedSortedWorkoutSummaries();
  //
  //     expect(results.length, equals(2));
  //     expect(results[0].template, isNotNull);
  //     expect(results[0].template!.id, equals(template.id));
  //     expect(results[1].template, isNotNull);
  //     expect(results[1].template!.id, equals(template.id));
  //   });
  //
  //   test(
  //     'should handle multiple workouts sharing the same muscle groups',
  //     () async {
  //       final muscleGroup = MuscleGroupModel.forTest(label: 'Chest');
  //       await muscleGroupDao.insert(muscleGroup);
  //
  //       final workout1 = WorkoutModel.forTest(
  //         title: 'Workout 1',
  //         date: DateTime.now().subtract(Duration(days: 1)),
  //       );
  //       final workout2 = WorkoutModel.forTest(title: 'Workout 2');
  //
  //       await workoutDao.insert(workout1);
  //       await workoutDao.insert(workout2);
  //
  //       await muscleGroupToWorkoutDao.insertRelationship(
  //         muscleGroupId: muscleGroup.id,
  //         workoutId: workout1.id,
  //       );
  //       await muscleGroupToWorkoutDao.insertRelationship(
  //         muscleGroupId: muscleGroup.id,
  //         workoutId: workout2.id,
  //       );
  //
  //       final results = await repository.getPaginatedSortedWorkoutSummaries();
  //
  //       expect(results.length, equals(2));
  //       expect(results[0].muscleGroups.length, equals(1));
  //       expect(results[0].muscleGroups[0].label, equals('Chest'));
  //       expect(results[1].muscleGroups.length, equals(1));
  //       expect(results[1].muscleGroups[0].label, equals('Chest'));
  //     },
  //   );
  //
  //   test(
  //     'should handle workout with multiple muscle groups in correct order',
  //     () async {
  //       final muscleGroup1 = MuscleGroupModel.forTest(label: 'Chest');
  //       final muscleGroup2 = MuscleGroupModel.forTest(label: 'Triceps');
  //       final muscleGroup3 = MuscleGroupModel.forTest(label: 'Shoulders');
  //       await muscleGroupDao.insert(muscleGroup1);
  //       await muscleGroupDao.insert(muscleGroup2);
  //       await muscleGroupDao.insert(muscleGroup3);
  //
  //       final workout = WorkoutModel.forTest(title: 'Push Day');
  //       await workoutDao.insert(workout);
  //
  //       await muscleGroupToWorkoutDao.insertRelationship(
  //         muscleGroupId: muscleGroup1.id,
  //         workoutId: workout.id,
  //       );
  //       await muscleGroupToWorkoutDao.insertRelationship(
  //         muscleGroupId: muscleGroup2.id,
  //         workoutId: workout.id,
  //       );
  //       await muscleGroupToWorkoutDao.insertRelationship(
  //         muscleGroupId: muscleGroup3.id,
  //         workoutId: workout.id,
  //       );
  //
  //       final results = await repository.getPaginatedSortedWorkoutSummaries();
  //
  //       expect(results.length, equals(1));
  //       expect(results[0].muscleGroups.length, equals(3));
  //       expect(
  //         results[0].muscleGroups.map((mg) => mg.label),
  //         containsAll(['Chest', 'Triceps', 'Shoulders']),
  //       );
  //     },
  //   );
  //
  //   test('should omit exercises and sets from workout summaries', () async {
  //     final workout = WorkoutModel.forTest(title: 'Test Workout');
  //     await workoutDao.insert(workout);
  //
  //     final results = await repository.getPaginatedSortedWorkoutSummaries();
  //
  //     expect(results.length, equals(1));
  //     expect(results[0].exercises, isEmpty);
  //   });
  //
  //   test('should respect limit parameter', () async {
  //     // Create 5 workouts
  //     for (int i = 0; i < 5; i++) {
  //       final workout = WorkoutModel.forTest(title: 'Workout $i');
  //       await workoutDao.insert(workout);
  //     }
  //
  //     final results = await repository.getPaginatedSortedWorkoutSummaries(
  //       limit: 3,
  //     );
  //
  //     expect(results.length, equals(3));
  //   });
  //
  //   test('should respect offset parameter', () async {
  //     // Create workouts with specific dates to ensure ordering
  //     final workout1 = WorkoutModel.forTest(
  //       title: 'Newest',
  //       date: DateTime(2024, 1, 3),
  //     );
  //     final workout2 = WorkoutModel.forTest(
  //       title: 'Middle',
  //       date: DateTime(2024, 1, 2),
  //     );
  //     final workout3 = WorkoutModel.forTest(
  //       title: 'Oldest',
  //       date: DateTime(2024, 1, 1),
  //     );
  //
  //     await workoutDao.insert(workout1);
  //     await workoutDao.insert(workout2);
  //     await workoutDao.insert(workout3);
  //
  //     final results = await repository.getPaginatedSortedWorkoutSummaries(
  //       limit: 2,
  //       offset: 1,
  //     );
  //
  //     expect(results.length, equals(2));
  //     expect(results[0].title, equals('Middle'));
  //     expect(results[1].title, equals('Oldest'));
  //   });
  //
  //   test('should order workouts by date descending', () async {
  //     final oldWorkout = WorkoutModel.forTest(
  //       title: 'Old',
  //       date: DateTime(2024, 1, 1),
  //     );
  //     final newerWorkout = WorkoutModel.forTest(
  //       title: 'Newer',
  //       date: DateTime(2024, 1, 5),
  //     );
  //     final newestWorkout = WorkoutModel.forTest(
  //       title: 'Newest',
  //       date: DateTime(2024, 1, 10),
  //     );
  //
  //     await workoutDao.insert(oldWorkout);
  //     await workoutDao.insert(newerWorkout);
  //     await workoutDao.insert(newestWorkout);
  //
  //     final results = await repository.getPaginatedSortedWorkoutSummaries();
  //
  //     expect(results.length, equals(3));
  //     expect(results[0].title, equals('Newest'));
  //     expect(results[1].title, equals('Newer'));
  //     expect(results[2].title, equals('Old'));
  //   });
  //
  //   test('should handle workout with multiple muscle groups', () async {
  //     final muscleGroup1 = MuscleGroupModel.forTest(label: 'Chest');
  //     final muscleGroup2 = MuscleGroupModel.forTest(label: 'Shoulders');
  //     final muscleGroup3 = MuscleGroupModel.forTest(label: 'Triceps');
  //     await muscleGroupDao.insert(muscleGroup1);
  //     await muscleGroupDao.insert(muscleGroup2);
  //     await muscleGroupDao.insert(muscleGroup3);
  //
  //     final workout = WorkoutModel.forTest(title: 'Push Day');
  //     await workoutDao.insert(workout);
  //
  //     await muscleGroupToWorkoutDao.insertRelationship(
  //       muscleGroupId: muscleGroup1.id,
  //       workoutId: workout.id,
  //     );
  //     await muscleGroupToWorkoutDao.insertRelationship(
  //       muscleGroupId: muscleGroup2.id,
  //       workoutId: workout.id,
  //     );
  //     await muscleGroupToWorkoutDao.insertRelationship(
  //       muscleGroupId: muscleGroup3.id,
  //       workoutId: workout.id,
  //     );
  //
  //     final results = await repository.getPaginatedSortedWorkoutSummaries();
  //
  //     expect(results.length, equals(1));
  //     expect(results[0].muscleGroups.length, equals(3));
  //     expect(
  //       results[0].muscleGroups.map((mg) => mg.label),
  //       containsAll(['Chest', 'Shoulders', 'Triceps']),
  //     );
  //   });
  //
  //   test('should handle multiple workouts sharing the same template', () async {
  //     final sharedTemplate = WorkoutTemplateModel.forTest(title: 'Upper Body');
  //     await workoutTemplateDao.insert(sharedTemplate);
  //
  //     final workout1 = WorkoutModel.forTest(
  //       title: 'Monday Upper',
  //       templateId: sharedTemplate.id,
  //     );
  //     final workout2 = WorkoutModel.forTest(
  //       title: 'Friday Upper',
  //       templateId: sharedTemplate.id,
  //     );
  //     await workoutDao.insert(workout1);
  //     await workoutDao.insert(workout2);
  //
  //     final results = await repository.getPaginatedSortedWorkoutSummaries();
  //
  //     expect(results.length, equals(2));
  //     expect(results[0].template, isNotNull);
  //     expect(results[0].template!.title, equals('Upper Body'));
  //     expect(results[1].template, isNotNull);
  //     expect(results[1].template!.title, equals('Upper Body'));
  //   });
  //
  //   test(
  //     'should handle multiple workouts sharing the same muscle groups',
  //     () async {
  //       final muscleGroup = MuscleGroupModel.forTest(label: 'Chest');
  //       await muscleGroupDao.insert(muscleGroup);
  //
  //       final workout1 = WorkoutModel.forTest(title: 'Push Day 1');
  //       final workout2 = WorkoutModel.forTest(title: 'Push Day 2');
  //       await workoutDao.insert(workout1);
  //       await workoutDao.insert(workout2);
  //
  //       await muscleGroupToWorkoutDao.insertRelationship(
  //         muscleGroupId: muscleGroup.id,
  //         workoutId: workout1.id,
  //       );
  //       await muscleGroupToWorkoutDao.insertRelationship(
  //         muscleGroupId: muscleGroup.id,
  //         workoutId: workout2.id,
  //       );
  //
  //       final results = await repository.getPaginatedSortedWorkoutSummaries();
  //
  //       expect(results.length, equals(2));
  //       expect(results[0].muscleGroups.length, equals(1));
  //       expect(results[0].muscleGroups[0].label, equals('Chest'));
  //       expect(results[1].muscleGroups.length, equals(1));
  //       expect(results[1].muscleGroups[0].label, equals('Chest'));
  //     },
  //   );
  //
  //   test('should handle workout with notes and other fields', () async {
  //     final workout = WorkoutModel.forTest(
  //       title: 'Test Workout',
  //       notes: 'Felt strong today',
  //       date: DateTime(2024, 1, 15),
  //     );
  //     await workoutDao.insert(workout);
  //
  //     final results = await repository.getPaginatedSortedWorkoutSummaries();
  //
  //     expect(results.length, equals(1));
  //     expect(results[0].title, equals('Test Workout'));
  //     expect(results[0].notes, equals('Felt strong today'));
  //     expect(results[0].date, equals(DateTime(2024, 1, 15)));
  //   });
  // });
}
