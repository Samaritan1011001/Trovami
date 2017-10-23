import 'main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'homepage.dart';
import 'dart:convert';
import 'dart:collection';


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
  String _selectedChoice="";
  void _select(PersonData user) {
    setState(() { // Causes the app to rebuild with the new _selectedChoice.
      _selectedChoice = user.name;
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(body: new CustomScrollView(
      slivers: <Widget>[
        new SliverAppBar(
          pinned: true,
          expandedHeight: 50.0,
          //floating: true,
          actions: <Widget>[
            //new IconButton(icon: new Icon(Icons.group_add), onPressed: addgroup,iconSize: 42.0,),
            new IconButton(icon: new Icon(Icons.person), onPressed: () {
              showModalBottomSheet<Null>(context: context, builder: (BuildContext context) {
                return new Container(
                    child: new Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: new ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          children: <Widget>[
                            new Container(
                              child: new Text(
                                "User Details",
                                textAlign: TextAlign.center,
                                //style: new TextStyle(fontFamily:'Nexa',fontSize: 50.0)
                              ),
                            ),
                            new Container(
                              child: new Text(
                                "Name:${logindet.EmailId}",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            new Container(
                              child: new Text(
                                "EmailID:${logindet.EmailId}",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        )
                    )
                );
              });
            },
              iconSize: 35.0,),
          ],
          flexibleSpace: new FlexibleSpaceBar(
            title: new Text('Demo'),

          ),
        ),

        new SliverGrid(
          gridDelegate: new SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200.0,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 4.0,
          ),
          delegate: new SliverChildBuilderDelegate(
                (BuildContext context, int index) {
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
            },
            childCount: 1,
          ),
        ),
        new SliverGrid(
          gridDelegate: new SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200.0,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 4.0,
          ),
          delegate: new SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return new Container(child:
              new Container(
                child: new PopupMenuButton<PersonData>( // overflow menu
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
                padding: new EdgeInsets.only( bottom:15.0, top:0.0,right: 20.0 ),
              ),
                padding: new EdgeInsets.only(top:10.0),
              );
            },
            childCount: 1,
          ),
        ),

        new SliverFixedExtentList(
          itemExtent: 80.0,
          delegate: new SliverChildBuilderDelegate(
                (BuildContext context,int index) {
              print(grpd.groupname);
              return new Container(child:
                new Container(
                  child: new Text(
                    _selectedChoice,
                  ),

                  decoration: new BoxDecoration(borderRadius: new BorderRadius.circular(100.0),border: new Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),),
                  padding: new EdgeInsets.only( bottom:15.0, top:0.0,right: 20.0 ),
                ),
                  padding: new EdgeInsets.only(top:10.0),
                );

            },
            childCount: 1,
          ),
        ),
        new SliverGrid(
          gridDelegate: new SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200.0,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 4.0,
          ),
          delegate: new SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return new Container(
                //padding: const EdgeInsets.all(20.0),
                alignment: Alignment.center,
                child: new FloatingActionButton(
                  onPressed: _handleSubmitted,
                  child: new Icon(Icons.check),
                  //tooltip: 'Sign-in',
                  //iconSize: 75.0,
                  //alignment: Alignment.center,
                  //color: Colors.black87,
                  //height: 200.0,
//                highlightColor: Colors.white70,
//                splashColor: Colors.transparent,
                ),
                padding: new EdgeInsets.only(top:10.0),
              );
            },
            childCount: 1,
          ),
        ),




            //const SizedBox(width: 16.0),


          ],
        ),
    );
  }


}