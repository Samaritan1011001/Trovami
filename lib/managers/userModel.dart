import 'package:flutter/cupertino.dart';
import 'package:trovami/models/User.dart';

class UserModel extends ChangeNotifier {
  final User _currentUser = User();

  void signUp(User user) {}
}
