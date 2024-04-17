import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/controller/todo_provider.dart';
import 'package:todo/view/home_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context) => TodoProvider(),
      child: MaterialApp(debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home:  const HomePage(),
      ),
    );
  }
}