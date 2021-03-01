import 'package:flutter/widgets.dart';
import 'package:trovami/helpers/CloudFirebaseHelper.dart';
import 'package:trovami/model/DocItem.dart';
import 'package:trovami/model/TrovUser.dart';

import 'UsersManager.dart';

const String FIELD_EMAIL         = "email";

class ProfileManager extends ChangeNotifier{

  ProfileManager();

  TrovUser profile;

  var friendsData = Map<String, TrovUser>();

  // addFriends(List<String> moreFriends){
  //   friends.addAll(moreFriends);
  // }

  TrovUser getFriendData(String id){
    return friendsData[id];
  }

  //<editor-fold desc="DB Calls">
  Future<TrovUser> get(String email) async {
    FirebaseResponse initResponse = await CloudFirebaseHelper().assureFireBaseInitialized();
    if (initResponse.hasError())
      return null;

    await CloudFirebaseHelper.getItem(TABLE_USERS, FIELD_EMAIL, email, TrovUser()).then((response) async => {
      if (response.hasError()){
        print ("ProfileManager.get($email) failed with $response.getError()")
      } else {
        print ("ProfileManager.getItems($email) succeeded returning ${response.items.length} docs")
      },
      profile = response.items.values.first,
      notifyListeners()
    });
    return profile;
  }
  getFriends() async{
    getThese(profile.friends).then((FirebaseResponse response)=>{
      print("Trovami.ProfileManager.getFriends: returned from UsersManager.getThese"),
      if (!response.hasError()){
          friendsData.clear(),
        for (Object obj in response.items.values){
          friendsData.putIfAbsent((obj as TrovUser).id, () => (obj as TrovUser))
        }
      }
    });
    notifyListeners();
  }

  Future<FirebaseResponse> getThese(List<String> ids) async {
    FirebaseResponse initResponse = await CloudFirebaseHelper().assureFireBaseInitialized();
    if (initResponse.hasError())
      return initResponse;

    var returnResponse;

    await CloudFirebaseHelper.getItemsMatchingOneOf(TABLE_USERS, DocItem.FLD_ID, ids, TrovUser()).then((FirebaseResponse response) => {
      if (response.hasError()){
        print ("Trovami.ProfileManager.getItemsMatchingOneOf failed with $response.getError()")
      } else {
        print ("Trovami.ProfileManager.getItemsMatchingOneOf succeeded returning ${response.items.length} docs")
      },
      returnResponse = response
    });
    print("Trovami.UsersManager.getThese: returning");
    return returnResponse;
  }

  load(String email) async{
    get(email).then((user) => getFriends());
  }
//</editor-fold>
}
