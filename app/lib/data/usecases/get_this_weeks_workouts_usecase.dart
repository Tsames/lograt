import 'package:lograt/data/entities/workouts/workout.dart';
import 'package:lograt/data/repositories/workout_repository.dart';
import 'package:lograt/util/extensions/beginning_of_the_week.dart';

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
