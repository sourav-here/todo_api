import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todo/model/todo_model.dart';

class TodoServices {
  static Future<bool> deleteById(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final response = await http.delete(Uri.parse(url));
    return response.statusCode == 200;
  }

  static Future<bool> updateTodo(
      String id, String title, String description) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final response = await http.put(
      Uri.parse(url),
      body: jsonEncode({'title': title, 'description': description}),
      headers: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 200;
  }

  static Future<bool> submitTodo(String title, String description) async {
    const url = 'https://api.nstack.in/v1/todos';
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({'title': title, 'description': description}),
      headers: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 201;
  }

  static Future<List<Todo>> fetchTodo() async {
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      if (json.containsKey('items')) {
        final List<dynamic> todoData = json['items'];
        final List<Todo> todoList =
            todoData.map((item) => Todo.fromJson(item)).toList();
        return todoList;
      } else {
        throw Exception('Failed to fetch todo: Items key not found');
      }
    } else {
      throw Exception('Failed to fetch todo: ${response.statusCode}');
    }
  }
}