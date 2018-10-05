import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:locate_pal/homepage.dart';
import 'package:locate_pal/httpClient/httpClient.dart';

import 'InputTextField.dart';
import 'main.dart';
import 'signinpage.dart';
import 'functionsForFirebaseApiCalls.dart';


//var httpClient = createHttpClient();
String _selectedChoice="";
var Json = const JsonCodec();
var groupName="";
Color textFieldColor = const Color.fromRGBO(0, 0, 0, 0.2);
const jsonCodec=const JsonCodec(reviver: _reviver);
const jsonCodec1=const JsonCodec(reviver: _reviver1);

TextStyle textStyle = new TextStyle(
    color:const Color.fromRGBO(0, 0, 0, 0.9),
    fontSize: 16.0,
    fontWeight: FontWeight.normal);

ThemeData appTheme = new ThemeData(
  hintColor: Colors.white,
);


  _reviver(key,value) {

    if(key!=null&& value is Map && key.contains('-')){
      return new UserData.fromJson(value);
    }
    return value;
  }

  _reviver1(key,value) {

    if(key!=null&& value is Map && key.contains('-')){
      return new groupDetails.fromJson(value);
    }
    return value;
  }

  class addGroup extends StatefulWidget {
    dynamic users;
    addGroup({this.users});
    @override
    addGroupstate createState() => new addGroupstate(users:users);
  }

  class addGroupstate extends State<addGroup>{
    dynamic users;
    addGroupstate({this.users});
    final GlobalKey<ScaffoldState> _scaffoldKeySecondary1 = new GlobalKey<ScaffoldState>();
    final GlobalKey<FormState> _groupformKey = new GlobalKey<FormState>();

    bool _autovalidate1 = false;
    List<UserData> userstoShowGrpDetailsPage=new List<UserData>();
    List<Widget> children1=new List<Widget>();
    List<UserData> members=[];
    int count=0;

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
  var httpClient = HttpClientFireBase();
      final FormState form = _groupformKey.currentState;
      form.save();
      UserData loggedInMember = new UserData();
      loggedInMember.EmailId = loggedinUser;
      loggedInMember.locationShare = false;
      for (var i = 0; i < members.length; i++) {
        grpd.groupmembers.add(members[i]);
      }
      loggedInMember.name=loggedInUsername;
      grpd.groupmembers.add(loggedInMember);
      for (var i = 0; i < grpd.groupmembers.length; i++) {


//        final Map resstring = await getUsers();


        users.value.forEach((k, v) async {
          if (v["emailid"] == grpd.groupmembers[i].EmailId) {

            print("v['groupsIamin'] : ${v["groupsIamin"]}");
            if (v["groupsIamin"] == null) {
              List<String> groupsIamin = [];
              groupsIamin.add(grpd.groupname);
              var groupsIaminjson = jsonCodec.encode(groupsIamin);
             await httpClient.put(
                  url: 'https://fir-trovami.firebaseio.com/users/${k}/groupsIamin.json?',
                  body: groupsIaminjson);
            } else {

              var response2 = await getUserById(k);

              List resmap=[];
              resmap.addAll(response2.value["groupsIamin"]);
              print("resmap: ${resmap}");

              resmap.add(grpd.groupname);
              var groupsIaminjson = jsonCodec.encode(resmap);
              var response1 = await httpClient.put( url:
                  'https://fir-trovami.firebaseio.com/users/${k}/groupsIamin.json?',
                  body: groupsIaminjson);
            }
          }
        });
      }
      var groupjson = jsonCodec1.encode(grpd);
      var url = "https://fir-trovami.firebaseio.com/groups.json";
      await httpClient.post(url:url, body: groupjson);
//  Navigator.of(context).pushReplacement(
//    MaterialPageRoute(
//    builder: (context) => Homepagelayout(users: users),
//  ),);
     Navigator.of(context).pop();
//      await Navigator.of(context).pushReplacementNamed('/b');
    }

    void _select(UserData user) {
      members.add(user);
      for(var i=0;i<userstoShowGrpDetailsPage.length;i++){
        if(userstoShowGrpDetailsPage[i].EmailId==user.EmailId){
          userstoShowGrpDetailsPage.removeAt(i);
        }
      }
      setState(() {
        popflag=1;
        userstoShowGrpDetailsPage=userstoShowGrpDetailsPage;
        count = count + 1;
      });
    }

    getusers(){

      users.value.forEach((k,v){
        UserData usertoshow=new UserData();
        usertoshow.name=v["name"];
        usertoshow.EmailId = v["emailid"];
        usertoshow.locationShare=false;
        if(usertoshow.EmailId==loggedinUser){

        }else {
          userstoShowGrpDetailsPage.add(usertoshow);
        }
      });
    }

    @override
    void initState() => getusers();


    @override
    Widget build(BuildContext context) {


    if(members.isNotEmpty) {
      children1 =
      new List.generate(count, (int i) => new memberlist(members[i].name));
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
                    textFieldColor: textFieldColor,
                    icon: Icons.group,
                    validateFunction: checkifnotnull,
                    iconColor: Colors.grey,
                    bottomMargin: 20.0,
                    onSaved: (String value) {
                      grpd.groupname=value;
                      grpd.groupmembers=new List<UserData>();
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
                    new PopupMenuButton<UserData>(
                      icon: new Icon(Icons.add),
                      onSelected: _select,
                      itemBuilder: (BuildContext context) => userstoShowGrpDetailsPage.map((UserData usertoshow) =>
                           new PopupMenuItem<UserData>(
                            value: usertoshow,
                            child: new Text(usertoshow.name),
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
                    onPressed: (){   Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => Homepage(users: users),
                    ),);
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


  class memberlist extends StatelessWidget {
        final String mem;
        memberlist(this.mem);

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
