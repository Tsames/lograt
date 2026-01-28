import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/presentation/screens/create_workout/create_workout_widget_state.dart';

class CreateWorkoutWidget extends ConsumerStatefulWidget {
  const CreateWorkoutWidget({super.key});

  @override
  ConsumerState<CreateWorkoutWidget> createState() =>
      CreateWorkoutWidgetState();
}
