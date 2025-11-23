import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/presentation/screens/workout_history/workout_history_state.dart';

class WorkoutHistoryWidget extends ConsumerStatefulWidget {
  const WorkoutHistoryWidget({super.key});

  @override
  ConsumerState<WorkoutHistoryWidget> createState() => WorkoutHistoryState();
}
