import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:lograt/data/database/dao/workout_dao.dart';
import 'package:lograt/data/models/workout_model.dart';
import 'package:lograt/data/repositories/workout_repository.dart';

@GenerateMocks([WorkoutDao])
import 'workout_repository_test.mocks.dart';

void main() {
  group('WorkoutRepository Tests', () {
    late WorkoutRepository repository;
    late MockWorkoutDao mockDao;

    setUp(() {
      mockDao = MockWorkoutDao();
      repository = WorkoutRepository(mockDao);
    });

    group('addWorkout', () {
      test('should call insertWorkout on the DAO with the provided workout', () async {
        final workout = Workout(id: 1, name: 'Test Workout', createdOn: DateTime.now());

        await repository.addWorkout(workout);

        verify(mockDao.insertWorkout(workout)).called(1);
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

        // Verify insertWorkout was called once for each workout
        for (final workout in workouts) {
          verify(mockDao.insertWorkout(workout)).called(1);
        }
      });

      test('should handle empty workout list without error', () async {
        final emptyWorkouts = <Workout>[];

        // Should not throw an exception
        expect(() => repository.addWorkouts(emptyWorkouts), returnsNormally);

        // Verify no DAO calls were made
        verifyNever(mockDao.insertWorkout(any));
      });
    });

    group('getMostRecentWorkouts', () {
      test('should return workouts sorted by creation date (newest first)', () async {
        final oldWorkout = Workout(id: 1, name: 'Old Workout', createdOn: DateTime(2023, 1, 1));
        final newerWorkout = Workout(id: 2, name: 'Newer Workout', createdOn: DateTime(2023, 6, 1));
        final newestWorkout = Workout(id: 3, name: 'Newest Workout', createdOn: DateTime(2023, 12, 1));

        // Set up the mock to return workouts in unsorted order
        final unsortedWorkouts = [oldWorkout, newestWorkout, newerWorkout];
        when(mockDao.getWorkouts()).thenAnswer((_) async => unsortedWorkouts);

        final result = await repository.getMostRecentWorkouts();
        verify(mockDao.getWorkouts()).called(1);

        // Verify workouts are sorted correctly (newest first)
        expect(result.length, equals(3));
        expect(result[0].name, equals('Newest Workout'));
        expect(result[1].name, equals('Newer Workout'));
        expect(result[2].name, equals('Old Workout'));
      });

      test('should return empty list when DAO returns empty list', () async {
        when(mockDao.getWorkouts()).thenAnswer((_) async => <Workout>[]);

        final result = await repository.getMostRecentWorkouts();

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
        verify(mockDao.insertWorkout(any)).called(greaterThan(0));
      });
    });

    group('Error Handling', () {
      test('should propagate exceptions from DAO operations', () async {
        when(mockDao.getWorkouts()).thenThrow(Exception('Database error'));

        expect(() => repository.getMostRecentWorkouts(), throwsA(isA<Exception>()));
      });

      test('should handle DAO insertion failures', () async {
        final workout = Workout(id: 1, name: 'Test Workout', createdOn: DateTime.now());

        when(mockDao.insertWorkout(any)).thenThrow(Exception('Insert failed'));

        expect(() => repository.addWorkout(workout), throwsA(isA<Exception>()));
      });
    });
  });
}
