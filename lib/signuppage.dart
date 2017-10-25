
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


class SignupLayout extends StatefulWidget {
  @override
  signuplayoutstate createState() => new signuplayoutstate();
}

class signuplayoutstate extends State<SignupLayout>{
  @override
  Widget build(BuildContext context){
    return new Scaffold(
//      appBar: new AppBar(centerTitle: true,title: new Text("Trovami"),elevation: 0.0),
      body: new Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("graphics/back.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child:new Signup(),
      ),

    );
  }
}




class Signup extends StatefulWidget {
  @override
  signupstate createState() => new signupstate();

}

class signupstate extends State<Signup>{

  final GlobalKey<ScaffoldState> _scaffoldKeySecondary = new GlobalKey<
      ScaffoldState>();
  PersonData user=new PersonData();

  void showInSnackBar(String value) {
    _scaffoldKeySecondary.currentState.showSnackBar(new SnackBar(
        content: new Text(value)
    ));
  }

  bool _autovalidate1 = false;
  bool _formWasEdited = false;
  GlobalKey<FormState> _formKeySeondary = new GlobalKey<FormState>();
  final GlobalKey<
      FormFieldState<String>> _passwordFieldKeySecondary = new GlobalKey<
      FormFieldState<String>>();

  void _handleSubmitted1() {
    //print(_formWasEdited);
    final FormState form = _formKeySeondary.currentState;
    if (!form.validate()) {
      _autovalidate1 = true; // Start validating on every change.
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      users.add(user);
      for(var i=0;i<users.length;i++) {
        print(users[i].EmailId);
        print(users[i].password);
      }
      //showInSnackBar('${person.name}\'s phone number is ${person.phoneNumber}');
      Navigator.of(context).pop();
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
    final FormFieldState<String> passwordField1 = _passwordFieldKeySecondary.currentState;
    if (passwordField1.value == null || passwordField1.value.isEmpty)
      return 'Please choose a password.';
    if (passwordField1.value != value)
      return 'Passwords don\'t match';
    return null;
  }


//  final TextEditingController _controller = new TextEditingController();
//  final TextEditingController _passcontroller = new TextEditingController();

  final IconData mail = const IconData(0xe158, fontFamily: 'MaterialIcons');
  final IconData lock_outline = const IconData(
      0xe899, fontFamily: 'MaterialIcons');
  final IconData signupicon=const IconData(0xe316, fontFamily: 'MaterialIcons');




  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        body: new Container(child:new Form(
          key: _formKeySeondary,
          autovalidate: _autovalidate1,
          child: new ListView(
            padding: new EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              new Container(
                child: new TextFormField(

                  decoration: new InputDecoration(
                    hintText: 'Name',
                    labelText: 'Name',
                    icon: new Icon(Icons.person),
                    //hintStyle: new TextStyle(color: Colors.black),
                  ),
                  onSaved: (String value) { user.name = value; },
                ),
//                decoration: new BoxDecoration(borderRadius: new BorderRadius.circular(100.0),border: new Border.all(
//                  color: Colors.black,
//                  width: 1.0,
//                ),),
                padding: new EdgeInsets.only( bottom:15.0, top:0.0,right: 20.0 ),
              ),
              new Container(
                child: new Container(
                  child: new TextFormField(
                    decoration: new InputDecoration(
                      icon: new Icon(mail),
                      hintText: 'EmailID',
                      labelText: 'EmailID',
                    ),
                    onSaved: (String value) { user.EmailId = value; },
                    validator: _validateName,
                  ),
//                  decoration: new BoxDecoration(borderRadius: new BorderRadius.circular(100.0),border: new Border.all(
//                    color: Colors.black,
//                    width: 1.0,
//                  ),),
                  padding: new EdgeInsets.only( bottom:15.0, top:0.0,right: 20.0 ),
                ),
                padding: new EdgeInsets.only(top:10.0),
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
                    onSaved: (String value) { user.password=value;
                    },
                  ),
//                  decoration: new BoxDecoration(borderRadius: new BorderRadius.circular(100.0),border: new Border.all(
//                    color: Colors.black,
//                    width: 1.0,
//                  ),),
                  padding: new EdgeInsets.only( bottom:15.0, top:0.0,right: 20.0 ),
                ),
                padding: new EdgeInsets.only(top:10.0),
              ),
              new Container(
                child: new Container(
                  child:new TextFormField(
                    //key: _passwordFieldKeySecondary,
                    decoration: new InputDecoration(
                      hintText: 'Repeat Password',
                      labelText: 'Retype-Password *',
                      icon: new Icon(lock_outline),
                    ),
                    obscureText: true,
                    validator: _validatePassword,
                  ),
//                  decoration: new BoxDecoration(borderRadius: new BorderRadius.circular(100.0),border: new Border.all(
//                    color: Colors.black,
//                    width: 1.0,
//                  ),),
                  padding: new EdgeInsets.only( bottom:15.0, top:0.0,right: 20.0 ),
                ),
                padding: new EdgeInsets.only(top:10.0),
              ),
                //const SizedBox(width: 16.0),

              new Container(
                padding: const EdgeInsets.all(20.0),
                alignment: Alignment.center,
                child: new RaisedButton(
                  //tooltip: 'Sign-up',
                  child: new Text("Sign up"),
                  onPressed: _handleSubmitted1,
                  color: Colors.brown[300],
                  highlightColor: Colors.brown,
                  splashColor: Colors.white,
                  elevation: 150.0,
                  //backgroundColor: Colors.brown,
                ),
                ),


              new Container(
                padding: const EdgeInsets.only(top: 20.0),
                child: new Text('* indicates required field', style: Theme.of(context).textTheme.caption),
              ),
            ],
          ),
        ),
          padding: new EdgeInsets.only(top:50.0),
        ),
      backgroundColor: Colors.brown[100],
    );
  }

}