import 'package:chat_app_flutter/model/localUser.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth auth;
  Auth({required this.auth});

  Stream<User?> get user => auth.authStateChanges();

  LocalUser? _localUserFromFirebase(User? firebaseUser) {
    return firebaseUser != null
        ? LocalUser(userId: firebaseUser.uid.toString())
        : null;
  }

  Future logInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(
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
      UserCredential result = await auth.createUserWithEmailAndPassword(
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
      return await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      return await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
