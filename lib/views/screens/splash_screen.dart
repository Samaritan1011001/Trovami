import 'package:flutter/material.dart';
import 'package:trovami/helpers/Strings.dart';
import 'package:trovami/helpers/RoutesHelper.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: Key('splash_screen'));
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      RoutesHelper.pushRoute(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              "assets/back.jpg",
              fit: BoxFit.fitHeight,
            ),
          ),
          Center(
            child: Text(
              Strings.appName,
              textAlign: TextAlign.center,
              style: new TextStyle(fontSize: 50.0),
            ),
          ),
        ],
      ),
    );
  }
}
