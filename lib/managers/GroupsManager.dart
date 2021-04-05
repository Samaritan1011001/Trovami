import 'package:flutter/material.dart';
import 'package:trovami/helpers/CloudFirebaseHelper.dart';
import 'package:trovami/model/Group.dart';

import 'ThemeManager.dart';

class GroupsManager extends ChangeNotifier{
  GroupsManager(String userId) {
    print("GroupsManager Instantiated");
    getOwned(userId);
  }

  var groups = Map<String, Object>();

  String currentGroupId;

  getAll() async {
    FirebaseResponse initializeResponse = await CloudFirebaseHelper().assureFireBaseInitialized();
    if (initializeResponse.hasError())
      return;

    return await CloudFirebaseHelper.getAllItems(TABLE_GROUPS, Group()).then((FirebaseResponse response) => {
      if (response.hasError()){
        print ("GroupsManager.getItems failed with $response.getError()")
      } else {
        print ("GroupsManager.getItems succeeded returning ${response.items.length} docs")
      },
//      groups = response.items,
    });
  }

  getOwned(String id) {
    CloudFirebaseHelper().assureFireBaseInitialized()
    .then((response) => {
      CloudFirebaseHelper.getItemsMatching(TABLE_GROUPS, FIELD_OWNER, id, Group()).then((FirebaseResponse response) => {
        if (response.hasError()){
          print ("Trovami.getOwned: error detected: $response.getError()")
        } else {
          print ("Trovami.getOwned: succeeded returning ${response.items.length} docs")
        },
        groups = response.items,
        notifyListeners()
      })
    })
    .catchError((error) => {
      print("Trovami.GroupsManager.getOwned() failed"),
      notifyListeners()
    });
  }

  getThese(List<String> ids) async {
    FirebaseResponse response = await CloudFirebaseHelper().assureFireBaseInitialized();
    if (response.hasError())
      return;

    await CloudFirebaseHelper.getItemsArrayContains(TABLE_GROUPS, FIELD_ID, ids, Group()).then((FirebaseResponse response) => {
      if (response.hasError()){
        print ("getItemsArrayContains.getItems failed with $response.getError()")
      } else {
        print ("getItemsArrayContains.getItems succeeded returning ${response.items.length} docs")
      },
      groups = response.items,
//      notifyListeners()
    });
  }
  
  Group currentGroup() {
    return groups[currentGroupId];
  }

  hasCurrentGroup() {
    groups.containsKey(currentGroupId);
  }

  List<Widget> getGroupWidgets(BuildContext context) {
    List <Widget> groupWidgets = new List<Widget>();

    for (Group group in groups.values) {
      groupWidgets.add(
          InkWell(
            splashColor: Colors.blue,
            onTap: () {
//              handleGroupTap(context, player.id);
              print(group.name);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Container(
                alignment: Alignment.center,
                child: _getGroup(group),
              ),
            ),
          ));
        groupWidgets.add(Divider(height: 2.0, color: Colors.blueGrey),
      );
    }
    return groupWidgets;
  }

  setCurrent(String id){
    currentGroupId = id;
    notifyListeners();
  }

  //<editor-fold desc="Private Members">
  _getGroup(Group group) {
    Widget widget;

    widget = Row (
        children: <Widget>[
          Spacer(),
          Text(group.name, style: ThemeManager().getStyle(STYLE_NORMAL),),
          Spacer(),
          Text("(${group.members.length} members)", style: ThemeManager().getStyle(STYLE_NORMAL)),
          Spacer(),
        ]
    );
    return widget;
  }
//</editor-fold>
  
}
