import 'package:flutter/material.dart';
import 'package:trovami/helpers/CloudFirebaseHelper.dart';
import 'package:trovami/helpers/TriggersHelper.dart';
import 'package:trovami/model/Group2.dart';
import 'package:trovami/model/TrovUser.dart';

import 'ThemeManager.dart';

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

  acquire(String email) async {
    FirebaseResponse response = await CloudFirebaseHelper().assureFireBaseInitialized();
    if (response.hasError())
      return;

    await CloudFirebaseHelper.getItem(TABLE_USERS, FIELD_EMAIL, email, TrovUser()).then((FirebaseResponse response) => {
      if (response.hasError()){
        print ("ProfileManager.getItem failed with $response.getError()")
      } else {
        print ("ProfileManager.getItems succeeded returning ${response.items.length} docs")
      },
      profile = response.items.values.first,
//      notifyListeners()
      TriggersHelper().trigger(TRIGGER_PROFILE_UPDATED)
    });
  }
}
