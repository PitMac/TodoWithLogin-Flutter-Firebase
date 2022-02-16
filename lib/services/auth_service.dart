import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_todo/services/todo_service.dart';
import 'package:flutter/cupertino.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _email = '';
  get email => _email;
  set email(value) {
    _email = value;
    notifyListeners();
  }

  String _password = '';
  get password => _password;
  set password(value) {
    _password = value;
    notifyListeners();
  }

  Future<String> register({email, password}) async {
    if (email == '' || password == '') return 'Fields empty';
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _firestore
          .collection('users')
          .doc(cred.user!.uid)
          .set({"email": email});
      return 'Created User';
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

  Future<String> logIn({email, password}) async {
    if (email == '' || password == '') return 'Fields empty';
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return 'Welcome';
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

  signOut() async {
    await _auth.signOut();
    TodoService().items = [];
    notifyListeners();
  }
}
