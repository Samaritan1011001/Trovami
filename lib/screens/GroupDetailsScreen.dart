import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:trovami/managers/Groups2Manager.dart';
import '../Strings.dart';
import '../helpers/functionsForFirebaseApiCalls.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

import '../helpers/RoutesHelper.dart';
import 'GroupsScreen.dart';
import '../helpers/httpClient.dart';
import 'HomeScreen.dart';
import '../main.dart';
import '../model/Group.dart';
import '../model/OldUser.dart';
import '../model/UserLocation.dart';
import 'SignInScreen.dart';

class GroupDetailsScreen extends StatefulWidget {
  @override
  GroupDetailsScreenState createState() => new GroupDetailsScreenState();
}

class GroupDetailsScreenState extends State<GroupDetailsScreen>{
  @override
  Widget build(BuildContext context)=>
      new Scaffold(
        body: new Container(
          child:new GroupStatus(),
        ),
      );
}

class GroupStatus extends StatefulWidget {
  @override
  GroupStatusState createState() => new GroupStatusState();
}

class GroupStatusState extends State<GroupStatus>{

  // void showInSnackBar(String value) {
  //   _scaffoldKeySecondary2.currentState.showSnackBar(
  //       new SnackBar(
  //           content: new Text(value)
  //       )
  //   );
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var curGroup = Groups2Manager().currentGroup();
    var children = new List.generate(curGroup.members.length, (int i) => memberlist(curGroup.members[i]));
    bool togglestate = true;

    return Scaffold(
      appBar: new AppBar(
        leading: defaultTargetPlatform == TargetPlatform.iOS
            ? new CupertinoButton(child: new Icon(Icons.keyboard_backspace), onPressed: (){
          Navigator.of(context).pop();
        },
        ) : new FlatButton(onPressed: (){
          Navigator.of(context).pop();
        },
            child:new Icon(Icons.keyboard_backspace)
        ),
        actions: <Widget>[
          new FlatButton(onPressed:()async {
            await Navigator.of(context).pushNamed(ROUTE_MAP);
          },
              child: new Text("Show Map")
          ),
        ],
        flexibleSpace: new FlexibleSpaceBar(
          title: new Text(Strings.groupDetails),
        ),
      ),
      body :new Container(
        child: new ListView(
          children : <Widget> [
            Container(
              margin: const EdgeInsets.all(10.0),
              color: Colors.red,
              height: 100,
              child: Center(
                child: Text(Strings.dontUseRealLocation,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              ),
            ),
            new Row(children :<Widget>[
              new Container(child: new Text(Strings.shareLiveLocation,style: new TextStyle(fontSize: 20.0)),
                padding: const EdgeInsets.only( left:10.0),
              ),
              new Container(
                child: defaultTargetPlatform == TargetPlatform.iOS
                    ? new CupertinoSwitch(value: togglestate, onChanged: (bool newValue) {
                  // toggleMemberLocation(newValue);
                  // setState(() {
                  //   togglestate = newValue;
                  // });
                },)
                    : new Switch(value: togglestate, onChanged: (bool newValue) {
                  // toggleMemberLocation(newValue);
                  // setState(() {
                  //   togglestate = newValue;
                  // });
                },
                ),
              ),
            ],
            ),
            new Container(
              child: new Column(
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new CircleAvatar(
                        child:new Icon(Icons.group),
                        backgroundColor: const Color.fromRGBO(0, 0, 0, 0.2),
                      ),
                      new Expanded(child:new Container(
                          child: new Text(
                            "Group Name: ${curGroup.name}",
                            style: new TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                          ),
                          padding: const EdgeInsets.only( left:20.0)
                      ),
                      ),
                    ],
                  ),
                ],
              ),
              padding: const EdgeInsets.only( left:10.0,top: 5.0,bottom: 5.0),
              decoration: new BoxDecoration(
                border: new Border(
                  bottom: new BorderSide(width: 1.0, color: const Color.fromRGBO(0, 0, 0, 0.2),style: BorderStyle.solid),
                ),
              ),
            ),
            new Container(
              child:new Text("Members :",
                style: new TextStyle(fontSize: 20.0),
              ),
              padding: const EdgeInsets.only( left:10.0,top: 10.0,bottom: 10.0),
              decoration: new BoxDecoration(
                border: new Border(
                  bottom: new BorderSide(width: 0.0, color: const Color.fromRGBO(0, 0, 0, 0.2),style: BorderStyle.solid),
                ),
              ),
            ),
            new Column( children: children),
          ],
        ),
        padding: const EdgeInsets.only(top:10.0),
      ),
    );
  }
}

class memberlist extends StatelessWidget {
  String memberId;
  memberlist(this.memberId);

  @override
  Widget build(BuildContext context) =>
      new Container(
        child: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new CircleAvatar(
                  child:new Icon(Icons.person),
                  backgroundColor: const Color.fromRGBO(0, 0, 0, 0.2),
                ),
                new Container(child:
                new Text(
                  "Member ${memberId}",
                  style: new TextStyle(fontSize: 20.0),
                ),
                padding: new EdgeInsets.only( left:20.0)
                ),
              ],
            ),
          ],
        ),
        padding: new EdgeInsets.only( left:10.0,top: 5.0,bottom: 5.0),
        decoration: new BoxDecoration(
          border: new Border(
            bottom: new BorderSide(width: 0.0, color: const Color.fromRGBO(0, 0, 0, 0.2),),
          ),
        ),
      );
}







