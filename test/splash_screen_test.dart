import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trovami/Strings.dart';
import 'package:trovami/helpers/RoutesHelper.dart';
import 'package:trovami/screens/SplashScreen.dart';

void main() {
  // testWidgets(
  //     'Shows splash screen for a few seconds and Navigates to Log in page',
  //     (WidgetTester tester) async {
  //   await tester.pumpWidget(
  //     new MaterialApp(
  //       title: Strings.appName,
  //       debugShowCheckedModeBanner: false,
  //       home: SplashScreen(),
  //       onGenerateRoute: RoutesHelper.provideRoute,
  //       initialRoute: ROUTE_GROUPS,
  //     ),
  //   );
  //   expect(find.byKey(Key('splash_screen')), findsOneWidget);
  //   await tester.pumpAndSettle(Duration(seconds: 4));
  //   expect(find.byKey(Key('sign_in_form')), findsOneWidget);
  // });
}
