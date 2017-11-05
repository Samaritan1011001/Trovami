
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'main.dart';
import 'Roundedbutton.dart';
import 'InputTextField.dart';
import 'signuppage.dart';

String loggedinuser;

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

TextStyle textStyle = new TextStyle(
    color: new Color.fromRGBO(255, 255, 255, 0.4),
    fontSize: 16.0,
    fontWeight: FontWeight.normal);

ThemeData appTheme = new ThemeData(
  hintColor: Colors.white,
);

Color textFieldColor = const Color.fromRGBO(0, 0, 0, 0.7);


class BaseLayout extends StatefulWidget {
  @override
  baselayoutstate createState() => new baselayoutstate();

}

class baselayoutstate extends State<BaseLayout>{

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      key: _scaffoldKey,
      body: new Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("graphics/staticmap.gif"),
            fit: BoxFit.cover,
            alignment: Alignment.topLeft,
          ),
        ),
        child:new SignInForm(),
      ),
    );
  }
}


class SignInForm extends StatefulWidget {

  @override
  signinformstate createState() => new signinformstate();
}



class signinformstate extends State<SignInForm>{

  final IconData mail = const IconData(0xe158, fontFamily: 'MaterialIcons');
  final IconData lock_outline = const IconData(0xe899, fontFamily: 'MaterialIcons');
  final IconData signinicon=const IconData(0xe315, fontFamily: 'MaterialIcons');
  final IconData signupicon=const IconData(0xe316, fontFamily: 'MaterialIcons');
  final googlesigin= const ImageIcon(const AssetImage("graphics/google_signin_buttons/android/hdpi/btn_google_dark_normal_hdpi.9.png"));
  bool _autovalidate = false;
  bool _formWasEdited = false;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey = new GlobalKey<FormFieldState<String>>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(value)
    ));
  }

   _handleSubmitted() async {
     final FormState form = _formKey.currentState;
     if (!form.validate()) {
        _autovalidate = true;  // Start validating on every change.
        showInSnackBar('Please fix the errors in red before submitting.');
     } else {
        form.save();
        var response=await httpClient.get("https://fir-trovami.firebaseio.com/users.json");
        Map usrmap=jsonCodec.decode(response.body);
        usrmap.forEach((k,v){
          if(logindet.EmailId==v.EmailId){
                      loggedinuser=logindet.EmailId;

            Navigator.of(context).pushReplacementNamed('/b');

          }
        });
        showInSnackBar(
              'Login EmailID or Password is incorrect. Please Try again.'
        );
     }
   }


  String _validateName(String value) {
    _formWasEdited = true;
    if (value.isEmpty)
      return 'EmailID is required.';
    final RegExp nameExp = new RegExp(r'^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$');
    if (!nameExp.hasMatch(value))
      return 'Please enter correct EmailID';
    return null;
  }

  String _validatePassword(String value) {
    _formWasEdited = true;
    final FormFieldState<String> passwordField = _passwordFieldKey.currentState;
    if (passwordField.value == null || passwordField.value.isEmpty)
      return 'Please choose a password.';
    if (passwordField.value != value)
      return 'Passwords don\'t match';
    return null;
  }




  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return new Container(child:
      new Form(
        key: _formKey,
        autovalidate: _autovalidate,
        child: new ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: <Widget>[
            new Container(
              child:
              new Text(
                "Trovami",
                textAlign: TextAlign.center,
                style: new TextStyle(fontSize: 50.0)
              ),

              padding: new EdgeInsets.only( bottom:50.0,top: 0.0),
            ),

            new Container(
              child: new InputField(
                  hintText: "Email",
                  obscureText: false,
                  textInputType: TextInputType.text,
                  textStyle: textStyle,
                  hintStyle: textStyle,
                  textFieldColor: textFieldColor,
                  icon: Icons.mail_outline,
                  iconColor: new Color.fromRGBO(255, 255, 255, 0.4),
                  bottomMargin: 20.0,
                  validateFunction: _validateName,
                  onSaved: (String email) {
                    logindet.EmailId = email;
                  }
              ),
              padding: new EdgeInsets.only( bottom:15.0, top:10.0 ),
            ),
            new InputField(
                hintText: "Password",
                obscureText: true,
                textInputType: TextInputType.text,
                textStyle: textStyle,
                hintStyle: textStyle,
                textFieldColor: textFieldColor,
                icon: Icons.lock_outline,
                iconColor: Colors.white,
                bottomMargin: 20.0,
                onSaved: (String pass) {
                  logindet.password = pass;
                }
            ),
            new RoundedButton(
              buttonName: "Sign-In",
              onTap: _handleSubmitted,
              width: screenSize.width,
              height: 50.0,
              bottomMargin: 10.0,
              borderWidth: 0.0,
              buttonColor: new Color.fromRGBO(100, 100, 100, 0.1),
            ),

            new RoundedButton(
              buttonName: "Sign-up",
              onTap: () {
                Navigator.of(context).pushNamed('/a');
              },
              highlightColor:new Color.fromRGBO(255, 255, 255, 0.9),
              width: screenSize.width,
              height: 50.0,
              bottomMargin: 10.0,
              borderWidth: 0.0,
              buttonColor: new Color.fromRGBO(100, 100, 100, 0.1),
            ),
            new RoundedButton(
              buttonName: "Google Sign-In",
              onTap: null,
              width: screenSize.width,
              height: 50.0,
              bottomMargin: 10.0,
              borderWidth: 0.0,
              buttonColor:new Color.fromRGBO(100, 100, 100, 0.1),
            ),
            new Container(
              padding: const EdgeInsets.only(top: 20.0),
              child: new Text('* indicates required field', style: Theme.of(context).textTheme.caption),
            ),
          ],
        ),

      ),
      padding: new EdgeInsets.only(top:100.0),
    );

  }
}