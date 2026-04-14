// Singleton to manage Users
import 'dart:collection';

import 'package:trovami/core/OldUser.dart';

class UsersManager {
  static final UsersManager _instance = UsersManager._internal();

  factory UsersManager() {
    return _instance;
  }

  UsersManager._internal();

  Map<String, OldUser> users = LinkedHashMap<String, OldUser>();

  String? currentUserId;

  OldUser? currentUser() {
    return users[currentUserId];
  }
}
