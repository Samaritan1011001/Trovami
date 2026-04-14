import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:trovami/helpers/RoutesHelper.dart';
import 'package:trovami/httpClient/httpClient.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'InputTextField.dart';
import 'Roundedbutton.dart';
import 'Strings.dart';
import 'core/OldUser.dart';
import 'homepage.dart';
import 'functionsForFirebaseApiCalls.dart';
import 'signuppage.dart' show userexists, jsonCodec;

final googleSignIn = GoogleSignIn();
String loggedinUser = '';
String? loggedInUsername;
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

final FirebaseAuth _auth = FirebaseAuth.instance;

TextStyle textStyle = const TextStyle(
    color: Color.fromRGBO(255, 255, 255, 0.4),
    fontSize: 16.0,
    fontWeight: FontWeight.normal);

Color textFieldColor = const Color.fromRGBO(0, 0, 0, 0.7);
ScrollController scrollController = ScrollController();

class SignInForm extends StatefulWidget {
  @override
  SigninFormState createState() => SigninFormState();
}

class SigninFormState extends State<SignInForm>
    with SingleTickerProviderStateMixin {
  // ignore: unused_field
  bool _isgooglesigincomplete = true;
  // ignore: unused_field
  bool _first = true;

  final IconData mail = const IconData(0xe158, fontFamily: 'MaterialIcons');
  final IconData lock_outline =
      const IconData(0xe899, fontFamily: 'MaterialIcons');
  final IconData signinicon =
      const IconData(0xe315, fontFamily: 'MaterialIcons');
  final IconData signupicon =
      const IconData(0xe316, fontFamily: 'MaterialIcons');
  bool _autovalidate = false;
  // ignore: unused_field
  bool _formWasEdited = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // ignore: unused_field
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      GlobalKey<FormFieldState<String>>();
  late Animation<Color?> animation;
  late AnimationController controller;

  String email = '';
  String password = '';

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(value)));
  }

  // ignore: unused_element
  _handleSubmitted1() async {
    setState(() {
      _isgooglesigincomplete = false;
    });
    try {
      _authenticateWithGoogle();
    } catch (error) {
      // handle error
    }
  }

  _authenticateWithGoogle() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // ignore: unused_local_variable
    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);

    OldUser guser = OldUser();
    guser.EmailId = googleUser.email;
    guser.name = googleUser.displayName;
    guser.locationShare = false;

    final String guserjson = jsonCodec.encode(guser);

    final DataSnapshot response = await getUsers();

    if (response.value != null) {
      (response.value as Map).forEach((k, v) {
        if (v["emailid"] == googleUser.email) {
          userexists = true;
          loggedinUser = googleUser.email;
          loggedInUsername = googleUser.displayName;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  Homepagelayout(users: response),
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
      loggedinUser = googleUser.email;
      loggedInUsername = googleUser.displayName;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              Homepagelayout(users: response),
        ),
      );
    } else {
      setState(() {
        _isgooglesigincomplete = true;
      });
    }
  }

  _handleSubmitted() async {
    final FormState? form = _formKey.currentState;
    if (form == null) return;
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
              builder: (context) =>
                  Homepagelayout(users: usrmap),
            ),
          );
        }
      });
      showInSnackBar(
          'Login EmailID or Password is incorrect. Please Try again.');
    }
  }

  String? _validateName(String? value) {
    _formWasEdited = true;
    if (value == null || value.isEmpty) return 'EmailID is required.';
    final nameExp = RegExp(r'^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$');
    if (!nameExp.hasMatch(value)) return 'Please enter correct EmailID';
    return null;
  }

  setGoogleSigninListener() {
    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {});
    _googleSignIn.signInSilently();
  }

  @override
  void initState() {
    super.initState();
    setGoogleSigninListener();

    controller = AnimationController(
        duration: const Duration(seconds: 10), vsync: this);
    animation =
        ColorTween(begin: Colors.red, end: Colors.blue).animate(controller)
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        controller: scrollController,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/staticmap.gif'),
              fit: BoxFit.cover,
              alignment: Alignment.topLeft,
            ),
          ),
          child: Column(
            children: <Widget>[
              Container(
                height: screenSize.height / 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text(
                        Strings.appName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 50.0),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 3 * screenSize.height / 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      autovalidateMode: _autovalidate
                          ? AutovalidateMode.onUserInteraction
                          : AutovalidateMode.disabled,
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: InputField(
                                hintText: 'Email',
                                obscureText: false,
                                textInputType: TextInputType.text,
                                textStyle: textStyle,
                                hintStyle: textStyle,
                                textFieldColor: textFieldColor,
                                icon: Icons.mail_outline,
                                iconColor: const Color.fromRGBO(
                                    255, 255, 255, 0.4),
                                bottomMargin: 20.0,
                                validateFunction: _validateName,
                                onSaved: (String? value) {
                                  email = value ?? '';
                                }),
                          ),
                          InputField(
                              hintText: 'Password',
                              obscureText: true,
                              textInputType: TextInputType.text,
                              textStyle: textStyle,
                              hintStyle: textStyle,
                              textFieldColor: textFieldColor,
                              icon: Icons.lock_outline,
                              iconColor: Colors.white,
                              bottomMargin: 20.0,
                              onSaved: (String? value) {
                                password = value ?? '';
                              }),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RoundedButton(
                          buttonName: 'Sign-In',
                          onTap: _handleSubmitted,
                          width: screenSize.width,
                          height: 50.0,
                          bottomMargin: 10.0,
                          borderWidth: 0.0,
                          buttonColor: const Color.fromRGBO(
                              100, 100, 100, 1.0),
                        ),
                        RoundedButton(
                          buttonName: 'Sign-up',
                          onTap: () {
                            RoutesHelper.pushRoute(
                                context, ROUTE_SIGNUP);
                          },
                          highlightColor: const Color.fromRGBO(
                              255, 255, 255, 0.1),
                          width: screenSize.width,
                          height: 50.0,
                          bottomMargin: 10.0,
                          borderWidth: 0.0,
                          buttonColor: const Color.fromRGBO(
                              100, 100, 100, 1.0),
                        ),
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
