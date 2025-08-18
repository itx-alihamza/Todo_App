import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../utils/preferences_service.dart';

class TodoIterationExamples extends StatefulWidget {
  @override
  _TodoIterationExamplesState createState() => _TodoIterationExamplesState();
}

class _TodoIterationExamplesState extends State<TodoIterationExamples> {
  List<Todo> todos = [];

  @override
  void initState() {
    super.initState();
    loadTodos();
  }

  // METHOD 1: Basic loading of all todos
  void loadTodos() {
    setState(() {
      todos = PreferencesService.getTodoObjects();
    });
    print('Loaded ${todos.length} todos');
  }

  // METHOD 2: Filter todos (completed vs incomplete)
  List<Todo> getCompletedTodos() {
    return todos.where((todo) => todo.isCompleted).toList();
  }

  List<Todo> getIncompleteTodos() {
    return todos.where((todo) => !todo.isCompleted).toList();
  }

  // METHOD 3: Search todos by title
  List<Todo> searchTodos(String query) {
    return todos.where((todo) => 
      todo.title.toLowerCase().contains(query.toLowerCase()) ||
      todo.detail.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // METHOD 4: Get specific todo by ID
  Todo? getTodoById(String id) {
    return PreferencesService.getTodoObjectById(id);
  }

  // METHOD 5: Sort todos (by date, alphabetically, etc.)
  List<Todo> getSortedTodos({required bool ascending}) {
    List<Todo> sortedTodos = List.from(todos);
    sortedTodos.sort((a, b) {
      if (ascending) {
        return a.createdAt.compareTo(b.createdAt);
      } else {
        return b.createdAt.compareTo(a.createdAt);
      }
    });
    return sortedTodos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Iteration Examples'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // EXAMPLE 1: Display all todos
            _buildSection(
              title: '1. All Todos (${todos.length})',
              child: Column(
                children: todos.map((todo) => _buildTodoCard(todo)).toList(),
              ),
            ),

            SizedBox(height: 20),

            // EXAMPLE 2: Display completed todos only
            _buildSection(
              title: '2. Completed Todos (${getCompletedTodos().length})',
              child: Column(
                children: getCompletedTodos()
                    .map((todo) => _buildTodoCard(todo, showCompleted: true))
                    .toList(),
              ),
            ),

            SizedBox(height: 20),

            // EXAMPLE 3: Display incomplete todos only
            _buildSection(
              title: '3. Incomplete Todos (${getIncompleteTodos().length})',
              child: Column(
                children: getIncompleteTodos()
                    .map((todo) => _buildTodoCard(todo, showIncomplete: true))
                    .toList(),
              ),
            ),

            SizedBox(height: 20),

            // EXAMPLE 4: Display sorted todos (newest first)
            _buildSection(
              title: '4. Sorted Todos (Newest First)',
              child: Column(
                children: getSortedTodos(ascending: false)
                    .map((todo) => _buildTodoCard(todo, showDate: true))
                    .toList(),
              ),
            ),

            SizedBox(height: 20),

            // EXAMPLE 5: Interactive iteration examples
            _buildSection(
              title: '5. Interactive Examples',
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Example: Print all todo titles
                      print('=== All Todo Titles ===');
                      for (Todo todo in todos) {
                        print('${todo.id}: ${todo.title}');
                      }
                    },
                    child: Text('Print All Titles to Console'),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Example: Count completed vs incomplete
                      int completed = getCompletedTodos().length;
                      int incomplete = getIncompleteTodos().length;
                      
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Todo Statistics'),
                          content: Text(
                            'Total: ${todos.length}\n'
                            'Completed: $completed\n'
                            'Incomplete: $incomplete'
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text('Show Statistics'),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Example: Find todos with "work" in title
                      List<Todo> workTodos = searchTodos('work');
                      print('Found ${workTodos.length} todos containing "work"');
                      for (Todo todo in workTodos) {
                        print('- ${todo.title}');
                      }
                    },
                    child: Text('Search for "work" Todos'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: loadTodos,
        child: Icon(Icons.refresh),
        tooltip: 'Refresh Todos',
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
          SizedBox(height: 8),
          child.runtimeType == Column && (child as Column).children.isEmpty
              ? Text('No todos in this category', style: TextStyle(color: Colors.grey))
              : child,
        ],
      ),
    );
  }

  Widget _buildTodoCard(Todo todo, {
    bool showCompleted = false,
    bool showIncomplete = false,
    bool showDate = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: todo.isCompleted ? Colors.green.shade50 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: todo.isCompleted ? Colors.green.shade200 : Colors.blue.shade200,
        ),
      ),
      child: Row(
        children: [
          // Completion indicator
          Icon(
            todo.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
            color: todo.isCompleted ? Colors.green : Colors.grey,
          ),
          SizedBox(width: 12),
          // Todo content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todo.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                if (todo.detail.isNotEmpty)
                  Text(
                    todo.detail,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                if (showDate)
                  Text(
                    'Created: ${todo.createdAt.toString().split('.')[0]}',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 10,
                    ),
                  ),
              ],
            ),
          ),
          // Action buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () async {
                  bool success = await PreferencesService.updateTodoObject(
                    todo.id,
                    isCompleted: !todo.isCompleted,
                  );
                  if (success) {
                    loadTodos(); // Refresh the list
                  }
                },
                icon: Icon(
                  todo.isCompleted ? Icons.undo : Icons.check,
                  size: 20,
                ),
              ),
              IconButton(
                onPressed: () async {
                  bool success = await PreferencesService.deleteTodoObject(todo.id);
                  if (success) {
                    loadTodos(); // Refresh the list
                  }
                },
                icon: Icon(Icons.delete, size: 20, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =====================================================
// EXAMPLE CODE SNIPPETS FOR COMMON OPERATIONS
// =====================================================

class TodoCodeExamples {
  
  // Example 1: Basic iteration with for loop
  static void printAllTodos() {
    List<Todo> todos = PreferencesService.getTodoObjects();
    
    print('=== All Todos ===');
    for (int i = 0; i < todos.length; i++) {
      Todo todo = todos[i];
      print('${i + 1}. ${todo.title} - ${todo.isCompleted ? "Completed" : "Pending"}');
    }
  }

  // Example 2: Enhanced for loop (for-each)
  static void printTodoDetails() {
    List<Todo> todos = PreferencesService.getTodoObjects();
    
    for (Todo todo in todos) {
      print('ID: ${todo.id}');
      print('Title: ${todo.title}');
      print('Detail: ${todo.detail}');
      print('Completed: ${todo.isCompleted}');
      print('Created: ${todo.createdAt}');
      print('---');
    }
  }

  // Example 3: Using map to transform data
  static List<String> getTodoTitles() {
    List<Todo> todos = PreferencesService.getTodoObjects();
    return todos.map((todo) => todo.title).toList();
  }

  // Example 4: Using where to filter
  static List<Todo> getUrgentTodos() {
    List<Todo> todos = PreferencesService.getTodoObjects();
    return todos.where((todo) => 
      todo.title.toLowerCase().contains('urgent') || 
      todo.detail.toLowerCase().contains('urgent')
    ).toList();
  }

  // Example 5: Counting specific todos
  static Map<String, int> getTodoStats() {
    List<Todo> todos = PreferencesService.getTodoObjects();
    
    return {
      'total': todos.length,
      'completed': todos.where((todo) => todo.isCompleted).length,
      'incomplete': todos.where((todo) => !todo.isCompleted).length,
    };
  }

  // Example 6: Finding first/last todo
  static Todo? getLatestTodo() {
    List<Todo> todos = PreferencesService.getTodoObjects();
    if (todos.isEmpty) return null;
    
    todos.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return todos.first;
  }

  // Example 7: Bulk operations
  static Future<void> markAllTodosComplete() async {
    List<Todo> todos = PreferencesService.getTodoObjects();
    
    for (Todo todo in todos) {
      if (!todo.isCompleted) {
        await PreferencesService.updateTodoObject(todo.id, isCompleted: true);
      }
    }
  }

  // Example 8: Display todos in ListView.builder
  static Widget buildTodoListView() {
    return FutureBuilder<List<Todo>>(
      future: Future.value(PreferencesService.getTodoObjects()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        
        List<Todo> todos = snapshot.data ?? [];
        
        return ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            Todo todo = todos[index];
            return ListTile(
              leading: Icon(
                todo.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                color: todo.isCompleted ? Colors.green : Colors.grey,
              ),
              title: Text(todo.title),
              subtitle: Text(todo.detail),
              onTap: () {
                // Handle todo tap
                print('Tapped todo: ${todo.title}');
              },
            );
          },
        );
      },
    );
  }
}
