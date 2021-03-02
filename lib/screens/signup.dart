import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:trovami/helpers/RoutesHelper.dart';
import 'package:trovami/managers/UsersManager.dart';
import 'package:trovami/model/TrovUser.dart';
import 'package:trovami/widgets/Roundedbutton.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => new _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<ScaffoldState> _scaffoldKeySecondary =
      new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKeySeondary = new GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKeySecondary =
      new GlobalKey<FormFieldState<String>>();

  final TextEditingController _passwordTextController = TextEditingController();
  bool _formWasEdited = false;

  final IconData mail = const IconData(0xe158, fontFamily: 'MaterialIcons');
  final IconData lock_outline =
      const IconData(0xe899, fontFamily: 'MaterialIcons');
  final IconData signupicon =
      const IconData(0xe316, fontFamily: 'MaterialIcons');

  final TrovUser _user = TrovUser();
  void showInSnackBar(String value) {
    _scaffoldKeySecondary.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  _handleSubmitted1(UserManager userProvider) async {
    if (!_formKeySeondary.currentState.validate()) {
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      _formKeySeondary.currentState.save();
      await userProvider.signUp(
          _user, _passwordTextController.value.toString());
      RoutesHelper.pushRoute(context, '/login');
    }
  }

  String _validateName(String value) {
    _formWasEdited = true;
    if (value.isEmpty) return 'EmailID is required.';
    final RegExp nameExp = new RegExp(r'^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$');
    if (!nameExp.hasMatch(value)) return 'Please enter correct EmailID';
    return null;
  }

  String _validatePassword(String value) {
    _formWasEdited = true;
    final FormFieldState<String> passwordField1 =
        _passwordFieldKeySecondary.currentState;
    if (passwordField1.value == null || passwordField1.value.isEmpty)
      return 'Please choose a password.';
    if (passwordField1.value != value) return 'Passwords don\'t match';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        automaticallyImplyLeading: false,
      ),
      key: _scaffoldKeySecondary,
      body: new Form(
        key: _formKeySeondary,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: new ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: <Widget>[
            new Container(
              child: new TextFormField(
                decoration: new InputDecoration(
                  hintText: 'Name',
                  labelText: 'Name',
                  icon: new Icon(Icons.person),
                  // labelStyle: textStyle,
                ),
                onSaved: (String value) {
                  _user.name = value;
                },
              ),
              padding:
                  const EdgeInsets.only(bottom: 15.0, top: 0.0, right: 20.0),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10.0, left: 30),
              child: Text(
                "PLEASE DO NOT ENTER YOUR REAL EMAIL ADDRESS. APP IS PUBLIC.",
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
            new Container(
              child: new TextFormField(
                decoration: new InputDecoration(
                  icon: new Icon(mail),
                  hintText: 'EmailID',
                  labelText: 'EmailID',
                ),
                onSaved: (String value) {
                  _user.email = value;
                },
                validator: _validateName,
              ),
              padding: const EdgeInsets.only(top: 10.0),
            ),
            new Container(
              child: new Container(
                child: new TextFormField(
                  key: _passwordFieldKeySecondary,
                  decoration: new InputDecoration(
                    hintText: 'Type your password here',
                    labelText: 'Password *',
                    icon: new Icon(lock_outline),
                  ),
                  obscureText: true,
                ),
                padding:
                    const EdgeInsets.only(bottom: 15.0, top: 0.0, right: 20.0),
              ),
              padding: const EdgeInsets.only(top: 10.0),
            ),
            new Container(
              child: new Container(
                child: new TextFormField(
                  controller: _passwordTextController,
                  decoration: new InputDecoration(
                    hintText: 'Repeat Password',
                    labelText: 'Retype-Password *',
                    icon: new Icon(lock_outline),
                  ),
                  obscureText: true,
                  validator: _validatePassword,
                ),
                padding:
                    const EdgeInsets.only(bottom: 15.0, top: 0.0, right: 20.0),
              ),
              padding: const EdgeInsets.only(top: 10.0),
            ),
            Consumer<UserManager>(builder: (context, userProvider, child) {
              return RoundedButton(
                buttonName: 'Sign-up',
                onTap: () => _handleSubmitted1(userProvider),
                // width: screenSize.width,
                height: 50.0,
                bottomMargin: 10.0,
                borderWidth: 0.0,
                buttonColor: Colors.transparent,
              );
            }),
            new Container(
              padding: const EdgeInsets.only(top: 20.0),
              child: new Text('* indicates required field',
                  style: Theme.of(context).textTheme.caption),
            ),
          ],
        ),
      ),
      // backgroundColor: const Color.fromRGBO(0, 0, 0, 0.7),
    );
  }
}
