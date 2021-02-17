import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'groupdetails.dart';
import 'helpers/RoutesHelper.dart';
import 'core/Group.dart';
import 'signinpage.dart';

class UnitTests extends StatelessWidget {
  UnitTests();
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return new Container(
        child: new MainBody(),
        width: screenSize.width,
        height: screenSize.height,
      );
  }
}

class MainBody extends StatefulWidget{
  MainBody();

  @override
  MainBodyState createState() => new MainBodyState();
}

class MainBodyState extends State<MainBody> {
  MainBodyState();

  @override
  void initState(){

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
      leading: new Container(),
      actions: <Widget>[
        new IconButton(
          icon: new Icon(Icons.group_add),
          iconSize: 42.0,),
        new IconButton(
          icon: new Icon(Icons.person),
          iconSize: 35.0,),
      ],
        title: new Text('Unit Tests'),
      ),
      body: new Column(children: <Widget>[
        Text("Line 1"),
        Text("Line2"),
      ])
    );
  }
}



