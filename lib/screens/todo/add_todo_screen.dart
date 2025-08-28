import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:template/constants.dart';
import 'package:template/utils/preferences_service.dart';
import 'dart:convert'; // Add this for JSON encoding
import 'package:template/models/todo.dart'; // Import Todo class

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _detailController.dispose();
    super.dispose();
  }

  // Function to generate unique ID
  String _generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  Future<void> _addTodo() async {
    String todoId = _generateUniqueId(); // Generate unique ID
    String title = _titleController.text.trim();
    String detail = _detailController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a title')),
      );
      return;
    }

    // ========== APPROACH 1: JSON Map (Current) ==========
    // Map<String, String> todoMap = {
    //   'id': todoId,
    //   'title': title,
    //   'detail': detail,
    // };
    // String todoJson = jsonEncode(todoMap);
    // List<String> todos = PreferencesService.getTodoList() ?? [];
    // todos.add(todoJson);
    // await PreferencesService.saveTodoList(todos);

    // ========== APPROACH 2: Todo Class (Better) ==========
    Todo newTodo = Todo(
      id: todoId,
      title: title,
      detail: detail,
    );
    await PreferencesService.saveTodoObject(newTodo);

    print('Added todo: ${newTodo.toString()}'); // Debug print

    // Go back to previous screen
    Navigator.pop(context, true); // Pass true to indicate success
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AddTodoAppBar(),
      body: AddTaskForm(
        titleController: _titleController,
        detailController: _detailController,
        onAddPressed: _addTodo,
      ),
    );
  }
}

class AddTaskForm extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController detailController;
  final VoidCallback onAddPressed;

  const AddTaskForm({
    super.key,
    required this.titleController,
    required this.detailController,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: TextField(
            controller: titleController,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              hintText: 'Title',
              hintStyle: TextStyle(
                  fontSize: 20,
                  color: Color.fromRGBO(139, 135, 135, 1) // Your hex8 color
                  ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: TextField(
            controller: detailController,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              hintText: 'Detail',
              hintStyle: TextStyle(
                  fontSize: 20,
                  color: Color.fromRGBO(139, 135, 135, 1) // Your hex8 color
                  ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: ElevatedButton(
            onPressed: onAddPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Add Task',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class AddTodoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AddTodoAppBar({
    super.key,
  });

  @override
  Size get preferredSize => Size.fromHeight(78);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(78),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          color: primaryColor,
          child: AppBar(
            centerTitle: false, // Align title to the left
            titleSpacing: 40, // Custom spacing between leading and title
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: SvgPicture.asset(
                  'assets/icons/turnBack.svg',
                  height: 30,
                  width: 30,
                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.dstIn),
                )),
            backgroundColor: primaryColor,
            title: Text('Add Task',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
        ));
  }
}
