import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:to_do/services/database_service.dart';

import '../models/todo.dart';
import 'task_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DataBaseService _dataBaseService = DataBaseService();

  final TextEditingController _newTaskCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: _buildUI(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _displayTextInputDiaLog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: const Text(
        "Todo",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Column(
        children: [
          _messagesListView(),
        ],
      ),
    );
  }

  Widget _messagesListView() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.80,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder(
        stream: _dataBaseService.getTodos(),
        builder: ((context, snapshot) {
          print(snapshot.toString());
          List todos = snapshot.data?.docs ?? [];
          print(todos);
          return ListView.builder(
            itemBuilder: (context, index) {
              Todo todo = todos[index].data();
              String todoId = todos[index].id;
              print(todos.toString());
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(4)),
                  child: ListTile(
                    title: Text(todo.task),
                    subtitle: Text(DateFormat("dd-MM-yyyy h:m a")
                        .format(todo.updatedOn.toDate())),
                    trailing: Checkbox(
                      value: todo.isDone,
                      onChanged: (value) {
                        Todo updateTodo = todo.copyWith(
                            isDone: !todo.isDone, updatedOn: Timestamp.now());
                        _dataBaseService.updateTodo(todoId, updateTodo);
                        setState(() {});
                      },
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TaskView(todo: todo)));
                    },
                  ),
                ),
              );
            },
            itemCount: todos.length,
          );
        }),
      ),
    );
  }

  void _displayTextInputDiaLog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Add a new Todo"),
            content: TextFormField(
              decoration: const InputDecoration(hintText: "Todo...."),
              controller: _newTaskCtl,
            ),
            actions: [
              MaterialButton(
                color: Theme.of(context).colorScheme.primary,
                textColor: Colors.white,
                onPressed: () {
                  Todo todo = Todo(
                      createdOn: Timestamp.now(),
                      task: _newTaskCtl.text,
                      isDone: false,
                      updatedOn: Timestamp.now());
                  _dataBaseService.addTodo(todo);
                  Navigator.pop(context);
                  _newTaskCtl.clear();
                },
                child: const Text("Add"),
              )
            ],
          );
        });
  }
}
