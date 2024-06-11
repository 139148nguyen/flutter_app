import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do/services/database_service.dart';

import '../api/firsebase_api.dart';
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
  final TextEditingController _dateNotiCtl = TextEditingController();
  final TextEditingController _timeNotiCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: _buildUI(),
      // Thêm mới todo
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Todo newTodo = Todo(
              task: "_New",
              isDone: false,
              createdOn: Timestamp.now(),
              updatedOn: Timestamp.now());
          _displayTextInputDiaLog(newTodo, "");
        },
        child: const Icon(Icons.add),
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

// Widget hiển thị danh sach todo
  Widget _messagesListView() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.80,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder(
        stream: _dataBaseService.getTodos(),
        builder: ((context, snapshot) {
          List todos = snapshot.data?.docs ?? [];
          if (todos.isEmpty) {
            return const Center(child: Text("Add a todo"));
          } else {
            return ListView.builder(
              itemBuilder: (context, index) {
                Todo todo = todos[index].data();
                String todoId = todos[index].id;
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
                      trailing: Wrap(
                          spacing: 12,
                          alignment: WrapAlignment.center,
                          children: [
                            // Chỉnh sửa todo
                            IconButton(
                                onPressed: () {
                                  _displayTextInputDiaLog(todo, todoId);
                                },
                                icon: const Icon(Icons.edit)),
                            // Thay đổi trạng thái isDone
                            Checkbox(
                              value: todo.isDone,
                              onChanged: (value) {
                                Todo updateTodo = todo.copyWith(
                                    isDone: !todo.isDone,
                                    updatedOn: Timestamp.now());
                                _dataBaseService.updateTodo(todoId, updateTodo);
                                // setState(() {});
                              },
                            ),
                          ]),
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) => TaskView(todo: todo)))
                            .then((json) {
                          if (json != null) {
                            final todoNew = Todo.fromJson(json);
                            _dataBaseService.updateTodo(todoId, todoNew);
                          }
                        });
                      },
                      onLongPress: () async {
                        await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Xóa todo ${todo.task}?"),
                                content: const Text(
                                    "Sau khi xóa sẽ không thể hoàn tác. Nhấn 'Xóa' để tiếp tục"),
                                actions: [
                                  MaterialButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Hủy"),
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      _dataBaseService.removeTodo(todoId);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Xóa'),
                                  ),
                                ],
                              );
                            });
                      },
                    ),
                  ),
                );
              },
              itemCount: todos.length,
            );
          }
        }),
      ),
    );
  }

// Hàm hiển thị Widget thêm mới hoặc chỉnh sửa
  void _displayTextInputDiaLog(Todo todo, String todoId) async {
    bool isAdd = todo.task != "_New" ? false : true;
    DateTime date = todo.createdOn.toDate();
    if (!isAdd) {
      _newTaskCtl.text = todo.task;
      _dateNotiCtl.text =
          DateFormat('dd-MM-yyy').format(todo.updatedOn.toDate());
      _timeNotiCtl.text = DateFormat('h:m a').format(todo.updatedOn.toDate());
    } else {
      _newTaskCtl.clear();
      _dateNotiCtl.clear();
      _timeNotiCtl.clear();
    }
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(isAdd ? "Add a new Todo" : "Update ${todo.task}"),
            content: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(hintText: "Todo...."),
                  controller: _newTaskCtl,
                ),
                TextFormField(
                  controller: _dateNotiCtl,
                  decoration: const InputDecoration(
                      hintText: "Ngày thực hiện?", labelText: "Ngày nhắc:"),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    final dateTime = await showDatePicker(
                        context: context,
                        initialEntryMode: DatePickerEntryMode.calendarOnly,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                        initialDate: DateTime.now());
                    if (dateTime != null) {
                      _dateNotiCtl.text =
                          DateFormat('dd-MM-yyy').format(dateTime);
                      DateTime newDate = DateTime(dateTime.year, dateTime.month,
                          dateTime.day, date.hour, date.minute);
                      date = newDate;
                    }
                  },
                ),
                TextFormField(
                  controller: _timeNotiCtl,
                  decoration: const InputDecoration(hintText: "Thời gian?"),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    final time = await showTimePicker(
                        context: context,
                        initialEntryMode: TimePickerEntryMode.inputOnly,
                        initialTime: TimeOfDay(
                            hour: todo.updatedOn.toDate().hour,
                            minute: todo.updatedOn.toDate().minute));
                    if (time != null) {
                      DateTime newTime = DateTime(date.year, date.month,
                          date.day, time.hour, time.minute);
                      date = newTime;
                      _timeNotiCtl.text = DateFormat('h:m a').format(newTime);
                    }
                  },
                ),
              ],
            ),
            actions: [
              MaterialButton(
                color: Theme.of(context).colorScheme.primary,
                textColor: Colors.white,
                onPressed: () async {
                  Todo todo = Todo(
                      createdOn: Timestamp.now(),
                      task: _newTaskCtl.text,
                      isDone: false,
                      updatedOn: Timestamp.fromDate(date));
                  if (isAdd) {
                    _dataBaseService.addTodo(todo);
                  } else {
                    _dataBaseService.updateTodo(todoId, todo);
                  }
                  Navigator.pop(context);
                },
                child: Text(isAdd ? "Add" : "Update"),
              )
            ],
          );
        });
  }
}
