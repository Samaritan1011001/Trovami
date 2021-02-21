
// Singleton to manage Users
import 'dart:collection';

import 'package:trovami/helpers/CloudFirebaseHelper.dart';
import 'package:trovami/model/OldUser.dart';
import 'package:trovami/model/TrovUser.dart';

class UsersManager {
  static final UsersManager _instance = new UsersManager._internal();

  factory UsersManager() {
    return _instance;
  }

  UsersManager._internal();

  Map<String, OldUser> users = new LinkedHashMap<String, OldUser>();

  Map<String, TrovUser> users2 = new LinkedHashMap<String, TrovUser>();

  String currentUserId;

  get(String id) async {
    FirebaseResponse response = await CloudFirebaseHelper().assureFireBaseInitialized();
    if (response.hasError())
      return;

    await CloudFirebaseHelper.getAllItems(TABLE_USERS, TrovUser()).then((FirebaseResponse response) => {
      if (response.hasError()){
        print ("usersManager.getItems failed with $response.getError()")
      } else {
        print ("GroupsManager.getItems succeeded returning ${response.items.length} docs")
      },
      users = response.items,
//      TriggersHelper().trigger(TRIGGER_GROUPS_UPDATED)
    });
  }

  OldUser currentUser() {
    return users[currentUserId];
  }

}
