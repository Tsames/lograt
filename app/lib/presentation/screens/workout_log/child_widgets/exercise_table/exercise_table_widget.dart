import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/data/entities/exercise.dart';
import 'package:lograt/data/entities/workout.dart';
import 'package:lograt/presentation/screens/workout_log/child_widgets/exercise_table/exercise_table_state.dart';

class ExerciseTableWidget extends ConsumerStatefulWidget {
  final Workout workout;
  final Exercise exercise;

  const ExerciseTableWidget(this.workout, this.exercise, {super.key});

  @override
  ConsumerState<ExerciseTableWidget> createState() => ExerciseTableState();
}
