
// Singleton to manage Users
import 'dart:collection';

import 'package:trovami/core/Group.dart';

class GroupsManager {
  static final GroupsManager _instance = new GroupsManager._internal();

  factory GroupsManager() {
    return _instance;
  }

  GroupsManager._internal();

  var groups = new LinkedHashMap<String, Group>();

  String currentGroupId;

  Group currentGroup() {
    return groups[currentGroupId];
  }

}
