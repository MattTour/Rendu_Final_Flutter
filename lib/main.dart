import 'package:flutter/material.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manager vos tâches',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TodoList(title: 'Liste de tâches'),
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({super.key, required this.title});

  final String title;

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final List<Todo> _todos = <Todo>[];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  void _addTodoItem(String name, String description) {
    setState(() {
      _todos.add(Todo(name: name, description: description, completed: false));
    });
    nameController.clear();
    descriptionController.clear();
  }

  void _handleTodoChange(Todo todo) {
    setState(() {
      todo.completed = !todo.completed;
    });
  }

  void _deleteTodo(Todo todo) {
    setState(() {
      _todos.removeWhere((element) => element.name == todo.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: _todos.map((Todo todo) {
          return TodoItem(
              todo: todo,
              onTodoChanged: _handleTodoChange,
              removeTodo: _deleteTodo);
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(),
        tooltip: 'Add a Todo',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _displayDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ajouter une tâche à votre liste !'),
          content: Column(children: [
            TextField(
              controller: nameController,
              decoration:
                  const InputDecoration(hintText: 'Titre de la tâche :'),
              autofocus: true,
            ),
            TextField(
              controller: descriptionController,
              decoration:
                  const InputDecoration(hintText: 'Description de la tâche :'),
            ),
          ]),
          actions: <Widget>[
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _addTodoItem(nameController.text, descriptionController.text);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class Todo {
  Todo(
      {required this.name, required this.description, required this.completed});
  String name;
  String description;
  bool completed;
}

class TodoItem extends StatelessWidget {
  TodoItem(
      {required this.todo,
      required this.onTodoChanged,
      required this.removeTodo})
      : super(key: ObjectKey(todo));

  final Todo todo;
  final void Function(Todo todo) onTodoChanged;
  final void Function(Todo todo) removeTodo;

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;

    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: Key(todo.name),
        direction: DismissDirection.horizontal,
        onDismissed: (direction) {
          removeTodo(todo);
        },
        background: Container(color: Colors.red),
        child: ListTile(
          onTap: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TodoDetail(todo)),
            );
          },
          leading: Checkbox(
            checkColor: const Color.fromARGB(255, 184, 132, 226),
            activeColor: const Color.fromARGB(255, 0, 0, 0),
            value: todo.completed,
            onChanged: (value) {
              onTodoChanged(todo);
            },
          ),
          title: Row(children: <Widget>[
            Expanded(
              child: Text(todo.name, style: _getTextStyle(todo.completed)),
            ),
          ]),
        ));
  }
}

class TodoDetail extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const TodoDetail(this.todo);
  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.name),
      ),
      body: Center(child: Text(todo.description)),
    );
  }
}
