import 'package:flutter/material.dart';
import 'package:template/utils/preferences_service.dart';

class TodoServiceExample extends StatefulWidget {
  @override
  _TodoServiceExampleState createState() => _TodoServiceExampleState();
}

class _TodoServiceExampleState extends State<TodoServiceExample> {
  List<String> todos = [];

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  void _loadTodos() {
    // Easy to use - no async needed since it's already initialized
    List<String>? savedTodos = PreferencesService.getTodoList();
    setState(() {
      todos = savedTodos ?? [];
    });
  }

  Future<void> _addTodo(String todo) async {
    todos.add(todo);
    await PreferencesService.saveTodoList(todos);
    setState(() {});
  }

  Future<void> _completeTodo(int index) async {
    String completedTodo = todos.removeAt(index);

    // Save updated todos
    await PreferencesService.saveTodoList(todos);

    // Add to completed todos
    // List<String> completed = PreferencesService.getCompletedTodos() ?? [];
    // completed.add(completedTodo);
    // await PreferencesService.saveCompletedTodos(completed);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todo with Service')),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(todos[index]),
            trailing: IconButton(
              icon: Icon(Icons.check),
              onPressed: () => _completeTodo(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTodo('New Todo ${todos.length + 1}'),
        child: Icon(Icons.add),
      ),
    );
  }
}
