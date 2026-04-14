// Singleton to manage Users
import 'package:trovami/core/Group.dart';
import 'package:trovami/core/OldUser.dart';

class GroupsManager {
  static final GroupsManager _instance = GroupsManager._internal();

  factory GroupsManager() {
    return _instance;
  }

  Group _currentGroup = Group();

  GroupsManager._internal();

  List<OldUser> users = <OldUser>[];

  Group currentGroup() {
    return _currentGroup;
  }
}
