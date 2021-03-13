// Singleton to manage Users

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trovami/helpers/CloudFirebaseHelper.dart';
import 'package:trovami/model/DocItem.dart';
import 'package:trovami/model/TrovUser.dart';

class UserManager extends ChangeNotifier {
// TODO: Deprecate.  No need to store many users
// Only need current user (Profile) and friends (stored with Profile)
//  Map<String, TrovUser> users = new LinkedHashMap<String, TrovUser>();
//  String currentUserId;

  Future<FirebaseResponse> getThese(List<String> ids) async {
    FirebaseResponse initResponse =
        await CloudFirebaseHelper().assureFireBaseInitialized();
    if (initResponse.hasError()) return initResponse;

    var returnResponse;

    await CloudFirebaseHelper.getItemsMatchingOneOf(
            TABLE_USERS, DocItem.FLD_ID, ids, TrovUser())
        .then((FirebaseResponse response) => {
              if (response.hasError())
                {
                  print(
                      "Trovami.UsersManager.getItemsArrayContains failed with $response.getError()")
                }
              else
                {
                  print(
                      "Trovami.UsersManager.getItemsArrayContains succeeded returning ${response.items.length} docs")
                },
              returnResponse = response
//      TriggersHelper().trigger(TRIGGER_GROUPS_UPDATED)
            });
    // users = response.items;
    print("Trovami.UsersManager.getThese: returning");
    return returnResponse;
  }
}
