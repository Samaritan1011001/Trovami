import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../groupdetails.dart';
import '../groupstatus.dart';
import '../homepage.dart';
import '../main.dart';
import '../map.dart';
import '../signuppage.dart';

const String ROUTE_ADD_GROUP = '/addgroup';
const String ROUTE_GROUP = '/group';
const String ROUTE_HOME = '/';
const String ROUTE_MAP = '/map';
const String ROUTE_SIGNUP = '/signup';

class RoutesHelper {
  static Route<dynamic> provideRoute(RouteSettings settings) {
    switch (settings.name) {
      case ROUTE_HOME:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (_) => const Homepagelayout(),
                settings: settings,
              )
            : MyCustomRoute(
                builder: (_) => const Homepagelayout(),
                settings: settings,
              );

      case ROUTE_SIGNUP:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (_) => SignupLayout(),
                settings: settings,
              )
            : MyCustomRoute(
                builder: (_) => SignupLayout(),
                settings: settings,
              );

      case ROUTE_ADD_GROUP:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (_) => const AddGroup(),
                settings: settings,
              )
            : MyCustomRoute1(
                builder: (_) => const AddGroup(),
                settings: settings,
              );
      case ROUTE_GROUP:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (_) => GroupStatusLayout(),
                settings: settings,
              )
            : MyCustomRoute1(
                builder: (_) => GroupStatusLayout(),
                settings: settings,
              );
      case ROUTE_MAP:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (_) => MapSample(),
                settings: settings,
              )
            : MyCustomRoute1(
                builder: (_) => MapSample(),
                settings: settings,
              );
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text(
                          'No route defined for ${settings.name}')),
                ));
    }
  }

  static pushRoute(BuildContext context, String name) {
    Navigator.pushNamed(context, name);
  }
}
