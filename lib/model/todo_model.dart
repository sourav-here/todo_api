class Todo {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      isCompleted: json['is_completed'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
    };
  }
}