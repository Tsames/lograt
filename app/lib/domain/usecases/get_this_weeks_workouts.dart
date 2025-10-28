import 'package:lograt/util/extensions/beginning_of_the_week.dart';

import '../../domain/repository/workout_repository.dart';
import '../entities/workout.dart';

class GetThisWeeksWorkouts {
  final WorkoutRepository _repository;
  final int beginningOfTheWeekInMillisecondsSinceEpoch =
      DateTime.now().beginningOfTheWeek.millisecondsSinceEpoch;

  GetThisWeeksWorkouts(this._repository);

  Future<List<Workout>> call() async {
    return await _repository.getWorkoutSummariesAfterTime(
      beginningOfTheWeekInMillisecondsSinceEpoch,
    );
  }
}
