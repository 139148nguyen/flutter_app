import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do/main.dart';
import 'package:to_do/models/todo.dart';

const String TODO_COLLECTION_REP = 'todos';

class DataBaseService {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _todosRef;

  DataBaseService() {
    _todosRef = _firestore.collection(TODO_COLLECTION_REP).withConverter<Todo>(
          fromFirestore: (snapshots, _) => Todo.fromJson(
            snapshots.data()!,
          ),
          toFirestore: (todo, _) => todo.toJson(),
        );
  }

  Stream<QuerySnapshot> getTodos() {
    return _todosRef.snapshots();
  }

  void addTodo(Todo todo) async {
    _todosRef.add(todo);
  }

  void updateTodo(String todoId, Todo todo) {
    _todosRef.doc(todoId).update(todo.toJson());
  }
}
