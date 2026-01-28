import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/data/entities/workouts/workout.dart';
import 'package:lograt/presentation/screens/workout_log/child_widgets/exercise_table/exercise_table_widget.dart';
import 'package:lograt/presentation/screens/workout_log/child_widgets/exercise_type_text_button.dart';
import 'package:lograt/presentation/screens/workout_log/workout_log_notifier.dart';
import 'package:lograt/util/extensions/human_friendly_date_format.dart';

class WorkoutLogWidget extends ConsumerWidget {
  final Workout workout;

  const WorkoutLogWidget(this.workout, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (kDebugMode) {
      debugPrint(
        'Building Workout Log for exercise: ${workout.id} - ${workout.title}',
      );
    }

    final exercises = ref.watch(
      workoutLogProvider(workout).select((state) => state.workout.exercises),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(workout.title ?? 'New Workout'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(16),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(workout.date.toLongFriendlyFormat()),
          ),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz))],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: ListView.separated(
            itemCount: exercises.length,
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: 20),
            itemBuilder: (BuildContext context, int index) {
              final exerciseId = exercises[index].id;
              return Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    children: [
                      ExerciseTypeTextButton(workout, exerciseId),
                      ExerciseTableWidget(workout, exercises[index]),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
