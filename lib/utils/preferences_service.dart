import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart'; // Import the Todo class

class PreferencesService {
  static SharedPreferences? _prefs;
  
  // Initialize SharedPreferences once
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  // Get instance (make sure init() was called first)
  static SharedPreferences get instance {
    
    if (_prefs == null) {
      throw Exception('SharedPreferences not initialized. Call PreferencesService.init() first.');
    }
    return _prefs!;
  }
  
  // ========== INTERNAL STORAGE METHODS ==========
  // These are used internally by Todo class methods
  
  static Future<void> saveTodoList(List<String> todos) async {
    await instance.setStringList('todos', todos);
  }
  
  static List<String>? getTodoList() {
    return instance.getStringList('todos');
  }
  
  // Clear all todos
  static Future<void> clearAllTodos() async {
    await instance.remove('todos');
    await instance.remove('completed_todos');
  }
  
  // ========== TODO CLASS METHODS (Use These!) ==========
  
  // Save a Todo object
  static Future<void> saveTodoObject(Todo todo) async {
    List<String> todoJsonList = getTodoList() ?? [];
    todoJsonList.add(todo.toJsonString());
    await saveTodoList(todoJsonList);
  }
  
  // Get all todos as Todo objects
  static List<Todo> getTodoObjects() {
    List<String>? todoJsonList = getTodoList();
    if (todoJsonList == null) return [];
    
    List<Todo> todos = [];
    for (String todoJson in todoJsonList) {
      try {
        Todo todo = Todo.fromJsonString(todoJson);
        todos.add(todo);
      } catch (e) {
        print('Error parsing todo: $e');
      }
    }
    return todos;
  }
  
  // Find Todo object by ID
  static Todo? getTodoObjectById(String todoId) {
    List<Todo> todos = getTodoObjects();
    for (Todo todo in todos) {
      if (todo.id == todoId) {
        return todo;
      }
    }
    return null;
  }
  
  // Update Todo object by ID
  static Future<bool> updateTodoObject(String todoId, {
    String? title,
    String? detail,
    bool? isCompleted,
  }) async {
    List<String> todoJsonList = getTodoList() ?? [];
    
    for (int i = 0; i < todoJsonList.length; i++) {
      try {
        Todo todo = Todo.fromJsonString(todoJsonList[i]);
        if (todo.id == todoId) {
          // Create updated todo
          Todo updatedTodo = todo.copyWith(
            title: title,
            detail: detail,
            isCompleted: isCompleted,
          );
          todoJsonList[i] = updatedTodo.toJsonString();
          await saveTodoList(todoJsonList);
          return true; // Success
        }
      } catch (e) {
        print('Error updating todo: $e');
      }
    }
    return false; // Todo not found
  }
  
  // Delete Todo object by ID
  static Future<bool> deleteTodoObject(String todoId) async {
    List<String> todoJsonList = getTodoList() ?? [];
    
    for (int i = 0; i < todoJsonList.length; i++) {
      try {
        Todo todo = Todo.fromJsonString(todoJsonList[i]);
        if (todo.id == todoId) {
          todoJsonList.removeAt(i);
          await saveTodoList(todoJsonList);
          return true; // Success
        }
      } catch (e) {
        print('Error deleting todo: $e');
      }
    }
    return false; // Todo not found
  }
}
