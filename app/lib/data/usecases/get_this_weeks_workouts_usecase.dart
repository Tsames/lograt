import 'package:lograt/util/extensions/beginning_of_the_week.dart';

import '../entities/workout.dart';
import '../repositories/workout_repository_impl.dart';

class GetThisWeeksWorkoutsUsecase {
  final WorkoutRepository _repository;
  final int beginningOfTheWeekInMillisecondsSinceEpoch =
      DateTime.now().beginningOfTheWeek.millisecondsSinceEpoch;

  GetThisWeeksWorkoutsUsecase(this._repository);

  Future<List<Workout>> call() async {
    return await _repository.getWorkoutSummariesAfterTime(
      beginningOfTheWeekInMillisecondsSinceEpoch,
    );
  }
}
