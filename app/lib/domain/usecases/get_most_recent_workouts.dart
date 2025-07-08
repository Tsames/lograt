import 'package:lograt/domain/entities/workout_summary.dart';
import '../../domain/repository/workout_repository.dart';

class GetMostRecentWorkouts {
  final WorkoutRepository _repository;

  GetMostRecentWorkouts(this._repository);

  Future<List<WorkoutSummary>> call() async {
    return await _repository.getMostRecentSummaries(20);
  }
}
