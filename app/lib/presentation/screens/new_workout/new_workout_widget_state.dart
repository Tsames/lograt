import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/data/entities/muscle_group.dart';
import 'package:lograt/data/entities/workouts/workout.dart';
import 'package:lograt/data/providers.dart';
import 'package:lograt/presentation/notifiers/muscle_groups_notifier.dart';
import 'package:lograt/presentation/screens/new_workout/new_workout_widget.dart';
import 'package:lograt/presentation/screens/workout_history/workout_history_drawer_page.dart';
import 'package:lograt/presentation/screens/workout_log/workout_log_widget.dart';
import 'package:lograt/util/extensions/human_friendly_date_format.dart';
import 'package:lograt/util/extensions/muscle_groups_colors_theme_extension.dart';

class NewWorkoutWidgetState extends ConsumerState<NewWorkoutWidget> {
  final _titleTextController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  bool _hasDefaultTitle = true;

  final Set<MuscleGroup> _selectedMuscleGroups = {};

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _titleTextController.text =
        '${_selectedDate.weekdayName} ${_selectedDate.timeOfDay} Workout';
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _createWorkout() async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final workout = Workout(
        date: _selectedDate,
        title: _titleTextController.text.trim(),
        notes: _notesController.text.trim().isNotEmpty
            ? _notesController.text.trim()
            : null,
        muscleGroups: _selectedMuscleGroups.toList(),
      );

      await ref.read(createWorkoutUsecaseProvider).call(workout);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WorkoutLogWidget(workout)),
        );
        widget.onCreateWorkout<WorkoutHistoryDrawerPage>();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to create workout: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final muscleGroupsState = ref.watch(muscleGroupsProvider);
    final muscleGroups = muscleGroupsState.muscleGroups;

    final now = DateTime.now();
    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 550),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Template selector (commented out for now)
          // Card(
          //   child: ListTile(
          //     leading: const Icon(Icons.content_copy),
          //     title: const Text('Use Template'),
          //     subtitle: const Text('Start from a saved workout template'),
          //     trailing: const Icon(Icons.chevron_right),
          //     onTap: () {
          //       // TODO: Show bottom sheet with template selection
          //     },
          //   ),
          // ),
          // const SizedBox(height: 24),
          const SizedBox(height: 8),
          Focus(
            onFocusChange: (hasFocus) {
              if (!hasFocus && _titleTextController.text == '') {
                setState(() {
                  _titleTextController.text =
                      '${_selectedDate.weekdayName} ${_selectedDate.timeOfDay} Workout';
                  _hasDefaultTitle = true;
                });
              } else if (hasFocus && _hasDefaultTitle) {
                setState(() {
                  _titleTextController.text = '';
                });
              }
            },
            child: TextField(
              controller: _titleTextController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {
                _hasDefaultTitle = false;
              }),
            ),
          ),
          const SizedBox(height: 32),
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(now.year - 1, 1, 1),
                lastDate: DateTime(now.year + 1, 12, 31),
              );
              if (picked != null) {
                setState(() {
                  _selectedDate = picked;
                });
              }
            },
            borderRadius: BorderRadius.circular(4),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Date',
                border: const OutlineInputBorder(),
                suffixIcon: const Icon(Icons.calendar_today),
              ),
              child: Text(_selectedDate.toLongFriendlyFormat()),
            ),
          ),
          const SizedBox(height: 24),
          Text('Muscle Groups', style: theme.textTheme.labelLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: muscleGroups.map((muscleGroup) {
              final isSelected = _selectedMuscleGroups.contains(muscleGroup);

              return FilterChip(
                label: Text(muscleGroup.label),
                selected: isSelected,
                onSelected: (_) => setState(() {
                  if (_selectedMuscleGroups.contains(muscleGroup)) {
                    _selectedMuscleGroups.remove(muscleGroup);
                  } else {
                    _selectedMuscleGroups.add(muscleGroup);
                  }
                }),
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                selectedColor: switch (muscleGroup.label) {
                  'Chest' =>
                    theme.extension<MuscleGroupColorsThemeExtension>()!.chest,
                  'Shoulders' =>
                    theme
                        .extension<MuscleGroupColorsThemeExtension>()!
                        .shoulders,
                  'Arms' =>
                    theme.extension<MuscleGroupColorsThemeExtension>()!.arms,
                  'Back' =>
                    theme.extension<MuscleGroupColorsThemeExtension>()!.back,
                  'Core' =>
                    theme.extension<MuscleGroupColorsThemeExtension>()!.core,
                  'Legs' =>
                    theme.extension<MuscleGroupColorsThemeExtension>()!.legs,
                  _ => theme.extension<MuscleGroupColorsThemeExtension>()!.misc,
                },
                labelStyle: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : theme.colorScheme.onSurface,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(
              labelText: 'Notes',
              hintText: 'Add any notes about this workout...',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: _createWorkout,
            icon: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : null,
            label: Text('Start Workout'),
          ),
        ],
      ),
    );
  }
}
