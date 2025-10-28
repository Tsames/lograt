import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/presentation/tabs/workout_history_tab/workout_history_tab_state.dart';

class WorkoutHistoryTabWidget extends ConsumerStatefulWidget {
  const WorkoutHistoryTabWidget({super.key});

  @override
  ConsumerState<WorkoutHistoryTabWidget> createState() =>
      WorkoutHistoryTabState();
}
