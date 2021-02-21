import 'package:flutter/material.dart';
import 'package:trovami/helpers/CloudFirebaseHelper.dart';
import 'package:trovami/helpers/TriggersHelper.dart';
import 'package:trovami/model/Group.dart';

import 'ThemeManager.dart';

class GroupsManager { // extends ChangeNotifier{
  //<editor-fold desc="Singleton Setup">
  static final GroupsManager _instance = new GroupsManager._internal();
  factory GroupsManager() {
    return _instance;
  }
  GroupsManager._internal();
  //</editor-fold>

  var groups = Map<String, Object>();

  String currentGroupId;

  getAll() async {
    FirebaseResponse response = await CloudFirebaseHelper().assureFireBaseInitialized();
    if (response.hasError())
      return;

    await CloudFirebaseHelper.getAllItems(TABLE_GROUPS, Group()).then((FirebaseResponse response) => {
      if (response.hasError()){
        print ("GroupsManager.getItems failed with $response.getError()")
      } else {
        print ("GroupsManager.getItems succeeded returning ${response.items.length} docs")
      },
      groups = response.items,
//      notifyListeners()
    });
  }

  getOwned(String id) async {
    FirebaseResponse response = await CloudFirebaseHelper().assureFireBaseInitialized();
    if (response.hasError())
      return;

    await CloudFirebaseHelper.getItemsMatching(TABLE_GROUPS, FIELD_OWNER, id, Group()).then((FirebaseResponse response) => {
      if (response.hasError()){
        print ("getItemsArrayContains.getItems failed with $response.getError()")
      } else {
        print ("getItemsArrayContains.getItems succeeded returning ${response.items.length} docs")
      },
      groups = response.items,
//      notifyListeners()
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
