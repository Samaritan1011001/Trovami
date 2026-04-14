import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:trovami/httpClient/httpClient.dart';
import 'package:trovami/model/userModel.dart';

import 'Roundedbutton.dart';
import 'functionsForFirebaseApiCalls.dart';
import 'managers/UsersManager.dart';
import 'core/OldUser.dart';

bool userexists = false;
OldUser user1 = OldUser();
const jsonCodec = JsonCodec(reviver: _reviver);

_reviver(key, value) {
  if (key != null && value is Map && key.contains('-')) {
    return OldUser.fromJson(value);
  }
  return value;
}

TextStyle textStyle = const TextStyle(
    color: Color.fromRGBO(255, 255, 255, 0.4),
    fontSize: 16.0,
    fontWeight: FontWeight.bold);

class SignupLayout extends StatefulWidget {
  @override
  SignupLayoutState createState() => SignupLayoutState();
}

class SignupLayoutState extends State<SignupLayout> {
  @override
  Widget build(BuildContext context) =>
      defaultTargetPlatform == TargetPlatform.iOS
          ? CupertinoPageScaffold(child: Signup())
          : Scaffold(
              body: Container(
                child: Signup(),
              ),
            );
}

class Signup extends StatefulWidget {
  @override
  SignupState createState() => SignupState();
}

class SignupState extends State<Signup> {
  final GlobalKey<ScaffoldState> _scaffoldKeySecondary =
      GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKeySeondary = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKeySecondary =
      GlobalKey<FormFieldState<String>>();

  bool _autovalidate1 = false;
  // ignore: unused_field
  bool _formWasEdited = false;

  final IconData mail =
      const IconData(0xe158, fontFamily: 'MaterialIcons');
  final IconData lock_outline =
      const IconData(0xe899, fontFamily: 'MaterialIcons');
  final IconData signupicon =
      const IconData(0xe316, fontFamily: 'MaterialIcons');

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(value)));
  }

  // ignore: unused_element
  _handleSubmitted1() async {
    final FormState? form = _formKeySeondary.currentState;
    if (form == null) return;
    if (!form.validate()) {
      _autovalidate1 = true;
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      user1.location = null;
      user1.locationShare = false;
      user1.groupsIamin = [];
      UsersManager()
          .users
          .putIfAbsent(user1.EmailId ?? '', () => user1);
      var userjson = jsonCodec.encode(user1);
      final DataSnapshot usrmap = await getUsers();
      Map usrs = usrmap.value as Map;

      usrs.values.forEach((x) {
        if (x["emailid"] == user1.EmailId) {
          userexists = true;
        }
      });
      if (userexists == false) {
        HttpClientFireBase httpClient = HttpClientFireBase();

        await httpClient.post(
            url: 'https://trovami-bcd81.firebaseio.com/users.json',
            body: userjson);
      } else {
        showInSnackBar('User already exits');
      }
      Navigator.of(context).pop();
    }
  }

  String? _validateName(String? value) {
    _formWasEdited = true;
    if (value == null || value.isEmpty) return 'EmailID is required.';
    final RegExp nameExp =
        RegExp(r'^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$');
    if (!nameExp.hasMatch(value)) return 'Please enter correct EmailID';
    return null;
  }

  String? _validatePassword(String? value) {
    _formWasEdited = true;
    final FormFieldState<String>? passwordField1 =
        _passwordFieldKeySecondary.currentState;
    if (passwordField1?.value == null ||
        (passwordField1?.value?.isEmpty ?? true)) {
      return 'Please choose a password.';
    }
    if (passwordField1?.value != value) return 'Passwords don\'t match';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKeySecondary,
      body: Container(
        child: Form(
          key: _formKeySeondary,
          autovalidateMode: _autovalidate1
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              Container(
                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: 'Name',
                      labelText: 'Name',
                      icon: const Icon(Icons.person),
                      labelStyle: textStyle),
                  onSaved: (String? value) {
                    user1.name = value;
                  },
                ),
                padding: const EdgeInsets.only(
                    bottom: 15.0, top: 0.0, right: 20.0),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10.0, left: 30),
                child: const Text(
                  "PLEASE DO NOT ENTER YOUR REAL EMAIL ADDRESS. APP IS PUBLIC.",
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
              Container(
                child: TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(mail),
                    hintText: 'EmailID',
                    labelText: 'EmailID',
                  ),
                  onSaved: (String? value) {
                    user1.EmailId = value;
                  },
                  validator: _validateName,
                ),
                padding: const EdgeInsets.only(top: 10.0),
              ),
              Container(
                child: Container(
                  child: TextFormField(
                    key: _passwordFieldKeySecondary,
                    decoration: InputDecoration(
                      hintText: 'Type your password here',
                      labelText: 'Password *',
                      icon: Icon(lock_outline),
                    ),
                    obscureText: true,
                    onSaved: (String? value) {
                      user1.password = value;
                    },
                  ),
                  padding: const EdgeInsets.only(
                      bottom: 15.0, top: 0.0, right: 20.0),
                ),
                padding: const EdgeInsets.only(top: 10.0),
              ),
              Container(
                child: Container(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Repeat Password',
                      labelText: 'Retype-Password *',
                      icon: Icon(lock_outline),
                    ),
                    obscureText: true,
                    validator: _validatePassword,
                  ),
                  padding: const EdgeInsets.only(
                      bottom: 15.0, top: 0.0, right: 20.0),
                ),
                padding: const EdgeInsets.only(top: 10.0),
              ),
              Consumer<UserModel>(builder: (context, user, child) {
                return RoundedButton(
                  buttonName: 'Sign-up',
                  onTap: () {
                    user.signUp(user1);
                  },
                  width: screenSize.width,
                  height: 50.0,
                  bottomMargin: 10.0,
                  borderWidth: 0.0,
                  buttonColor: Colors.transparent,
                );
              }),
              Container(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text('* indicates required field',
                    style: Theme.of(context).textTheme.bodySmall),
              ),
            ],
          ),
        ),
        padding: const EdgeInsets.only(top: 50.0),
      ),
      backgroundColor: const Color.fromRGBO(0, 0, 0, 0.7),
    );
  }
}
