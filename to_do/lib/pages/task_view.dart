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
  final TextEditingController _taskCtl = TextEditingController();
  final TextEditingController _dayNotiCtl = TextEditingController();
  final TextEditingController _timeNotiCtl = TextEditingController();
  DateTime? date;

  String formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    date = widget.todo.updatedOn.toDate();
  }

  @override
  Widget build(BuildContext context) {
    _taskCtl.text = widget.todo.task;
    _dayNotiCtl.text =
        DateFormat("dd-MM-yyyy").format(widget.todo.updatedOn.toDate());
    _timeNotiCtl.text =
        DateFormat("h:m a").format(widget.todo.updatedOn.toDate());

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _displayTextFormField();
        },
        child: Icon(Icons.edit),
      ),
    );
  }

  void _displayTextFormField() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Edit"),
              content: Column(
                children: [
                  TextFormField(
                    controller: _taskCtl,
                    keyboardType: TextInputType.text,
                    decoration:
                        const InputDecoration(hintText: "What is the task?"),
                    onChanged: (value) {
                      widget.todo.task = value;
                      setState(() {});
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    controller: _timeNotiCtl,
                    decoration: const InputDecoration(
                        hintText: "What time do you do this?"),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(
                              hour: date!.hour, minute: date!.minute));
                      if (time != null) {
                        final newDateTime = DateTime(date!.year, date!.month,
                            date!.day, time.hour, time.minute);
                        _timeNotiCtl.text =
                            DateFormat('h:m a').format(newDateTime);
                        widget.todo.updatedOn = Timestamp.fromDate(newDateTime);
                        setState(() {});
                      }
                    },
                  ),
                ],
              ),
              actions: [
                MaterialButton(
                  color: Theme.of(context).colorScheme.primary,
                  textColor: Colors.white,
                  onPressed: () {
                    Todo todo = Todo(
                        createdOn: Timestamp.now(),
                        task: _taskCtl.text,
                        isDone: false,
                        updatedOn: Timestamp.fromDate(date!));

                    Navigator.of(context).pop(todo.toJson());

                    // print(todo.updatedOn.toString());
                  },
                  child: const Text("Update"),
                )
              ],
            ));
  }
}
