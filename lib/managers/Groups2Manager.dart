import 'package:flutter/material.dart';
import 'package:trovami/helpers/CloudFirebaseHelper.dart';
import 'package:trovami/helpers/TriggersHelper.dart';
import 'package:trovami/model/Group2.dart';

import 'ThemeManager.dart';

class Groups2Manager { // extends ChangeNotifier{
  //<editor-fold desc="Singleton Setup">
  static final Groups2Manager _instance = new Groups2Manager._internal();
  factory Groups2Manager() {
    return _instance;
  }
  Groups2Manager._internal();
  //</editor-fold>

  var groups = Map<String, Object>();

  String currentGroupId;

  acquire() async {
    FirebaseResponse response = await CloudFirebaseHelper().assureFireBaseInitialized();
    if (response.hasError())
      return;

    await CloudFirebaseHelper.getItems("groups", Group2()).then((FirebaseResponse response) => {
      if (response.hasError()){
        print ("GroupsManager.fetchDocs failed with $response.getError()")
      } else {
        print ("GroupsManager.fetchDocs succeeded returning ${response.docs.length} docs")
      },
      groups = response.docs,
//      notifyListeners()
      TriggersHelper().trigger(TRIGGER_GROUPS_UPDATED)
    });
  }

  Group2 currentGroup() {
    return groups[currentGroupId];
  }

  hasCurrentGroup() {
    groups.containsKey(currentGroupId);
  }

  List<Widget> getGroupWidgets(BuildContext context) {
    List <Widget> groupWidgets = new List<Widget>();

    for (Group2 group in groups.values) {
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
  _getGroup(Group2 group) {
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
