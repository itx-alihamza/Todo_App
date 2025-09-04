import 'dart:convert';

class Todo {
  final String id;
  final String title;
  final String detail;
  final bool isCompleted;
  final DateTime createdAt;

  Todo({
    required this.id,
    required this.title,
    required this.detail,
    this.isCompleted = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert Todo to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'detail': detail,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create Todo from JSON
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      detail: json['detail'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  // Convert Todo to JSON string
  String toJsonString() {
    return jsonEncode(toJson());
  }

  // Create Todo from JSON string
  factory Todo.fromJsonString(String jsonString) {
    return Todo.fromJson(jsonDecode(jsonString));
  }

  // Create a copy with updated fields
  Todo copyWith({
    String? title,
    String? detail,
    bool? isCompleted,
  }) {
    return Todo(
      id: id, // ID never changes
      title: title ?? this.title,
      detail: detail ?? this.detail,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt, // Created date never changes
    );
  }

  // @override
  // String toString() {
  //   return 'Todo(id: $id, title: $title, detail: $detail, isCompleted: $isCompleted)';
  // }
}
