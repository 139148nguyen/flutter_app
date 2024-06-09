import 'package:flutter/foundation.dart';
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
  final TextEditingController _timeNotiCtl = TextEditingController();

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
            SizedBox(
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
                    controller: _timeNotiCtl,
                    onTap: () async {
                      DateTime? date = DateTime(1900);
                      FocusScope.of(context).requestFocus(FocusNode());
                      date = await showDatePicker(
                          context: context,
                          initialEntryMode: DatePickerEntryMode.calendarOnly,
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                          initialDate: widget.todo.updatedOn.toDate());
                      if (date != null) {
                        _timeNotiCtl.text =
                            DateFormat('dd/MM/yyyy').format(date);
                      }
                    },
                  ),
                ],
              ),
            ));
  }
}
