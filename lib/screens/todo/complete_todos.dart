import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:template/models/todo.dart';
import 'package:template/constants.dart';
import '../../utils/preferences_service.dart';

class CompleteTodos extends StatefulWidget {
  const CompleteTodos({super.key});

  @override
  _CompleteTodosState createState() => _CompleteTodosState();
}

class _CompleteTodosState extends State<CompleteTodos> {
  List<Todo> completedTodos =
      []; // Changed to specifically store completed todos
  bool isLoading = true; // Add loading state

  @override
  void initState() {
    super.initState();
    _loadCompletedTodos(); // Call when screen mounts
  }

  Future<void> _loadCompletedTodos() async {
    try {
      // Get all todos and filter for completed ones
      List<Todo> allTodos = PreferencesService.getTodoObjects();
      List<Todo> completed =
          allTodos.where((todo) => todo.isCompleted).toList();

      setState(() {
        completedTodos = completed;
        isLoading = false;
      });

      print("Debug: Found ${completedTodos.length} completed todos");
    } catch (e) {
      print("Error loading completed todos: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompleteTaskBar(),
      body: Container(
        color: bodyColor, // Add background color
        child: isLoading
            ? Center(
                child: CircularProgressIndicator()) // Show loading indicator
            : completedTodos.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_outline,
                            size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No completed todos yet!',
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[600]),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Complete some tasks to see them here',
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  )
                : ListView(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 6),
                    children: <Widget>[
                      // Display only completed todos
                      ...completedTodos.map((todo) => Container(
                            height: 80,
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.symmetric(horizontal: 25.0),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(252, 255, 255, 255),
                                borderRadius: BorderRadius.circular(23),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(250, 14, 7, 7),
                                    blurRadius: 8,
                                    offset: Offset(0, 3),
                                    blurStyle: BlurStyle.normal,
                                  )
                                ]),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        todo.title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20,
                                          decoration: TextDecoration
                                              .lineThrough, // Show completed with strikethrough
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        todo.detail,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey[500]),
                                      )
                                    ],
                                  ),
                                ),
                                // Add completion indicator
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 30,
                                ),
                              ],
                            ),
                          ))
                    ],
                  ),
      ),
    );
  }
}

//AppBar
class CompleteTaskBar extends StatelessWidget implements PreferredSizeWidget {
  const CompleteTaskBar({
    super.key,
  });

  @override
  Size get preferredSize => Size.fromHeight(56.0); // Standard AppBar height

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
      title: Text('Completed Task',
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }
}
