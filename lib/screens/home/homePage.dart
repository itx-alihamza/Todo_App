import 'package:flutter/material.dart';
// import 'package:template/screens/todo/complete_todos.dart';
// import 'package:template/screens/todo/edit_todo_screen.dart';
import 'package:template/models/todo.dart'; // Import Todo model
import 'package:template/utils/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:template/utils/preferences_service.dart';
import '../screens.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 113, 126, 198)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'TODO APP'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.
  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var index = 0;
  List<Todo> todos = []; // Changed to List<Todo> for better structure

// Obtain shared preferences.
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    _initPrefs();
    getData(); // Call getData when screen mounts
  }

  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  void getData() {
    // Get Todo objects instead of maps
    List<Todo> savedTodos = PreferencesService.getTodoObjects();
    print('All todos: $savedTodos');

    // Update the UI with loaded todos
    setState(() {
      todos = savedTodos;
    });
  }

  void _currentIndex(value) {
    setState(() {
      index = value;
      print(value);
    });
    if (index == 1) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CompleteTodos()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // App bar
        appBar: CustomAppBar(widget: widget),
        // Body
        body: Body(todos: todos, onTodoChanged: getData), // Pass callback
        // Floating Add task button
        floatingActionButton: SizedBox(
          width: 80,
          height: 80,
          child: FloatingActionButton(
            onPressed: () async {
              // Navigate to AddTodoScreen and wait for result
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddTodoScreen()),
              );

              // If a todo was added, refresh the list
              if (result == true) {
                getData(); // Reload todos from SharedPreferences
              }
            },
            tooltip: 'Increment',
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
            child: const Icon(
              Icons.add,
              color: customColorWhite,
              size: 30,
            ),
          ),
        ),
        // Navigation bar
        bottomNavigationBar: BottomNavigationBar(
            onTap: _currentIndex,
            currentIndex: index,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: allIcon, label: 'All'),
              BottomNavigationBarItem(icon: tickIcon, label: 'Completed')
            ]));
  }
}

class Body extends StatelessWidget {
  final List<Todo> todos; // Changed to List<Todo>
  final VoidCallback onTodoChanged; // Add callback for refreshing data

  const Body({
    super.key,
    required this.todos,
    required this.onTodoChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        color: bodyColor,
      ),
      ListView(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 6),
        children: <Widget>[
          // Display saved todos dynamically using Todo objects
          ...todos
              .where((todo) => !todo.isCompleted)
              .map((todo) => Container(
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
                          // Add Expanded to prevent overflow
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                todo.title, // Access todo.title
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 20),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                todo.detail, // Access todo.detail
                                style: TextStyle(
                                    fontSize: 15, color: Colors.grey[600]),
                              )
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () async {
                                print(
                                    "edit button pressed for todo: ${todo.id}");
                                // Navigate to EditTodoScreen and wait for result
                                final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditTodoScreen(todo: todo)));

                                // If the todo was updated, refresh the list
                                if (result == true) {
                                  onTodoChanged(); // Use the callback to reload todos
                                }
                              },
                              icon: SvgPicture.asset(
                                'assets/icons/pencilIcon.svg',
                                height: 30,
                                width: 100,
                                alignment: Alignment.center,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                print(
                                    "delete button pressed for todo: ${todo.id}");
                                // Delete the todo
                                bool success =
                                    await PreferencesService.deleteTodoObject(
                                        todo.id);
                                if (success) {
                                  // Refresh the data
                                  onTodoChanged();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Todo deleted successfully')));
                                }
                              },
                              icon: SvgPicture.asset(
                                'assets/icons/trashIcon.svg',
                                height: 30,
                                width: 100,
                                alignment: Alignment.center,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                print(
                                    "complete button pressed for todo: ${todo.id}");
                                // Toggle completion status
                                bool success =
                                    await PreferencesService.updateTodoObject(
                                        todo.id,
                                        isCompleted: !todo.isCompleted);
                                if (success) {
                                  // Refresh the data
                                  onTodoChanged();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Todo ${todo.isCompleted ? 'marked incomplete' : 'completed'}')));
                                }
                              },
                              icon: SvgPicture.asset(
                                'assets/icons/Tick.svg',
                                height: 30,
                                width: 100,
                                alignment: Alignment.center,
                                colorFilter: todo.isCompleted
                                    ? ColorFilter.mode(
                                        Colors.green, BlendMode.srcIn)
                                    : null, // Show green if completed
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ))
              .toList(),

          // Show placeholder if no todos
          if (todos.isEmpty)
            Container(
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
              child: Center(
                child: Text(
                  "No todos yet. Add some!",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),
        ],
      ),
    ]);
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.widget,
  });

  final MyHomePage widget;

  @override
  Size get preferredSize => Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: primaryColor,
      title: Text(
        widget.title,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: customColorWhite, fontSize: 30),
      ),
      centerTitle: false,
      actions: <Widget>[],
    );
  }
}
