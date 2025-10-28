import 'package:flutter/material.dart';
import 'package:lograt/presentation/screens/workout_log/workout_log.dart';
import 'package:lograt/util/extensions/human_friendly_date_format.dart';

class WorkoutLogState extends State<WorkoutLog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout.name),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(16),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(widget.workout.createdOn.toHumanFriendlyFormat()),
          ),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz))],
      ),
      body: Container(decoration: BoxDecoration(color: Colors.deepPurple)),
    );
  }
}
