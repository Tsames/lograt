import 'package:flutter/foundation.dart';

import '../entities/workout.dart';
import '../repositories/workout_repository_impl.dart';

class GetFullWorkoutDataByIdUsecase {
  final WorkoutRepository _repository;

  GetFullWorkoutDataByIdUsecase(this._repository);

  Future<Workout> call(int id) async {
    final exerciseTypes = await _repository.getExerciseTypes();
    if (kDebugMode) {
      for (final exerciseType in exerciseTypes) {
        debugPrint(exerciseType.toString());
      }
    }
    return await _repository.getFullWorkoutDetails(id);
  }
}
