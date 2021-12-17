import 'package:chat_app_flutter/model/localUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  LocalUser? _localUserFromFirebase(User? firebaseUser) {
    return firebaseUser != null
        ? LocalUser(userId: firebaseUser.uid.toString())
        : null;
  }

  Future logInWithEmail(
      {required String email, required String password}) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? firebaseUser = result.user;
      return _localUserFromFirebase(firebaseUser);
    } catch (e) {
      print(e.toString());
    }
  }

  Future RegisterWithEmail(
      {required String email, required String password}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? firebaseUser = result.user;
      return _localUserFromFirebase(firebaseUser);
    } catch (e) {
      print(e.toString());
    }
  }

  Future resetPassword({required String email}) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
