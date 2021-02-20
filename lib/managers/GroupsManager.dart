// Singleton to manage Users
import 'package:trovami/model/Group.dart';
import 'package:trovami/model/OldUser.dart';

class GroupsManager {
//  Map _items = new LinkedHashMap<String, FileImage>();

  static final GroupsManager _instance = new GroupsManager._internal();

  factory GroupsManager() {
    return _instance;
  }

  Group _currentGroup = new Group();

  GroupsManager._internal();

  List<OldUser> users=new List<OldUser>();

  Group currentGroup() {
    return _currentGroup;
  }

}