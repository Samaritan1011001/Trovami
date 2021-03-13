import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trovami/helpers/CloudFirebaseHelper.dart';
import 'package:trovami/helpers/authHelper.dart';
import 'package:trovami/model/TrovUser.dart';

// class FirebaseAuthHelper {
//   //To create new User
//   Future createUser(String email, String password) async {
//     FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//     await firebaseAuth.createUserWithEmailAndPassword(
//         email: email, password: password);
//   }
// }

class FirebaseAuthHelper implements AuthHelper {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  TrovUser _userFromFirebase(User user) {
    if (user == null) {
      return null;
    }
    return TrovUser();
  }

  @override
  Stream<TrovUser> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  @override
  Future<TrovUser> signInWithEmailAndPassword(
      String email, String password) async {
    final UserCredential userCredential =
        await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _userFromFirebase(userCredential.user);
  }

  @override
  Future<TrovUser> createUserWithEmailAndPassword(
      String email, String password) async {
    final UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(userCredential.user);
  }

  @override
  Future<TrovUser> currentUser() async {
    return _userFromFirebase(_firebaseAuth.currentUser);
  }

  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  @override
  void dispose() {}
}
