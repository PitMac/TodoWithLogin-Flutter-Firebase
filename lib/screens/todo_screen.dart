import 'package:firebase_todo/services/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todoService = Provider.of<TodoService>(context);

    postTodo() async {
      final res = await todoService.postTodo(
        title: todoService.title,
        description: todoService.description,
        made: todoService.made,
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));
      Navigator.pop(context);
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('TODO'),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                onChanged: (value) {
                  todoService.title = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                onChanged: (value) {
                  todoService.description = value;
                },
              ),
              SwitchListTile(
                title: const Text('Made: '),
                value: todoService.made,
                onChanged: (value) {
                  todoService.made = value;
                },
              ),
              MaterialButton(
                onPressed: postTodo,
                child:
                    const Text('Send', style: TextStyle(color: Colors.white)),
                color: Colors.blueAccent,
              )
            ],
          ),
        ));
  }
}
