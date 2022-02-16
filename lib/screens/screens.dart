import 'package:firebase_todo/screens/home_screen.dart';
import 'package:firebase_todo/screens/login_screen.dart';
import 'package:firebase_todo/screens/todo_screen.dart';
import 'package:firebase_todo/screens/update_todo_screen.dart';
import 'package:flutter/material.dart';

final routes = <String, WidgetBuilder>{
  'login': (BuildContext _) => const LoginScreen(),
  'home': (BuildContext _) => const HomeScreen(),
  'todo': (BuildContext _) => const TodoScreen(),
  'update': (BuildContext _) => const UpdateTodoScreen(),
};
