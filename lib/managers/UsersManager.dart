// Singleton to manage Users

import 'package:trovami/helpers/CloudFirebaseHelper.dart';
import 'package:trovami/model/DocItem.dart';
import 'package:trovami/model/TrovUser.dart';

class UsersManager {
  static final UsersManager _instance = new UsersManager._internal();

  factory UsersManager() {
    return _instance;
  }

  UsersManager._internal();

// TODO: Deprecate.  No need to store many users
// Only need current user (Profile) and friends (stored with Profile)
//  Map<String, TrovUser> users = new LinkedHashMap<String, TrovUser>();
//  String currentUserId;

  Future<FirebaseResponse> getThese(List<String> ids) async {
    FirebaseResponse response = await CloudFirebaseHelper().assureFireBaseInitialized();
    if (response.hasError())
      return response;

    await CloudFirebaseHelper.getItemsMatchingOneOf(TABLE_USERS, DocItem.FLD_ID, ids, TrovUser()).then((FirebaseResponse response) => {
      if (response.hasError()){
        print ("usersManager.getItemsArrayContains failed with $response.getError()")
      } else {
        print ("GroupsManager.getItemsArrayContains succeeded returning ${response.items.length} docs")
      },
//      TriggersHelper().trigger(TRIGGER_GROUPS_UPDATED)
    });
    // users = response.items;
    return response;
  }

  // TrovUser currentUser() {
  //   return users[currentUserId];
  // }

}
