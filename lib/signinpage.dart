import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:trovami/helpers/RoutesHelper.dart';
import 'package:trovami/httpClient/httpClient.dart';
//import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'InputTextField.dart';
import 'Roundedbutton.dart';
import 'Strings.dart';
import 'main.dart';
import 'core/OldUser.dart';
import 'signuppage.dart';
import 'homepage.dart';
import 'functionsForFirebaseApiCalls.dart';

final googleSignIn = new GoogleSignIn();
String loggedinUser;
var loggedInUsername;
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

final FirebaseAuth _auth = FirebaseAuth.instance;

TextStyle textStyle = new TextStyle(
    color: const Color.fromRGBO(255, 255, 255, 0.4),
    fontSize: 16.0,
    fontWeight: FontWeight.normal);

Color textFieldColor = const Color.fromRGBO(0, 0, 0, 0.7);
ScrollController scrollController = new ScrollController();

//const _jsonCodec=const JsonCodec(reviver: _reviver);

//_reviver( key, value) {
////  print("outside if key : ${key}, value : ${value}");
//
//  if(key!=null&& value is Map && key.contains('-')){
////    print("inside if value : ${value}");
//    return new User.fromJson(value);
//  }
//  return value;
//}

class SignInForm extends StatefulWidget {
  @override
  SigninFormState createState() => new SigninFormState();
}

// ignore: mixin_inherits_from_not_object
class SigninFormState extends State<SignInForm>
    with SingleTickerProviderStateMixin {
  bool _isgooglesigincomplete = true;
  bool _first = true;
//  var httpClient = HttpClientFireBase();

  final IconData mail = const IconData(0xe158, fontFamily: 'MaterialIcons');
  final IconData lock_outline =
      const IconData(0xe899, fontFamily: 'MaterialIcons');
  final IconData signinicon =
      const IconData(0xe315, fontFamily: 'MaterialIcons');
  final IconData signupicon =
      const IconData(0xe316, fontFamily: 'MaterialIcons');
  bool _autovalidate = false;
  bool _formWasEdited = false;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      new GlobalKey<FormFieldState<String>>();
  Animation<Color> animation;
  AnimationController controller;

  String email = '';
  String password = '';

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

//  _ensureLoggedIn() async {
//    GoogleSignInAccount user = googleSignIn.currentUser;
//      user ??= await googleSignIn.signInSilently();
//    if (user == null) {
//      await googleSignIn.signIn();
//    }
//  }
  _handleSubmitted1() async {
    setState(() {
      _isgooglesigincomplete = false;
    });
    try {
//      print("inside handlesub");

      _authenticateWithGoogle();
    } catch (error) {
//      print(error);
    }
  }

  _authenticateWithGoogle() async {
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    User firebaseUser =
        (await _auth.signInWithCredential(credential)).user;
    GoogleSignInAccount user;
    setState(() {
      user = googleUser;
    });

    if (user != null) {
//      print("inside listener");

      OldUser guser = new OldUser();
      guser.EmailId = user.email;
      guser.name = user.displayName;
      guser.locationShare = false;

      final String guserjson = jsonCodec.encode(guser);

      final DataSnapshot response = await getUsers();

//      print("docs: ${response}");

      if (response.value != null) {
        response.value.forEach((k, v) {
          if (v["emailid"] == user.email) {
            userexists = true;
            loggedinUser = user.email;
            loggedInUsername = user.displayName;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Homepagelayout(users: response),
              ),
            );
          }
        });
      }
      if (userexists == false) {
        HttpClientFireBase httpClient = HttpClientFireBase();

        await httpClient.post(
            url: 'https://trovami-bcd81.firebaseio.com/users.json',
            body: guserjson);
        loggedinUser = user.email;
        loggedInUsername = user.displayName;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Homepagelayout(users: response),
          ),
        );
      } else {
        setState(() {
          _isgooglesigincomplete = true;
        });
      }

    }

  }

  _handleSubmitted() async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true;
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      final DataSnapshot usrmap = await getUsers();
      Map usrs = usrmap.value as Map;

      usrs.values.forEach((us) async {
        if (email == us["emailid"]) {
          loggedinUser = email;
          loggedInUsername = us["name"];
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Homepagelayout(users: usrmap),
            ),
          );
        }
      });
      showInSnackBar(
          'Login EmailID or Password is incorrect. Please Try again.');
    }
  }

  String _validateName(String value) {
    _formWasEdited = true;
    if (value.isEmpty) return 'EmailID is required.';
    final nameExp = new RegExp(r'^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$');
    if (!nameExp.hasMatch(value)) return 'Please enter correct EmailID';
    return null;
  }

  setGoogleSigninListener() {
    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount account) async {
    });
    _googleSignIn.signInSilently();
  }

  @override
  void initState() {
    setGoogleSigninListener();

    controller = new AnimationController(
        duration: const Duration(seconds: 10), vsync: this);
    animation =
        new ColorTween(begin: Colors.red, end: Colors.blue).animate(controller)
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return new Scaffold(
      key: _scaffoldKey,
      body: new SingleChildScrollView(
        controller: scrollController,
        child: new Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage('assets/staticmap.gif'),
              fit: BoxFit.cover,
              alignment: Alignment.topLeft,
            ),
          ),
          child: new Column(
            children: <Widget>[
              new Container(
                height: screenSize.height / 4,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      child: new Text(
                        Strings.appName,
                        textAlign: TextAlign.center,
                        style: new TextStyle(fontSize: 50.0),
                      ),
                    ),
                  ],
                ),
              ),
              new Container(
                height: 3 * screenSize.height / 4,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Form(
                      key: _formKey,
                      autovalidate: _autovalidate,
                      child: new Column(
                        children: <Widget>[
                          new Container(
                            child: new InputField(
                                hintText: 'Email',
                                obscureText: false,
                                textInputType: TextInputType.text,
                                textStyle: textStyle,
                                hintStyle: textStyle,
                                textFieldColor: textFieldColor,
                                icon: Icons.mail_outline,
                                iconColor:
                                    const Color.fromRGBO(255, 255, 255, 0.4),
                                bottomMargin: 20.0,
                                validateFunction: _validateName,
                                onSaved: (String value) {
                                  email = value;
                                }),
                          ),
                          new InputField(
                              hintText: 'Password',
                              obscureText: true,
                              textInputType: TextInputType.text,
                              textStyle: textStyle,
                              hintStyle: textStyle,
                              textFieldColor: textFieldColor,
                              icon: Icons.lock_outline,
                              iconColor: Colors.white,
                              bottomMargin: 20.0,
                              onSaved: (String value) {
                                password = value;
                              }),
                        ],
                      ),
                    ),
                    new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new RoundedButton(
                          buttonName: 'Sign-In',
                          onTap: _handleSubmitted,
                          width: screenSize.width,
                          height: 50.0,
                          bottomMargin: 10.0,
                          borderWidth: 0.0,
                          buttonColor: const Color.fromRGBO(100, 100, 100, 1.0),
                        ),
                        new RoundedButton(
                          buttonName: 'Sign-up',
                          onTap: () {
                            RoutesHelper.pushRoute(context, ROUTE_SIGNUP);
                          },
                          highlightColor:
                              const Color.fromRGBO(255, 255, 255, 0.1),
                          width: screenSize.width,
                          height: 50.0,
                          bottomMargin: 10.0,
                          borderWidth: 0.0,
                          buttonColor: const Color.fromRGBO(100, 100, 100, 1.0),
                        ),

/// UNCOMMENT IF YOU WANT TO SIGNIN THROUGH GOOGLE
//                        (_isgooglesigincomplete
//                            ? new FloatingActionButton(
//                                child:
//                                    new Image.asset('assets/google-logo.jpg'),
//                                onPressed: _handleSubmitted1,
//                                backgroundColor: Colors.white,
//                              )
//                            : new FloatingActionButton(
//                                child: new CircularProgressIndicator(
//                                  valueColor: animation,
//                                ),
//                                onPressed: _handleSubmitted1,
//                                backgroundColor: Colors.white,
//                              )),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
