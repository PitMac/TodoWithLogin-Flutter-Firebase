import 'package:firebase_todo/services/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateTodoScreen extends StatelessWidget {
  const UpdateTodoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todoService = Provider.of<TodoService>(context);
    final todo = ModalRoute.of(context)!.settings.arguments as dynamic;

    updateTodo() async {
      if (todoService.title == '') {
        todoService.title = todo['title'];
      }
      if (todoService.description == '') {
        todoService.description = todo['description'];
      }
      final res = await todoService.updateTodo(
        title: todoService.title,
        description: todoService.description,
        made: todoService.made,
        id: todo.id,
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));
      Navigator.pop(context);
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('TODO'),
          centerTitle: true,
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
                initialValue: todo['title'],
                onTap: () {
                  todoService.title = todo['title'];
                },
                onChanged: (value) {
                  todoService.title = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                onTap: () {
                  todoService.description = todo['description'];
                },
                initialValue: todo['description'],
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
                onPressed: updateTodo,
                child:
                    const Text('Update', style: TextStyle(color: Colors.white)),
                color: Colors.blueAccent,
              )
            ],
          ),
        ));
  }
}
