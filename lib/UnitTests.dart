import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:trovami/managers/Groups2Manager.dart';
import 'helpers/CloudFirebaseHelper.dart';
import 'managers/ThemeManager.dart';

class UnitTests extends StatelessWidget {
  UnitTests({super.key});
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Container(
      child: MainBody(),
      width: screenSize.width,
      height: screenSize.height,
    );
  }
}

class MainBody extends StatefulWidget {
  MainBody({super.key});

  @override
  MainBodyState createState() => MainBodyState();
}

class MainBodyState extends State<MainBody> {
  MainBodyState();

  bool _initialized = false;
  bool _errorInitializing = false;
  FirebaseResponse? _response;

  void initializeFlutterFire() async {
    try {
      Firebase.initializeApp().then((FirebaseApp app) => {
            onFirebaseInitialized()
          });
    } catch (e) {
      setState(() {
        _errorInitializing = true;
      });
    }
  }

  void onFirebaseInitialized() async {
    _initialized = true;
    Groups2Manager()
        .acquire()
        .then((FirebaseResponse response) => {
              setState(() {
                _response = response;
              })
            });
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Container(),
          title: const Text('Unit Tests'),
        ),
        body: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "Groups",
              style: ThemeManager().getStyle(STYLE_TITLE),
            ),
          ),
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: Column(
                children: _body(),
              ),
            ),
          ),
        ]));
  }

  List<Widget> _body() {
    if (_errorInitializing) {
      return <Widget>[
        Text("Failed to connect to Firebase",
            style: ThemeManager().getStyle(STYLE_NORMAL_BOLD))
      ];
    } else if (!_initialized) {
      return <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Fetching Groups...",
            style: ThemeManager().getStyle(STYLE_NORMAL_BOLD),
          ),
        )
      ];
    } else if (_response != null && !_response!.hasError()) {
      return Groups2Manager().getGroupWidgets(context);
    }
    return <Widget>[];
  }
}
