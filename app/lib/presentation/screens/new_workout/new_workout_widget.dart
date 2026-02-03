import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/presentation/screens/new_workout/new_workout_widget_state.dart';

class NewWorkoutWidget extends ConsumerStatefulWidget {
  final void Function<T>() onCreateWorkout;

  const NewWorkoutWidget(this.onCreateWorkout, {super.key});

  @override
  ConsumerState<NewWorkoutWidget> createState() => NewWorkoutWidgetState();
}
