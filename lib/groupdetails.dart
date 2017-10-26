import 'main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter/rendering.dart';
import 'homepage.dart';
import 'dart:convert';
import 'dart:collection';
import 'InputTextField.dart';

TextStyle textStyle = new TextStyle(
    color: Colors.brown,
    fontSize: 16.0,
    fontWeight: FontWeight.normal);

ThemeData appTheme = new ThemeData(
  hintColor: Colors.white,
);

Color textFieldColor = const Color.fromRGBO(255, 255, 255, 0.1);


List<PersonData> members=new List<PersonData>();
String _selectedChoice="";
int count=0;
var Json = const JsonCodec();
var groupname="";

class addGroup extends StatefulWidget {
  @override
  addGroupstate createState() => new addGroupstate();
}

class addGroupstate extends State<addGroup>{
  List<Widget> children1=new List<Widget>();

  final GlobalKey<FormState> _groupformKey = new GlobalKey<FormState>();
  void _handleSubmitted() {
    final FormState form = _groupformKey.currentState;
    form.save();
    Navigator.of(context).pushNamed('/b');

  }
  void _select(PersonData user) {
    members.add(user);
    setState(() {
      count = count + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(count);
    //grpd=null;
    children1= new List.generate(count, (int i) => new memberlist(members[i].name));
    for(var i=0;i<children1.length;i++) {
      print(children1[i].toString());
    }
    return new Scaffold(
      body: new Form(
        key: _groupformKey,
        child: new ListView(
          padding: new EdgeInsets.symmetric(horizontal: 16.0),
          children: <Widget>[

            new Container(child: new Container( child: new Text("Group Details",
                style: new TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              padding: new EdgeInsets.only(bottom:20.0),
      ),
              padding: new EdgeInsets.only(top:50.0),
              decoration: new BoxDecoration(
              border: new Border(
                //top: new BorderSide(width: 16.0, color: Colors.brown[100]),
                bottom: new BorderSide(width: 0.0, color: Colors.brown[200]),
              ),
        ),
            ),
            new Container(child: new Container(
              child: new InputField(
                //icon: Icons.person,
                  hintText: "Groupname",
                  obscureText: false,
                  textInputType: TextInputType.text,
                  textStyle: textStyle,
                  textFieldColor: textFieldColor,
                  icon: Icons.group,
                  iconColor: Colors.grey,
                  bottomMargin: 20.0,
                  //validateFunction: _validateName,
                  onSaved: (String value) {
                    grpd.groupname=value;
                  }),
//              new TextFormField(
//                decoration: const InputDecoration(
//                  icon: const Icon(Icons.person),
//                  hintText: 'Groupname',
//                  labelText: 'Name of the group',
//                  isDense: true,
//                ),
//                onSaved: (String value) {
//                  grpd.groupname=value;
//                },
//              ),
//              decoration: new BoxDecoration(
//                borderRadius: new BorderRadius.circular(100.0),border: new Border.all(
//                color: Colors.black,
//                width: 1.0,
//                ),
//              ),
              padding: new EdgeInsets.only( bottom:15.0, top:0.0,right: 20.0),
            ),
                padding: new EdgeInsets.only( top:30.0)
            ),



            new Row(children: <Widget>[
              new Container(child:
              new Text("Add a member:",style: new TextStyle(fontSize: 16.0,
                  fontWeight: FontWeight.bold),),
                  padding: new EdgeInsets.only( left:13.0)

              ),

new Container(child:
        new CircleAvatar(child:
              new PopupMenuButton<PersonData>(
              icon: new Icon(Icons.add),
              onSelected: _select,
              itemBuilder: (BuildContext context) {
                return users.map((PersonData user) {
                  return new PopupMenuItem<PersonData>(
                    value: user,
                    child: new Text(user.name),
                  );
                }).toList();
              },
            ),
          backgroundColor: Colors.brown[200],
    ),
            padding: new EdgeInsets.only( left:50.0)

),
            ],
    ),



            new Column(
              children:children1,
            ),


            new Container(
              alignment: Alignment.bottomCenter,
              child: new FloatingActionButton(
                onPressed: _handleSubmitted,
                child: new Icon(Icons.check),
              ),
              padding: new EdgeInsets.only( top:50.0) ,
            ),
          ],
        ),
      ),
    );
  }


}


class memberlist extends StatelessWidget {
  final String mem;
  memberlist(this.mem);

  @override
  Widget build(BuildContext context) {
    return new Container(
        child: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new CircleAvatar(child:new Icon(Icons.person),
                  backgroundColor: Colors.brown[100],
                ),
                new Container(child:
                new Text(
                    "${mem}",
                    style: new TextStyle(fontSize: 20.0),
            //      icon: new Icon(Icons.person),
                ),
                    padding: new EdgeInsets.only( left:20.0)

                ),
              ],
            ),
          ],
        ),
        padding: new EdgeInsets.only( left:10.0,top: 5.0,bottom: 5.0),
      decoration: new BoxDecoration(
        border: new Border(
          //top: new BorderSide(width: 16.0, color: Colors.brown[100]),
          bottom: new BorderSide(width: 0.0, color: Colors.brown[200]),
        ),
      ),

    );


  }
}
