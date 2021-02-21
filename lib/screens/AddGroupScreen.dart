import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:trovami/managers/ProfileManager.dart';

import '../widgets/InputTextField.dart';
import '../helpers/RoutesHelper.dart';
import '../managers/ThemeManager.dart';
import 'SignInScreen.dart';

  class AddGroupScreen extends StatefulWidget {
    AddGroupScreen();
    @override
    AddGroupScreenState createState() => new AddGroupScreenState();
  }

  class AddGroupScreenState extends State<AddGroupScreen>{
    AddGroupScreenState();
    final GlobalKey<ScaffoldState> _scaffoldKeySecondary1 = new GlobalKey<ScaffoldState>();
    final GlobalKey<FormState> _groupformKey = new GlobalKey<FormState>();

    List<Widget> children1=new List<Widget>();
    List<String> members=[];

    void showInSnackBar(String value) {
      _scaffoldKeySecondary1.currentState.showSnackBar(
          new SnackBar(
              content: new Text(value)
          )
      );
    }

    String checkifnotnull(String value){
      if(value.isEmpty) {
        return 'Groupname must not be empty';
      }
      return null;
    }

     _handleSubmitted() async {
//      var httpClient = HttpClientFireBase();
      final FormState form = _groupformKey.currentState;
      form.save();
      // TrovUser loggedInMember = new TrovUser();
      // loggedInMember.email = loggedInUserEmail;
      // loggedInMember.shareLocation = false;
      // ProfileManager().addFriends(members);
      // loggedInMember.name=loggedInUsername;
     Navigator.of(context).pop();
//      await Navigator.of(context).pushReplacementNamed('/b');
    }

    void _select(String friendId) {
//      members.add(user);
      setState(() {
        print("Trovami.AddGroupToScreen: New member selected");
      });
    }

    @override
    void initState();

    @override
    Widget build(BuildContext context) {


    if(members.isNotEmpty) {
      children1 =
      new List.generate(members.length, (int i) => new MemberList(ProfileManager().friends[i].name));
    }

    return new Scaffold(
      key: _scaffoldKeySecondary1,
      body: new Form(
        autovalidate: true,
          key: _groupformKey,
          child: new ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              new Container(
                child: new Container(
                  child: new Text("Add a Group",
                    style: new TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  padding: const EdgeInsets.only(bottom:20.0),
                ),
                padding: const EdgeInsets.only(top:50.0),
                decoration: new BoxDecoration(
                  border: new Border(
                    bottom: new BorderSide(width: 0.0, color: Colors.brown[200]),
                  ),
                ),
              ),
              new Container(
                child: new Container(
                  child: new InputField(
                    hintText: "Groupname",
                    obscureText: false,
                    textInputType: TextInputType.text,
                    textStyle: textStyle,
                    textFieldColor: ThemeManager().getStyle(COLOR_TEXT_FIELD),
                    icon: Icons.group,
                    validateFunction: checkifnotnull,
                    iconColor: Colors.grey,
                    bottomMargin: 20.0,
                    onSaved: (String value) {
                      // GroupsManager().currentGroup().groupname=value;
                      // GroupsManager().currentGroup().groupmembers=new List<TrovUser>();
                      print("Trovami.AddGroupScreen: SAVE GROUP NOT IMPLEMENTED");
                    }
                  ),
                  padding: const EdgeInsets.only( bottom:15.0, top:0.0,right: 20.0),
                ),
                  padding: const EdgeInsets.only( top:30.0)
              ),
              new Row(children: <Widget>[
                new Container(child:
                new Text("Add a member:",style: new TextStyle(fontSize: 16.0,
                    fontWeight: FontWeight.bold),
                ),
                    padding: new EdgeInsets.only( left:13.0)
                ),
                new Container(child:
                  new CircleAvatar(child:
                    new PopupMenuButton<String>(
                      icon: new Icon(Icons.add),
                      onSelected: _select,
                      itemBuilder: (BuildContext context) => ProfileManager().profile.friends.map((String friendId) =>
                           new PopupMenuItem<String>(
                            value: friendId,
                            child: new Text(ProfileManager().friends[friendId].name),
                          )
                        ).toList()
                    ),
                    backgroundColor: const Color.fromRGBO(0, 0, 0, 0.2),
                  ),
                    padding: const EdgeInsets.only( left:50.0)
                ),
              ],
              ),
              new Column(
                children:children1,
              ),
              new Row(children: <Widget>[

                new Container(
                  alignment: Alignment.bottomCenter,
                  child: new FloatingActionButton(
                    onPressed: _handleSubmitted,
                    child: new Icon(Icons.check),
                  ),
                  padding: const EdgeInsets.only( top:50.0,left: 100.0) ,
                ),
                new Container(
                  child:new FloatingActionButton(
                    onPressed: (){
                      // Navigator.of(context).pushReplacement(MaterialPageRoute(
                      // builder: (context) => Homepage(users: users),),);
                      RoutesHelper.pushRoute(context, ROUTE_GROUP_DETAILS);
                    },
                    child: new Icon(Icons.clear),
                    heroTag: null,
                  ),
                  padding: const EdgeInsets.only( top:50.0,left: 50.0) ,
                ),
              ],
              ),
            ],
          ),
        ),
      );
    }
  }


  class MemberList extends StatelessWidget {
        final String mem;
        MemberList(this.mem);

        @override
        Widget build(BuildContext context) =>
        new Container(
          child: new Column(
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new CircleAvatar(
                    child:new Icon(Icons.person),
                    backgroundColor: const Color.fromRGBO(0, 0, 0, 0.2),
                  ),
                  new Container(child:
                  new Text(
                      "${mem}",
                      style: new TextStyle(fontSize: 20.0),
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
              bottom: new BorderSide(width: 0.0, color: const Color.fromRGBO(0, 0, 0, 0.2),),
            ),
          ),
        );

  }
