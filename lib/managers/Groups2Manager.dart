import 'package:flutter/material.dart';
import 'package:trovami/helpers/CloudFirebaseHelper.dart';
import 'package:trovami/model/Group2.dart';

import 'ThemeManager.dart';

class Groups2Manager {
  static final Groups2Manager _instance = Groups2Manager._internal();
  factory Groups2Manager() {
    return _instance;
  }
  Groups2Manager._internal();

  var groups = Map<String, Object>();

  String? currentGroupId;

  Future<FirebaseResponse> acquire() async {
    var returnResponse = FirebaseResponse();
    await CloudFirebaseHelper.getItems("groups", Group2())
        .then((FirebaseResponse response) => {
              if (response.hasError())
                {
                  print(
                      "GroupsManager.fetchDocs failed with ${response.getError()}")
                }
              else
                {
                  print(
                      "GroupsManager.fetchDocs succeeded returning ${response.docs.length} docs")
                },
              returnResponse = response,
              groups = returnResponse.docs
            });
    return returnResponse;
  }

  Group2? currentGroup() {
    return groups[currentGroupId] as Group2?;
  }

  List<Widget> getGroupWidgets(BuildContext context) {
    List<Widget> groupWidgets = <Widget>[];

    for (var entry in groups.values) {
      Group2 group = entry as Group2;
      groupWidgets.add(InkWell(
        splashColor: Colors.blue,
        onTap: () {
          print(group.name);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Container(
            alignment: Alignment.center,
            child: _getGroup(group),
          ),
        ),
      ));
      groupWidgets.add(
        const Divider(height: 2.0, color: Colors.blueGrey),
      );
    }
    return groupWidgets;
  }

  _getGroup(Group2 group) {
    Widget widget;

    widget = Row(children: <Widget>[
      const Spacer(),
      Text(
        group.name ?? '',
        style: ThemeManager().getStyle(STYLE_NORMAL),
      ),
      const Spacer(),
      Text("(${group.members.length} members)",
          style: ThemeManager().getStyle(STYLE_NORMAL)),
      const Spacer(),
    ]);
    return widget;
  }
}
