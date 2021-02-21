import 'package:trovami/helpers/CloudFirebaseHelper.dart';
import 'package:trovami/helpers/TriggersHelper.dart';
import 'package:trovami/model/TrovUser.dart';

import 'UsersManager.dart';

const String FIELD_EMAIL         = "email";

class ProfileManager { // extends ChangeNotifier{
  //<editor-fold desc="Singleton Setup">
  static final ProfileManager _instance = new ProfileManager._internal();
  factory ProfileManager() {
    return _instance;
  }
  ProfileManager._internal();
  //</editor-fold>

  TrovUser profile;
  var friends = Map<String, TrovUser>();

  // addFriends(List<String> moreFriends){
  //   friends.addAll(moreFriends);
  // }

  Future<TrovUser> get(String email) async {
    FirebaseResponse initResponse = await CloudFirebaseHelper().assureFireBaseInitialized();
    if (initResponse.hasError())
      return null;

    await CloudFirebaseHelper.getItem(TABLE_USERS, FIELD_EMAIL, email, TrovUser()).then((response) async => {
      if (response.hasError()){
        print ("ProfileManager.getItem failed with $response.getError()")
      } else {
        print ("ProfileManager.getItems succeeded returning ${response.items.length} docs")
      },
      profile = response.items.values.first,
//      notifyListeners()

    });
//    await getFriends(profile.friends);
//    TriggersHelper().trigger(TRIGGER_PROFILE_UPDATED);
    return profile;
  }

  Future<FirebaseResponse> getFriends() async{
    var response = await UsersManager().getThese(profile.friends);
    if (!response.hasError()){
      friends.clear();
      for (Object obj in response.items.values){
        var user = obj as TrovUser;
        friends.putIfAbsent(user.id, () => user);
      }
    }
    return response;
  }
}
