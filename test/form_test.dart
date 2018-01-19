//import 'package:flutter_test/flutter_test.dart';
//import 'package:flutter/material.dart';
//import 'package:locate_pal/InputTextField.dart';
//
//void main() {
//  testWidgets('onSaved callback is called', (WidgetTester tester) async {
//    final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
//    String fieldValue;
//    String fieldValue1;
//
//    Widget builder() {
//      return new Directionality(
//        textDirection: TextDirection.ltr,
//        child: new Center(
//          child: new Material(
//            child: new Form(
//              key: formKey,
////              autovalidate: _autovalidate,
//              child:
//                  new Container(
//                    child: new InputField(
//                        hintText: 'Email',
//                        obscureText: false,
//                        textInputType: TextInputType.text,
////                        textStyle: textStyle,
////                        hintStyle: textStyle,
////                        textFieldColor: textFieldColor,
//                        icon: Icons.mail_outline,
//                        iconColor: const Color.fromRGBO(255, 255, 255, 0.4),
//                        bottomMargin: 20.0,
////                        validateFunction: _validateName,
//                        onSaved: (String value) {
//                          fieldValue = value;
//                        }
//                    ),
//                  ),
//          ),
//        ),
//      ),
//      );
//    }
//
//    await tester.pumpWidget(builder());
//
//    expect(fieldValue, isNull);
//
//    Future<Null> checkText(String testValue) async {
//      await tester.enterText(find.byType(InputField), testValue);
//      formKey.currentState.save();
//      // pump'ing is unnecessary because callback happens regardless of frames
//      expect(fieldValue, equals(testValue));
//
//    }
//    await checkText('Test');
//    await checkText('');
//  });
//
//}
