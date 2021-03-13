import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trovami/Strings.dart';
import 'package:trovami/helpers/CloudFirebaseHelper.dart';
import 'package:trovami/helpers/RoutesHelper.dart';
import 'package:trovami/managers/AuthManager.dart';
import 'package:trovami/managers/UsersManager.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: Key('splash_screen'));
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<bool> _intializeConfigurations() async {
    final initResponse =
        await CloudFirebaseHelper().assureFireBaseInitialized();
    return !initResponse.hasError();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthManager>(context).onAuthStateChanged.listen((event) {
      if (event == null) {
        Future.delayed(Duration(seconds: 2), () {
          RoutesHelper.pushRoute(context, '/signup');
        });
      } else {
        Future.delayed(Duration(seconds: 2), () {
          RoutesHelper.pushRoute(context, '/map');
        });
      }
    }, onError: (error) {
      Future.delayed(Duration(seconds: 2), () {
        RoutesHelper.pushRoute(context, '/signup');
      });
    });
    return FutureBuilder<bool>(
        future: _intializeConfigurations(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            Provider.of<AuthManager>(context).onAuthStateChanged.listen(
                (event) {
              if (event == null) {
                Future.delayed(Duration(seconds: 2), () {
                  RoutesHelper.pushRoute(context, '/signup');
                });
              } else {
                Future.delayed(Duration(seconds: 2), () {
                  RoutesHelper.pushRoute(context, '/map');
                });
              }
            }, onError: (error) {
              Future.delayed(Duration(seconds: 2), () {
                RoutesHelper.pushRoute(context, '/signup');
              });
            });
          }
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
        });
  }
}
