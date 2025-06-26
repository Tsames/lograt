import 'package:flutter_test/flutter_test.dart';
import 'package:lograt/data/models/workout_model.dart';
import 'package:lograt/domain/entities/workout.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:lograt/data/database/dao/workout_dao.dart';
import 'package:lograt/data/repositories/workout_repository_impl.dart';
import 'workout_repository_test.mocks.dart';

@GenerateMocks([WorkoutDao])
void main() {
  group('WorkoutRepository Tests', () {
    late WorkoutRepositoryImpl repository;
    late MockWorkoutDao mockDao;

    setUp(() {
      mockDao = MockWorkoutDao();
      repository = WorkoutRepositoryImpl(mockDao);
    });

    group('addWorkout', () {
      test('should call insertWorkout on the DAO with the provided workout', () async {
        final workout = Workout(id: 1, name: 'Test Workout', createdOn: DateTime.now());

        await repository.addWorkout(workout);

        // Capture what was actually passed to the DAO
        final captured = verify(mockDao.insert(captureAny)).captured.single as WorkoutModel;

        // Verify the properties match the original entity
        expect(captured.id, equals(workout.id));
        expect(captured.name, equals(workout.name));
        expect(captured.createdOn, equals(workout.createdOn));
      });
    });

    group('addWorkouts', () {
      test('should call insertWorkout for each workout in the list', () async {
        final workouts = [
          Workout(id: 1, name: 'Workout 1', createdOn: DateTime.now()),
          Workout(id: 2, name: 'Workout 2', createdOn: DateTime.now()),
          Workout(id: 3, name: 'Workout 3', createdOn: DateTime.now()),
        ];

        await repository.addWorkouts(workouts);

        final capturedCalls = verify(mockDao.insert(captureAny)).captured;

        expect(capturedCalls.length, equals(workouts.length));

        for (int i = 0; i < workouts.length; i++) {
          final capturedModel = capturedCalls[i] as WorkoutModel;
          final originalWorkout = workouts[i];

          // Verify the conversion was done correctly
          expect(capturedModel.id, equals(originalWorkout.id));
          expect(capturedModel.name, equals(originalWorkout.name));
          expect(capturedModel.createdOn, equals(originalWorkout.createdOn));
        }
      });

      test('should handle empty workout list without error', () async {
        final emptyWorkouts = <Workout>[];

        // Should not throw an exception
        expect(() => repository.addWorkouts(emptyWorkouts), returnsNormally);

        // Verify no DAO calls were made
        verifyNever(mockDao.insert(any));
      });
    });

    group('getMostRecentWorkouts', () {
      test('should return workouts sorted by creation date (newest first)', () async {
        final oldWorkout = WorkoutModel(id: 1, name: 'Old Workout', createdOn: DateTime(2023, 1, 1));
        final newerWorkout = WorkoutModel(id: 2, name: 'Newer Workout', createdOn: DateTime(2023, 6, 1));
        final newestWorkout = WorkoutModel(id: 3, name: 'Newest Workout', createdOn: DateTime(2023, 12, 1));

        // Set up the mock to return workouts in unsorted order
        final unsortedWorkouts = [oldWorkout, newestWorkout, newerWorkout];
        when(mockDao.getWorkouts()).thenAnswer((_) async => unsortedWorkouts);

        final result = await repository.getMostRecentSummaries();
        verify(mockDao.getWorkouts()).called(1);

        // Verify workouts are sorted correctly (newest first)
        expect(result.length, equals(3));
        expect(result[0].name, equals('Newest Workout'));
        expect(result[1].name, equals('Newer Workout'));
        expect(result[2].name, equals('Old Workout'));
      });

      test('should return empty list when DAO returns empty list', () async {
        when(mockDao.getWorkouts()).thenAnswer((_) async => <WorkoutModel>[]);

        final result = await repository.getMostRecentSummaries();

        verify(mockDao.getWorkouts()).called(1);
        expect(result, isEmpty);
      });
    });

    group('clearWorkouts', () {
      test('should call clearTable on the DAO', () async {
        await repository.clearWorkouts();

        verify(mockDao.clearTable()).called(1);
      });
    });

    group('seedWorkouts', () {
      test('should add all sample workouts from WorkoutSeed', () async {
        // This test assumes WorkoutSeed.sampleWorkouts is accessible
        // You might need to adjust based on your actual implementation

        await repository.seedWorkouts();

        // Verify insertWorkout was called for each sample workout
        verify(mockDao.insert(any)).called(greaterThan(0));
      });
    });

    group('Error Handling', () {
      test('should propagate exceptions from DAO operations', () async {
        when(mockDao.getWorkouts()).thenThrow(Exception('Database error'));

        expect(() => repository.getMostRecentSummaries(), throwsA(isA<Exception>()));
      });

      test('should handle DAO insertion failures', () async {
        final workout = Workout(id: 1, name: 'Test Workout', createdOn: DateTime.now());

        when(mockDao.insert(any)).thenThrow(Exception('Insert failed'));

        expect(() => repository.addWorkout(workout), throwsA(isA<Exception>()));
      });
    });
  });
}
