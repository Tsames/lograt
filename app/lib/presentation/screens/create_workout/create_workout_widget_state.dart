import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/presentation/screens/create_workout/create_workout_widget.dart';
import 'package:lograt/util/extensions/human_friendly_date_format.dart';

class CreateWorkoutWidgetState extends ConsumerState<CreateWorkoutWidget> {
  final _titleTextController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _selectedDate;

  DateTime get _effectiveDate => _selectedDate ?? DateTime.now();

  void setDefaultWorkoutTitle() {
    _titleTextController.text =
        '${_effectiveDate.weekdayName} ${_effectiveDate.timeOfDay} Workout';
  }

  @override
  void initState() {
    super.initState();
    setDefaultWorkoutTitle();
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // List<MuscleGroup> get _selectedMuscleGroupEntities {
  //   return _availableMuscleGroups.where((mg) => _selectedMuscleGroups.contains(mg.label)).toList();
  // }

  // Future<void> _selectDate(BuildContext context) async {
  //   final picked = await showDatePicker(
  //     context: context,
  //     initialDate: _effectiveDate,
  //     firstDate: DateTime(2020),
  //     lastDate: DateTime.now().add(const Duration(days: 365)),
  //   );
  //   if (picked != null) {
  //     setState(() {
  //       _selectedDate = picked;
  //     });
  //   }
  // }

  // void _toggleMuscleGroup(String label) {
  //   setState(() {
  //     if (_selectedMuscleGroups.contains(label)) {
  //       _selectedMuscleGroups.remove(label);
  //     } else {
  //       _selectedMuscleGroups.add(label);
  //     }
  //   });
  // }

  // Future<void> _createWorkout() async {
  //   if (_isSubmitting) return;
  //
  //   setState(() {
  //     _isSubmitting = true;
  //   });
  //
  //   try {
  //     final workout = Workout(
  //       date: _effectiveDate,
  //       title: _effectiveTitle,
  //       notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
  //       muscleGroups: _selectedMuscleGroupEntities,
  //     );
  //
  //     await ref.read(createWorkoutUsecaseProvider).call(workout);
  //
  //     if (mounted) {
  //       Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutLogWidget(workout)));
  //
  //       // Reset form after navigation
  //       _titleController.clear();
  //       _notesController.clear();
  //       setState(() {
  //         _selectedDate = null;
  //         _selectedMuscleGroups.clear();
  //         _isSubmitting = false;
  //       });
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       setState(() {
  //         _isSubmitting = false;
  //       });
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create workout: $e')));
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final bool hasTitleInput = _titleTextController.text.trim().isNotEmpty;
    // final bool hasDateInput = _selectedDate != null;

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
                  setDefaultWorkoutTitle();
                });
              }
            },
            child: TextField(
              controller: _titleTextController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),

          const SizedBox(height: 24),

          // InkWell(
          //   onTap: () => _selectDate(context),
          //   borderRadius: BorderRadius.circular(4),
          //   child: InputDecorator(
          //     decoration: InputDecoration(
          //       labelText: 'Date',
          //       border: const OutlineInputBorder(),
          //       suffixIcon: hasDateInput
          //           ? IconButton(
          //               icon: const Icon(Icons.clear),
          //               onPressed: () {
          //                 setState(() {
          //                   _selectedDate = null;
          //                 });
          //               },
          //             )
          //           : const Icon(Icons.calendar_today),
          //     ),
          //     child: Text(_effectiveDate.toLongFriendlyFormat()),
          //   ),
          // ),
          const SizedBox(height: 24),

          // Text('Muscle Groups', style: theme.textTheme.labelLarge),
          // const SizedBox(height: 8),
          // Wrap(
          //   spacing: 8,
          //   runSpacing: 8,
          //   children: _availableMuscleGroups.map((muscleGroup) {
          //     final isSelected = _selectedMuscleGroups.contains(muscleGroup.label);
          //     final chipColor = _getMuscleGroupColor(muscleGroup.label);
          //
          //     return FilterChip(
          //       label: Text(muscleGroup.label),
          //       selected: isSelected,
          //       onSelected: (_) => _toggleMuscleGroup(muscleGroup.label),
          //       backgroundColor: theme.colorScheme.surfaceContainerHighest,
          //       selectedColor: chipColor,
          //       labelStyle: TextStyle(color: isSelected ? Colors.white : theme.colorScheme.onSurface),
          //     );
          //   }).toList(),
          // ),
          const SizedBox(height: 24),

          // Notes field (optional)
          Text('Notes', style: theme.textTheme.labelLarge),
          const SizedBox(height: 8),
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(
              hintText: 'Add any notes about this workout...',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),

          const SizedBox(height: 32),

          // Create button
          FilledButton.icon(
            onPressed: () {},
            // icon: _isSubmitting
            //     ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
            //     : null,
            label: Text('Start Workout'),
          ),
        ],
      ),
    );
  }
}
