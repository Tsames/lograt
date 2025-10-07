import 'package:lograt/domain/entities/exercise_type.dart';

import '../../domain/repository/workout_repository.dart';

class GetAllExerciseTypes {
  final WorkoutRepository _repository;

  GetAllExerciseTypes(this._repository);

  Future<List<ExerciseType>> call() async {
    return await _repository.getAllExerciseTypes();
  }
}
