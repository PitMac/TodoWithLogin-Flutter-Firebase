import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class TodoService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var items = [];
  bool isLoading = false;
  String _title = '';
  String _description = '';
  bool _made = false;

  String get title => _title;
  set title(String title) {
    _title = title;
    notifyListeners();
  }

  get description => _description;
  set description(description) {
    _description = description;
    notifyListeners();
  }

  bool get made => _made;
  set made(bool value) {
    _made = value;
    notifyListeners();
  }

  TodoService() {
    loadTodos();
  }

  clearData() {
    items = [];
    notifyListeners();
  }

  Future loadTodos() async {
    items = [];
    isLoading = true;
    notifyListeners();
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        return;
      }
      final res = await _firestore
          .collection('todos')
          .where('userId', isEqualTo: userId)
          .get();

      for (var element in res.docs) {
        items.add(element);
      }
      isLoading = false;
      notifyListeners();
      return items;
    } catch (e) {
      print(e);
    }
  }

  Future deleteTodo({id}) async {
    try {
      await _firestore.collection('todos').doc(id).delete();
      loadTodos();
      notifyListeners();
      return 'Deleted Todo';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return 'The email is badly formatted.';
      } else if (e.code == 'weak-password') {
        return "Password should be at least 6 characters";
      } else {
        return e.code;
      }
    } catch (e) {
      return 'Error';
    }
  }

  Future<String> postTodo({title, description, made}) async {
    if (title == '' || description == '') return 'Fields empty';
    try {
      final todoId = const Uuid().v1();
      await _firestore.collection('todos').doc(todoId).set({
        "description": description,
        "made": made,
        "title": title,
        "userId": _auth.currentUser!.uid,
      });
      loadTodos();
      notifyListeners();
      return 'Created Todo';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return 'The email is badly formatted.';
      } else if (e.code == 'weak-password') {
        return "Password should be at least 6 characters";
      } else {
        return e.code;
      }
    } catch (e) {
      return 'Error';
    }
  }

  Future<String> updateTodo({id, title, description, made}) async {
    if (title == '' || description == '') {
      return 'No changes. You must change title and description';
    }
    try {
      await _firestore.collection('todos').doc(id).update({
        "description": description,
        "made": made,
        "title": title,
      });
      loadTodos();
      description = '';
      title = '';
      notifyListeners();
      return 'Updated Todo';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return 'The email is badly formatted.';
      } else if (e.code == 'weak-password') {
        return "Password should be at least 6 characters";
      } else {
        return e.code;
      }
    } catch (e) {
      return 'Error';
    }
  }
}
