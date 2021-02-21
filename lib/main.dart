import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:trovami/screens/SplashScreen.dart';

import 'Strings.dart';
import 'helpers/RoutesHelper.dart';
import 'model/userModel.dart';

// TODO: Do login credentials need to be saved?
//logindetails logindet = new logindetails();

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.blueGrey,
  accentColor: Colors.blueGrey,
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.blueGrey,
  accentColor: Colors.blueGrey,
);

void main() {
//  defaultTargetPlatform == TargetPlatform.iOS
//      ? MapView.setApiKey("AIzaSyCLw1SjRi8TLDu_Nzcdo2Ufu68H1UXl9BU")
//      : MapView.setApiKey("AIzaSyB4xaxweIhP0F36ZCBpfeiDjpoPc741Oe0");

  runApp(
    ChangeNotifierProvider(
      create: (context) => UserModel(), // TODO: Placeholder for ChangeNotifierProvider, UserModel not used
      child: new MaterialApp(
        title: Strings.appName,
        debugShowCheckedModeBanner: false,
        home: new SplashScreen(),
        theme: defaultTargetPlatform == TargetPlatform.iOS
            ? kIOSTheme
            : kDefaultTheme,
        // ignore: missing_return
        onGenerateRoute: RoutesHelper.provideRoute,
        initialRoute: ROUTE_GROUPS,
      ),
    ),
  );
}

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // if (settings.isInitialRoute)
    //   return child;
    return new FadeTransition(opacity: animation, child: child);
  }
}

class MyCustomRoute1<T> extends MaterialPageRoute<T> {
  MyCustomRoute1({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget TransitionBuilder(BuildContext context, Animation<Offset> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // if (settings.isInitialRoute)
    //   return child;
    return new SlideTransition(position: animation, child: child);
  }
}
