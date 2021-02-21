import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:trovami/helpers/CloudFirebaseHelper.dart';
import 'package:trovami/managers/Groups2Manager.dart';
import 'package:trovami/managers/ThemeManager.dart';
import 'package:trovami/model/Group2.dart';
import 'UnitTestsScreen.dart';
import 'AddGroupScreen.dart';

class GroupsScreen extends StatefulWidget {
  String selectedGroup = "";
  @override
  _BodyState createState() => new _BodyState();
}

class _BodyState extends State<GroupsScreen> {
  _BodyState();

  @override
  void initState();

  @override
  Widget build(BuildContext context) {

//    Provider.of<GroupsScreen()>(context, listen: false);

    return new Scaffold(
        appBar: new AppBar(
          leading: new Container(),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.group_add),
              onPressed: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddGroupScreen(),
                  ),
                );
              },
              iconSize: 42.0,
            ),
            new IconButton(
              icon: new Icon(Icons.edit),
              onPressed: () => handleMoreMenu(),
              iconSize: 35.0,
            ),
          ],
          title: new Text('Groups'),
        ),
        body: _groupsWidget()
    );
  }

  _groupsWidget() {
    if (CloudFirebaseHelper().isReady()) {
      return getGroupWidgets(context);
    } else if(!CloudFirebaseHelper().isInitialized()) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Fetching Groups...", style: ThemeManager().getStyle(STYLE_NORMAL_BOLD),),
      );
    } else if (CloudFirebaseHelper().hasError()){
      return <Widget>[ Text("Failed to connect to Firebase", style: ThemeManager().getStyle(STYLE_NORMAL_BOLD))];
    }

  }

  Widget getGroupWidgets(BuildContext context) {
    List <Widget> groupWidgets = new List<Widget>();

    for (Group2 group in Groups2Manager().groups.values) {
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

    if (groupWidgets.isEmpty){
      print("Trovami.GroupsScreen: No groups found");
      return Text("No Groups Found");
    }

    print("Trovami.GroupsScreen: Displaying ${groupWidgets.length} groups");


    return Expanded(
      flex: 3,
      child:
      SingleChildScrollView(
        child: Column(
          children: groupWidgets
        ),
      ),
    );
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

  handleMoreMenu() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UnitTestsScreen(),
      ),
    );
  }
}
