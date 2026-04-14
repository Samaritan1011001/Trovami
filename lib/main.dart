import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:trovami/model/userModel.dart';

import 'Strings.dart';
import 'helpers/RoutesHelper.dart';
import 'signinpage.dart';

final ThemeData kIOSTheme = ThemeData(
  primarySwatch: Colors.blueGrey,
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey)
      .copyWith(secondary: Colors.blueGrey),
);

final ThemeData kDefaultTheme = ThemeData(
  primarySwatch: Colors.blueGrey,
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey)
      .copyWith(secondary: Colors.blueGrey),
);

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserModel(),
      child: MaterialApp(
        title: Strings.appName,
        debugShowCheckedModeBanner: false,
        home: SignInForm(),
        theme: defaultTargetPlatform == TargetPlatform.iOS
            ? kIOSTheme
            : kDefaultTheme,
        onGenerateRoute: RoutesHelper.provideRoute,
        initialRoute: ROUTE_HOME,
      ),
    ),
  );
}

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({required WidgetBuilder builder, required RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(opacity: animation, child: child);
  }
}

class MyCustomRoute1<T> extends MaterialPageRoute<T> {
  MyCustomRoute1({required WidgetBuilder builder, required RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(animation),
        child: child);
  }
}
