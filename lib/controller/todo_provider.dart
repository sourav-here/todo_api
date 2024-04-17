// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:todo/model/todo_model.dart';
import 'package:todo/service/todo_services.dart';


class TodoProvider extends ChangeNotifier {
  bool isLoading = true;
  List<Todo> items = [];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  Future<void> fetchTodo(BuildContext context) async {
    try {
      final response = await TodoServices.fetchTodo();
      if (response.isEmpty) {
        throw Exception('Failed to fetch todo: Response is null');
      }
      items = response;
    } catch (e) {
      const SnackBar(
            content: Text('Failed to fetch todo'),
            duration: Duration(seconds: 3),
          );
    }
    isLoading = false;
    notifyListeners();
  }

  Future<bool> updateTodo(String id, String title, String description) async {
    try {
      await TodoServices.updateTodo(id, title, description);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> submitTodo(String title, String description) async {
    try {
      await TodoServices.submitTodo(title, description);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> deleteById(String id) async {
    final isSuccess = await TodoServices.deleteById(id);
    if (isSuccess) {
      items.removeWhere((todo) => todo.id == id);
      notifyListeners();
    } else {
      throw Exception('Failed to delete todo');
    }
  }

  void clearControllers() {
    titleController.clear();
    detailsController.clear();
    notifyListeners();
  }
}