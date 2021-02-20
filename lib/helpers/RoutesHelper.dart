import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trovami/screens/SignInScreen.dart';

import '../screens/AddGroupScreen.dart';
import '../screens/GroupDetailsScreen.dart';
import '../screens/GroupsScreen.dart';
import '../main.dart';
import '../screens/HomeScreen.dart';
import '../screens/SignupScreen.dart';

const String ROUTE_ADD_GROUP = '/addgroup';
const String ROUTE_GROUP_DETAILS = '/groupdetails';
const String ROUTE_GROUPS = '/';
const String ROUTE_MAP = '/map';
const String ROUTE_SIGNUP = '/signup';
const String ROUTE_LOGIN = '/login';

class RoutesHelper {
  static Route<dynamic> provideRoute(RouteSettings settings) {
    switch (settings.name) {
      case ROUTE_GROUPS:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? new CupertinoPageRoute(
                builder: (_) => new GroupsScreen(),
                settings: settings,
              )
            : new MyCustomRoute(
                builder: (_) => new GroupsScreen(),
                settings: settings,
              );

      case ROUTE_SIGNUP:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? new CupertinoPageRoute(
                builder: (_) => new SignupScreen(),
                settings: settings,
              )
            : new MyCustomRoute(
                builder: (_) => new SignupScreen(),
                settings: settings,
              );

      case ROUTE_ADD_GROUP:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? new CupertinoPageRoute(
                builder: (_) => new AddGroupScreen(),
                settings: settings,
              )
            : new MyCustomRoute1(
                builder: (_) => new AddGroupScreen(),
                settings: settings,
              );
      case ROUTE_GROUP_DETAILS:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? new CupertinoPageRoute(
                builder: (_) => new GroupDetailsScreen(),
                settings: settings,
              )
            : new MyCustomRoute1(
                builder: (_) => new GroupDetailsScreen(),
                settings: settings,
              );
      case ROUTE_MAP:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? new CupertinoPageRoute(
                builder: (_) => new HomeScreen(),
                settings: settings,
              )
            : new MyCustomRoute1(
                builder: (_) => new HomeScreen(),
                settings: settings,
              );
      case ROUTE_LOGIN:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? new CupertinoPageRoute(
                builder: (_) => new SignInScreen(),
                settings: settings,
              )
            : new MyCustomRoute(
                builder: (_) => new SignInScreen(),
                settings: settings,
              );
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }

  static pushRoute(BuildContext context, String name) {
    Navigator.pushNamed(context, name);
  }
}
