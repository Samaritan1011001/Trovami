
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'main.dart';
import 'dart:async';
import 'Roundedbutton.dart';
import 'InputTextField.dart';
// new


TextStyle textStyle = const TextStyle(
    color: const Color(0XFFFFFFFF),
    fontSize: 16.0,
    fontWeight: FontWeight.normal);

ThemeData appTheme = new ThemeData(
  hintColor: Colors.white,
);

Color textFieldColor = const Color.fromRGBO(255, 255, 255, 0.1);


class BaseLayout extends StatefulWidget {
  @override
  baselayoutstate createState() => new baselayoutstate();

}
class baselayoutstate extends State<BaseLayout>{

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      body: new Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("graphics/backoption2.jpg"),
            fit: BoxFit.cover,
            alignment: Alignment.centerRight,
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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //PersonData person = new PersonData();


  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(value)
    ));
  }
  bool _autovalidate = false;
  bool _formWasEdited = false;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey = new GlobalKey<FormFieldState<String>>();





  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true;  // Start validating on every change.
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      var flag=0;
      for(var i=0;i<users.length;i++) {
        if (logindet.EmailId == users[i].EmailId &&
            logindet.password == users[i].password) {
          flag=1;
          Navigator.of(context).pushNamed('/b');
          //print(person.password);
          //showInSnackBar('${person.name}\'s phone number is ${person.phoneNumber}');
        }
      }if(flag==0) {
        showInSnackBar(
            'Login EmailID or Password is incorrect. Please Try again.');
      }
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

  final IconData mail = const IconData(0xe158, fontFamily: 'MaterialIcons');
  final IconData lock_outline = const IconData(0xe899, fontFamily: 'MaterialIcons');
  final IconData signinicon=const IconData(0xe315, fontFamily: 'MaterialIcons');
  final IconData signupicon=const IconData(0xe316, fontFamily: 'MaterialIcons');


  @override
  Widget build(BuildContext context) {
    print(1);
    final Size screenSize = MediaQuery.of(context).size;

    return new Container(child:new Form(
      key: _formKey,
      autovalidate: _autovalidate,
      child: new ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: <Widget>[
          new Container(
            child: new Text(
              "Trovami",
              textAlign: TextAlign.center,
              style: new TextStyle(fontFamily:'Nexa',fontSize: 50.0)
            ),

            padding: new EdgeInsets.only( bottom:50.0,top: 0.0),
          ),

          new Container(
            child: new InputField(
                //icon: Icons.person,
                hintText: "Email",
                obscureText: false,
                textInputType: TextInputType.text,
                textStyle: textStyle,
                textFieldColor: textFieldColor,
                icon: Icons.mail_outline,
                iconColor: Colors.white,
                bottomMargin: 20.0,
                validateFunction: _validateName,
                onSaved: (String email) {
                  logindet.EmailId = email;
                }),
//            new TextFormField(
//              decoration: const InputDecoration(
//                icon: const Icon(Icons.person),
//                hintText: 'EmailID',
//                labelText: 'EmailID',
//                isDense: true,
//              ),
//              onSaved: (String value) { logindet.EmailId = value; },
//              validator: _validateName,
//            ),
//            decoration: new BoxDecoration(borderRadius: new BorderRadius.circular(100.0),border: new Border.all(
//              color: Colors.black,
//              width: 1.0,
//            ),),
            padding: new EdgeInsets.only( bottom:15.0, top:10.0,right: 20.0 ),
          ),
           new InputField(
                //icon: Icons.person,
                //key: _passwordFieldKey,
                  hintText: "Password",
                  obscureText: true,
                  textInputType: TextInputType.text,
                  textStyle: textStyle,
                  textFieldColor: textFieldColor,
                  icon: Icons.lock_outline,
                  iconColor: Colors.white,
                  bottomMargin: 20.0,
                  //validateFunction: _validateName,
                  onSaved: (String pass) {
                    logindet.password = pass;
                  }),
//             new TextFormField(
//              key: _passwordFieldKey,
//              decoration: new InputDecoration(
//                hintText: 'Type your password here',
//                labelText: 'Password *',
//                icon: new Icon(lock_outline),
//                //labelStyle: new TextStyle(color: Colors.black,inherit: false),
//                //hintStyle: new TextStyle(fontWeight: FontWeight.bold,color: Colors.black,inherit: false),
//              ),
//              obscureText: true,
//              onSaved: (String value) { logindet.password = value; },
//              //style: new TextStyle(color: Colors.black),
//            ),
//            decoration: new BoxDecoration(borderRadius: new BorderRadius.circular(100.0),border: new Border.all(
//              color: Colors.black,
//              width: 1.0,
//            ),),
            //padding: new EdgeInsets.only( bottom:15.0, top:0.0,right: 20.0 ),

            //padding: new EdgeInsets.only(top:10.0),

          //const SizedBox(width: 16.0),

          new RoundedButton(
                buttonName: "Sign-In",
                onTap: _handleSubmitted,
                width: screenSize.width,
                height: 50.0,
                bottomMargin: 10.0,
                borderWidth: 0.0,
                buttonColor: Colors.transparent,
              ),
//             new RaisedButton(
//              disabledColor: new Color.fromRGBO(245, 245, 245,0.0),
//              //color: Colors.brown,
//              //highlightColor: Colors.brown,
//              color: Colors.brown[400],
//              splashColor: Colors.brown,
//              elevation: 150.0,
//              onPressed: _handleSubmitted,
//                child: new Text("Sign In"),
//
//            ),

          new RoundedButton(
              buttonName: "Sign-up",
              onTap: () {
                Navigator.of(context).pushNamed('/a');
              },
              width: screenSize.width,
              height: 50.0,
              bottomMargin: 10.0,
              borderWidth: 0.0,
              buttonColor: Colors.transparent,
            ),
//            new RaisedButton(
//                //child: const Text('Sign-up'),
//                child: new Text("Sign up"),
//                //disabledColor: Colors.brown[200],
//                color: Colors.brown[200],
//                highlightColor: Colors.brown,
//                splashColor: Colors.brown,
//                elevation: 150.0,
//                onPressed:() {
//                  Navigator.of(context).pushNamed('/a');
//                }
//            ),

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