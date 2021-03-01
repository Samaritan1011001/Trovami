import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trovami/Strings.dart';
import 'package:trovami/helpers/RoutesHelper.dart';
import 'package:trovami/managers/ProfileManager.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 5), () {
      RoutesHelper.replaceRoute(context, ROUTE_LOGIN);
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ProfileManager>(context, listen: false).load("trovami@kleymeyer.com");

    return Material(
      child: Stack(
        children: [
          Container(
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                "assets/back.jpg",
                fit: BoxFit.fitHeight,
              )),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25,
            left: MediaQuery.of(context).size.width * 0.25,
            child: Text(
              Strings.appName,
              textAlign: TextAlign.center,
              style: new TextStyle(fontSize: 64.0, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
