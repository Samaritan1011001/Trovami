import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:trovami/managers/ProfileManager.dart';

import '../Strings.dart';
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
    List<String> selectedIds=[];

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
     Navigator.of(context).pop();
    }

    void _select(String friendId) {
      setState(() {
        print("Trovami.AddGroupToScreen: New member selected");
      });
    }

    @override
    void initState();

    @override
    Widget build(BuildContext context) {


    if(ProfileManager().profile.friends.isNotEmpty) {
      var friends = ProfileManager().profile.friends;
      children1 = List.generate(friends.length, (int i) => new MemberList(ProfileManager().getFriendData(friends[i]).name));
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
                  child: new Text(Strings.addGroup,
                    style: ThemeManager().getStyle(STYLE_TITLE),
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
              // Group Name
              Container(
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
              // Select Friends instructions
              Center(child:
                Text(Strings.selectFriendsForGroup,style: ThemeManager().getStyle(STYLE_NORMAL)),
              ),
              SizedBox(height:20.0),
              Column(
                children:children1,
              ),
              Row(children: <Widget>[
                  Spacer(),
                  FloatingActionButton(
                    heroTag: "tag1",
                    onPressed: _handleSubmitted,
                    child: Icon(Icons.check),
                  ),
                  SizedBox(width: 40.0),
                  FloatingActionButton(
                    heroTag: "tag2",
                    onPressed: (){
                      // Navigator.of(context).pushReplacement(MaterialPageRoute(
                      // builder: (context) => Homepage(users: users),),);
                      RoutesHelper.pushRoute(context, ROUTE_GROUP_DETAILS);
                    },
                    child: new Icon(Icons.clear),
                  ),
                Spacer(),
              ],
              ),
            ],
          ),
        ),
      );
    }
  }


  class MemberList extends StatelessWidget {
    final String name;
    MemberList(this.name);

    @override
    Widget build(BuildContext context) =>
    Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                child:new Icon(Icons.person),
                backgroundColor: const Color.fromRGBO(0, 0, 0, 0.2),
              ),
              Container(child:
              Text(name,
                  style: TextStyle(fontSize: 20.0),
              ),
                  padding: EdgeInsets.only( left:20.0)

              ),
            ],
          ),
        ],
      ),
      padding: EdgeInsets.only( left:10.0,top: 5.0,bottom: 5.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 0.0, color: const Color.fromRGBO(0, 0, 0, 0.2),),
        ),
      ),
    );
  }
