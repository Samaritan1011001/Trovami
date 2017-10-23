import 'main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter/rendering.dart';
import 'homepage.dart';
import 'dart:convert';
import 'dart:collection';

String _selectedChoice="";
List<PersonData> members=new List<PersonData>();

var Json = const JsonCodec();
var groupname="";
class addGroup extends StatefulWidget {
  @override
  addGroupstate createState() => new addGroupstate();
}
class addGroupstate extends State<addGroup>{
  final GlobalKey<FormState> _formKey1 = new GlobalKey<FormState>();

  void _handleSubmitted() {
    final FormState form = _formKey1.currentState;
    if (!form.validate()) {
      //_autovalidate = true;  // Start validating on every change.
      //showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      print(grpd.groupname);
      Navigator.of(context).pushNamed('/b');
      //print(person.password);
      //showInSnackBar('${person.name}\'s phone number is ${person.phoneNumber}');
    }
  }
  void _select(PersonData user) {
    //members.add(user);
    setState(() {
      _selectedChoice=user.name;

      count = count + 1;
    }
    );
  }
  int count=1;
  @override
  Widget build(BuildContext context) {
    memberlist mems=new memberlist();
    print(count);
    List<Widget> children1= new List.generate(count, (int i) => mems );
    for(var i=0;i<children1.length;i++) {
      print(children1[i].toString());
      print(children1[i].toStringShort());
    }    return new Scaffold(body: new CustomScrollView(
      slivers: <Widget>[
        new SliverFixedExtentList(
          itemExtent: 80.0,
          delegate: new SliverChildBuilderDelegate(
                (BuildContext context,int index) {
              print(grpd.groupname);
              return new Container(
                child: new TextFormField(
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.person),
                    hintText: 'Groupname',
                    labelText: 'Name of the group',
                    isDense: true,
                  ),
                  onSaved: (String value) {
                    grpd.groupname=value;
                  },
                  //validator: _validateName,
                ),
                decoration: new BoxDecoration(borderRadius: new BorderRadius.circular(100.0),border: new Border.all(
                  color: Colors.black,
                  width: 1.0,
                ),),
                padding: new EdgeInsets.only( bottom:15.0, top:0.0,right: 20.0 ),
              );
                  //padding: new EdgeInsets.only(top:10.0),


            },
            childCount: 1,
          ),
        ),

      new SliverFixedExtentList(
        itemExtent: 80.0,
        delegate: new SliverChildBuilderDelegate(
              (BuildContext context, int index) {
            print(grpd.groupname);
            return new PopupMenuButton<PersonData>( // overflow menu
                onSelected: _select,
                itemBuilder: (BuildContext context) {
                  return users.map((PersonData user) {
                    return new PopupMenuItem<PersonData>(
                      value: user,
                      child: new Text(user.name),
                    );
                  }).toList();
                },
              );

          },
          childCount: 1,
        ),
      ),
        new SliverFixedExtentList(
        itemExtent: 80.0,
        delegate: const SliverChildListDelegate (
          children: children1,
          addAutomaticKeepAlives: true,
      ),
    ),


        new SliverFixedExtentList(
          itemExtent: 80.0,
          delegate: new SliverChildBuilderDelegate(
                (BuildContext context,int index) {
              print(grpd.groupname);
              return new Container(
                //padding: const EdgeInsets.all(20.0),
                alignment: Alignment.center,
                child: new FloatingActionButton(
                  onPressed: _handleSubmitted,
                  child: new Icon(Icons.check),

                ),
                //padding: new EdgeInsets.only(top:10.0),
              );
              //padding: new EdgeInsets.only(top:10.0),


            },
            childCount: 1,
          ),
        ),
      ],
      ),
    );
  }


}









class memberlist extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return new Text(_selectedChoice);

  }
}
