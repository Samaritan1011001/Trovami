
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../AddGroup.dart';
import '../GroupDetails.dart';
import '../GroupsScreen.dart';
import '../main.dart';
import '../map.dart';
import '../signuppage.dart';

const String ROUTE_ADD_GROUP      = '/addgroup';
const String ROUTE_GROUP_DETAILS  = '/groupdetails';
const String ROUTE_GROUPS           = '/';
const String ROUTE_MAP            = '/map';
const String ROUTE_SIGNUP         = '/signup';

class RoutesHelper {
  static Route<dynamic> provideRoute(RouteSettings settings) {
    switch (settings.name) {
      case ROUTE_GROUPS:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? new CupertinoPageRoute(builder:  (_) => new GroupsScreen(),settings: settings,)
            : new MyCustomRoute(
          builder: (_) => new GroupsScreen(),
          settings: settings,
        );

      case ROUTE_SIGNUP: return defaultTargetPlatform == TargetPlatform.iOS
          ? new CupertinoPageRoute(builder:  (_) => new SignupLayout(),settings: settings,)
          : new MyCustomRoute(
        builder: (_) => new SignupLayout(),
        settings: settings,
      );

      case ROUTE_ADD_GROUP: return defaultTargetPlatform == TargetPlatform.iOS
          ? new CupertinoPageRoute(builder:  (_) => new AddGroup(),settings: settings,)
          :new MyCustomRoute1(
        builder: (_) => new AddGroup(),
        settings: settings,
      );
      case ROUTE_GROUP_DETAILS: return defaultTargetPlatform == TargetPlatform.iOS
          ? new CupertinoPageRoute(builder:  (_) => new GroupDetails(),settings: settings,)
          :new MyCustomRoute1(
        builder: (_) => new GroupDetails(),
        settings: settings,
      );
      case ROUTE_MAP: return defaultTargetPlatform == TargetPlatform.iOS
          ? new CupertinoPageRoute(builder:  (_) => new MapSample(),settings: settings,)
          :new MyCustomRoute1(
        builder: (_) => new MapSample(),
        settings: settings,
      );
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center( child: Text('No route defined for ${settings.name}')),
            )
        );
    }
  }

  static pushRoute(BuildContext context, String name) {
    Navigator.pushNamed(context, name);
  }
}