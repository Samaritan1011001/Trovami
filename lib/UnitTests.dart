import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:trovami/managers/Groups2Manager.dart';
import 'helpers/CloudFirebaseHelper.dart';
import 'managers/ThemeManager.dart';

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

  bool _initialized = false;
  bool _errorInitializing = false;
  FirebaseResponse _response;
  
  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      Firebase.initializeApp().then ((FirebaseApp app) => {
        onFirebaseInitialized()
      });
    } catch(e) {
      setState(() {
        _errorInitializing = true;
      });
    }
  }

  void onFirebaseInitialized() async {
    _initialized = true;
    Groups2Manager().acquire()
        .then((FirebaseResponse response) => {
          setState((){_response = response;})
    });
  }

  @override
  void initState() {
    initializeFlutterFire();
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
    if (_errorInitializing) {
      return <Widget>[ Text("Failed to connect to Firebase", style: ThemeManager().getStyle(STYLE_NORMAL_BOLD))];
    } else if(!_initialized) {
      return <Widget>[ Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Fetching Groups...", style: ThemeManager().getStyle(STYLE_NORMAL_BOLD),),
      )];
    } else if ((_response != null) && !_response.hasError()){
        return Groups2Manager().getGroupWidgets(context);
    }
  }
}



