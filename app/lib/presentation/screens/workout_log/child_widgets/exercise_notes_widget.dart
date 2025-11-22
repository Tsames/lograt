import 'package:flutter/material.dart';

class ExerciseNotesWidget extends StatelessWidget {
  const ExerciseNotesWidget({super.key});

  // late bool _showNotes = widget.exercise.notes.isNotNullOrEmpty;

  // late final _notesTextEditingController = TextEditingController(text: widget.exercise.notes);
  // late final AnimationController _notesAnimationController = AnimationController(
  //   duration: const Duration(milliseconds: 300),
  //   vsync: this,
  // );
  //
  // late final Animation<double> _notesAnimation = CurvedAnimation(
  //   parent: _notesAnimationController,
  //   curve: Curves.easeInOutCubic,
  // );

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
    //        SizeTransition(
    //           sizeFactor: _notesAnimation,
    //           child: Column(
    //             children: [
    //               TextField(
    //                 keyboardType: TextInputType.multiline,
    //                 minLines: 2,
    //                 maxLines: 3,
    //                 decoration: InputDecoration(
    //                   hintText: 'Notes',
    //                   hintStyle: theme.textTheme.bodyMedium,
    //                   border: InputBorder.none,
    //                   filled: true,
    //                   fillColor: theme.colorScheme.surfaceContainerHighest,
    //                 ),
    //                 style: theme.textTheme.bodyMedium,
    //                 controller: _notesTextEditingController,
    //               ),
    //               const SizedBox(height: 10),
    //             ],
    //           ),
    // //         ),
    // Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceAround,
    //       children: [
    //         AnimatedSwitcher(
    //           duration: const Duration(milliseconds: 200),
    //           child: IconButton(
    //             key: ValueKey<bool>(_showNotes),
    //             onPressed: () async {
    //               if (_notesTextEditingController.text.isNotEmpty) {
    //                 return;
    //               } else if (_showNotes == true) {
    //                 await _notesAnimationController.reverse();
    //                 setState(() {
    //                   _showNotes = false;
    //                 });
    //               } else {
    //                 WidgetsBinding.instance.addPostFrameCallback((_) => _notesAnimationController.forward());
    //                 setState(() {
    //                   _showNotes = true;
    //                 });
    //               }
    //             },
    //             icon: Icon(_showNotes ? Icons.mode_comment_rounded : Icons.mode_comment_outlined, size: 18),
    //           ),
    //         ),
    //         IconButton(
    //           onPressed: () =>
    //           {
    //             _lastSetAnimationController.reset(),
    //             WidgetsBinding.instance.addPostFrameCallback((_) => _lastSetAnimationController.forward()),
    //             workoutLogNotifier.addSetToExercise(widget.exercise.id),
    //           },
    //           icon: const Icon(Icons.add, size: 18),
    //         ),
    //         IconButton(
    //           onPressed: () async {
    //             await _lastSetAnimationController.reverse();
    //             workoutLogNotifier.removeLastSetFromExercise(widget.exercise.id);
    //             _lastSetAnimationController.value = 1.0;
    //           },
    //           icon: const Icon(Icons.remove, size: 18),
    //         ),
    //         IconButton(
    //           onPressed: () {
    //             _lastSetAnimationController.reset();
    //             WidgetsBinding.instance.addPostFrameCallback((_) => _lastSetAnimationController.forward());
    //             workoutLogNotifier.duplicateLastSetOfExercise(widget.exercise.id);
    //           },
    //           icon: const Icon(Icons.copy, size: 18),
    //         ),
    //         //todo: add an undo button to undo the last action the user took
    //         // IconButton(onPressed: () => {}, icon: const Icon(Icons.undo_rounded)),
    //       ],
    //     ),
  }
}
