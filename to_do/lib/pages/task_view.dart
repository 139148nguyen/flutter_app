import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/todo.dart';

class TaskView extends StatefulWidget {
  const TaskView({super.key, required this.todo});
  final Todo todo;

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  String formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.todo.task),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Task: ${widget.todo.task}",
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
                "Time: ${DateFormat("dd-MM-yyyy h:m a").format(widget.todo.updatedOn.toDate())}")
          ],
        ),
      ),
    );
  }
}
