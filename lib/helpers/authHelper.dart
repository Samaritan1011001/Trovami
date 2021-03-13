import 'package:trovami/model/TrovUser.dart';

abstract class AuthHelper {
  Future<TrovUser> currentUser();
  Future<TrovUser> signInWithEmailAndPassword(String email, String password);
  Future<TrovUser> createUserWithEmailAndPassword(
      String email, String password);
  Future<void> signOut();
  Stream<TrovUser> get onAuthStateChanged;
  void dispose();
}
