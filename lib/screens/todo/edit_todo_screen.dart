import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:template/models/todo.dart';
import 'package:template/constants.dart';
import 'package:template/utils/preferences_service.dart';

class EditTodoScreen extends StatefulWidget {
  final Todo todo; // Changed from List<Todo> to single Todo

  const EditTodoScreen({
    super.key,
    required this.todo,
  });

  @override
  State<EditTodoScreen> createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EditTodoAppBar(),
      body: EditTaskForm(todo: widget.todo),
    );
  }
}

class EditTaskForm extends StatefulWidget {
  final Todo todo; // Changed from List<Todo> to single Todo

  EditTaskForm({super.key, required this.todo});

  @override
  State<EditTaskForm> createState() => _EditTaskFormState();
}

class _EditTaskFormState extends State<EditTaskForm> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with EXISTING todo values
    _titleController = TextEditingController(text: widget.todo.title);
    _descriptionController = TextEditingController(
        text: widget.todo.detail); // Use 'detail' not 'description'
  }

  Future<void> _updateTodo() async {
    String newTitle = _titleController.text.trim();
    String newDetail = _descriptionController.text.trim();

    if (newTitle.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Title cannot be empty')),
      );
      return;
    }

    // Update the todo using PreferencesService
    bool success = await PreferencesService.updateTodoObject(
      widget.todo.id,
      title: newTitle,
      detail: newDetail,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Todo updated successfully')),
      );
      Navigator.pop(context, true); // Return true to indicate success
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update todo')),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: TextField(
            controller: _titleController,
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
            controller: _descriptionController,
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
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _updateTodo, // Use the update method
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      minimumSize: Size(200, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: Text(
                    'Update',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, false); // Return false for cancel
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      minimumSize: Size(200, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class EditTodoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EditTodoAppBar({
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
            title: Text('Edit Task',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
        ));
  }
}
