import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../managers/ThemeManager.dart';

class UnitTestsScreen extends StatelessWidget {
  UnitTestsScreen();
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
      leading: new Container(),
      // actions: <Widget>[
      //   new IconButton(
      //     icon: new Icon(Icons.group_add),
      //     iconSize: 42.0,),
      //   new IconButton(
      //     icon: new Icon(Icons.person),
      //     iconSize: 35.0,),
      // ],
        title: new Text('Unit Tests'),
      ),
      body: new Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text("Groups",
            style: ThemeManager().getStyle(STYLE_TITLE),),
        ),
        Expanded(
          flex: 3,
          child:
          SingleChildScrollView(
            child: Column(
                children: _body(),
                ),
            ),
          ),
      ])
    );
  }

  _body() {
      return <Widget>[ Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("No Current Tests", style: ThemeManager().getStyle(STYLE_NORMAL_BOLD),),
      )];
  }
}



