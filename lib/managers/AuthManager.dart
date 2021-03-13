import 'dart:async';
import 'package:flutter/material.dart';
import 'package:trovami/helpers/CloudFirebaseHelper.dart';
import 'package:trovami/helpers/firebaseAuthHelper.dart';
import 'package:trovami/model/TrovUser.dart';

class AuthManager extends ChangeNotifier {
  AuthManager() {
    _setup();
  }

  FirebaseAuthHelper _firebaseAuthService;

  final StreamController<TrovUser> _onAuthStateChangedController =
      StreamController<TrovUser>.broadcast();
  @override
  Stream<TrovUser> get onAuthStateChanged =>
      _onAuthStateChangedController.stream;

  StreamSubscription<TrovUser> _firebaseAuthSubscription;

  void _setup() {
    CloudFirebaseHelper().assureFireBaseInitialized().then((value) {
      _firebaseAuthService = FirebaseAuthHelper();
      _firebaseAuthSubscription =
          _firebaseAuthService.onAuthStateChanged.listen((TrovUser user) {
        _onAuthStateChangedController.add(user);
      }, onError: (dynamic error) {
        _onAuthStateChangedController.addError(error);
      });
    });
  }

  @override
  Future<TrovUser> currentUser() => _firebaseAuthService.currentUser();

  @override
  Future<TrovUser> createUserWithEmailAndPassword(
          String email, String password) =>
      _firebaseAuthService.createUserWithEmailAndPassword(email, password);

  @override
  void dispose() {
    _firebaseAuthSubscription?.cancel();

    _onAuthStateChangedController?.close();
  }
}
