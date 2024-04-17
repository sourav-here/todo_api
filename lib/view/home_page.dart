// ignore_for_file: use_build_context_synchronously, unnecessary_import
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo/controller/todo_provider.dart';
import 'package:todo/model/todo_model.dart';
import 'package:todo/view/add_screen.dart';
import 'package:todo/widget/todo_card.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Colors.deepPurple[400],
          centerTitle: true,
          title: const Text('API TODO',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _navigateToAdd(context),
          label:
              const Text('ADD', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: Stack(
          children: [
            const SizedBox(
              width: double.infinity,
              height: double.infinity,
            ),
            FutureBuilder(
              future: _fetchTodoData(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return _buildTodoList(context);
                }
              },
            ),
          ],
        ));
  }

  Future<void> _fetchTodoData(BuildContext context) async {
    final provider = Provider.of<TodoProvider>(context, listen: false);
    await provider.fetchTodo(context);
  }

  Widget _buildTodoList(BuildContext context) {
    final provider = Provider.of<TodoProvider>(context);
    return provider.items.isEmpty
        ? const Center(child: Text('No items in Todo'))
        : ListView.builder(
            itemCount: provider.items.length,
            itemBuilder: (context, index) {
              final Todo item = provider.items[index];
              return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TodoCard(
                    index: index,
                    item: item.toMap(),
                    onDelete: () => _deleteById(context, item.id),
                    onEdit: () => _navigateToEdit(context, item),
                  ));
            },
          );
  }

  void _navigateToAdd(BuildContext context) {
    Navigator.push(
            context, MaterialPageRoute(builder: (context) => const AddScreen()))
        .then((value) {
      if (value != null) {
        final provider = Provider.of<TodoProvider>(context, listen: false);
        provider.fetchTodo(context);
      }
    });
  }

  void _navigateToEdit(BuildContext context, Todo todo) {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => AddScreen(todo: todo)))
        .then((value) {
      if (value != null) {
        final provider = Provider.of<TodoProvider>(context, listen: false);
        provider.fetchTodo(context);
      }
    });
  }

  Future<void> _deleteById(BuildContext context, String id) async {
    final provider = Provider.of<TodoProvider>(context, listen: false);
    try {
      await provider.deleteById(id);
      const SnackBar(
        content: Text('Deleted succesfully'),
        duration: Duration(seconds: 3),
      );
    } catch (e) {
      const SnackBar(
        content: Text('Unable to delete'),
        duration: Duration(seconds: 3),
      );
    }
  }
}
