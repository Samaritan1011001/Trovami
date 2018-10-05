import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'functionsForFirebaseApiCalls.dart';



import 'homepage.dart';
import 'loadingindicator.dart';
import 'main.dart';
import 'signinpage.dart';


final userref = FirebaseDatabase.instance.reference().child('users');          // new
final groupref = FirebaseDatabase.instance.reference().child('groups');          // new
//var httpClient = createHttpClient();
const jsonCodec1=const JsonCodec(reviver: _reviver1);
const jsonCodec=const JsonCodec(reviver: _reviver);
List<currentLoc> currentLocations=new List<currentLoc>();
bool locationShare;
Timer t1;
bool mapflag;
var temp1=[];
var length;
bool togglestate=false;

_reviver(key,value) {

  if(key!=null&& value is Map) {
    return new UserData.fromJson(value);
  }
  else return value;
}

_reviver1(key,value) {

  if(key!=null&& value is Map){
    return new groupDetails.fromJson(value);
  }
 else return value;
}

 toggleMemberLocation(bool newValue) async{

//  final Map groupresmap=await getGroups();
//
//  groupresmap.forEach((k,v) async{
//    if(v.groupname==groupStatusGroupname) {
//      for(var i=0;i<v.groupmembers.length;i++) {
//        var response1 = await httpClient.get(
//            "https://fir-trovami.firebaseio.com/groups/${k}/members/${i}.json");
//      Map result1=jsonCodec.decode(response1.body);
//      if(result1["emailid"]==loggedinUser){
//        if(result1["locationShare"]==true) {
//          locationShare = false;
//        }
//        else {
//          locationShare=true;
//        }
//        String result2=jsonCodec.encode(locationShare);
//        await httpClient.put(
//            "https://fir-trovami.firebaseio.com/groups/${k}/members/${i}/locationShare.json",body: result2);
//
//      }
//      }
//    }
//  });

}




  class groupstatuslayout extends StatefulWidget {
    @override
    groupstatuslayoutstate createState() => new groupstatuslayoutstate();
  }

  class groupstatuslayoutstate extends State<groupstatuslayout>{

        @override
        Widget build(BuildContext context)=>
        new Scaffold(
        body: new Container(
          child:new groupstatus(),
        ),
        );
  }


  class groupstatus extends StatefulWidget {
    @override
    groupstatusstate createState() => new groupstatusstate();
  }

class groupstatusstate extends State<groupstatus>{

  var getMemFlag=0;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKeySecondary2 = new GlobalKey<ScaffoldState>();
  List<Widget> children=new List<Widget>();
  List<String> memberstoShowHomepage1=new List<String>();

  getgrpmembers(String grpkey,int i) async{
    var response1 = await getAGroupAndAMember(grpkey,i);
//    Map result1 = jsonCodec.decode(response1.body);
    print("response1 : ${i}");

    memberstoShowHomepage1.add(response1.value[i]["name"]);
    print("memberstoShowHomepage1 : ${memberstoShowHomepage1}");

    if (response1.value[i]["emailid"] == loggedinUser) {
      setState(() {
        togglestate = response1.value[i]["locationShare"];
        locationShare=response1.value[i]["locationShare"];
      });
    }



  }

  Future<Null>   getmembers1() async {
    if(nouserflag==1){
      showInSnackBar("No users online");
    }
    String grpkey;
    var grpmemcount;

    _refreshIndicatorKey.currentState?.show();

    final dynamic groupresmap = await getGroups();

//    print("grrrppr: ${groupresmap.value}");
    groupresmap.value.forEach((k, v){
      if (v["groupname"] == groupStatusGroupname) {
        print("v: ${v["groupname"]}");
        grpkey=k;
        grpmemcount=v["members"].length;

      }
      });
    print("grpmemcount : ${grpmemcount}");
    for(var i = 0;i<grpmemcount;i++)
    {
      getgrpmembers(grpkey,i);
    }
    setState(() {
      memberstoShowHomepage1=memberstoShowHomepage1;
//      memberstoShowHomepage1=dedup(memberstoShowHomepage1);
    });
  }


   List<String> dedup(List<String> list) {
    List<String> list1=new List<String>();
    Set seen = new Set();
    int unique = 0;
    for (int i = 0; i < list.length; i++) {
      String element = list[i];
      if (!seen.contains(element)) {
        seen.add(element);
        list1.insert(unique++,element);
      }
    }return list1;
  }



  void showInSnackBar(String value) {
    _scaffoldKeySecondary2.currentState.showSnackBar(
        new SnackBar(
            content: new Text(value)
        )
    );
  }

  @override
  void initState() {
    super.initState();
    getmembers1();
  }

  @override
  Widget build(BuildContext context) {
    children= new List.generate(memberstoShowHomepage1.length, (int i) => new memberlist(memberstoShowHomepage1[i]));
    return new RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: getmembers1,
      child: new Scaffold(
        key: _scaffoldKeySecondary2,
        appBar: new AppBar(
          leading: defaultTargetPlatform == TargetPlatform.iOS
              ? new CupertinoButton(child: new Icon(Icons.keyboard_backspace), onPressed: (){
            Navigator.of(context).pop();
          },
          ) : new FlatButton(onPressed: (){
            Navigator.of(context).pop();
          },
              child:new Icon(Icons.keyboard_backspace)
          ),
          actions: <Widget>[
            new FlatButton(onPressed:()async {
              await Navigator.of(context).pushNamed('/g');

            },
                child: new Text("Show Map")
            ),
          ],
          flexibleSpace: new FlexibleSpaceBar(
            title: new Text('Group Status'),
          ),
        ),
        body :new Container(
          child: new ListView(
            children : <Widget> [
              new Row(children :<Widget>[
                new Container(child: new Text("Share Live Location:",style: new TextStyle(fontSize: 20.0)),
                padding: const EdgeInsets.only( left:10.0),
                ),
                new Container(
                    child: defaultTargetPlatform == TargetPlatform.iOS
                        ? new CupertinoSwitch(value: togglestate, onChanged: (bool newValue) {
                      toggleMemberLocation(newValue);
                      setState(() {
                        togglestate = newValue;
                      });
                    },)
                        : new Switch(value: togglestate, onChanged: (bool newValue) {
                      toggleMemberLocation(newValue);
                      setState(() {
                        togglestate = newValue;
                      });
                    },
                    ),
                ),
              ],
              ),
              new Container(
                child: new Column(
                  children: <Widget>[
                    new Row(
                      children: <Widget>[
                        new CircleAvatar(
                          child:new Icon(Icons.group),
                          backgroundColor: const Color.fromRGBO(0, 0, 0, 0.2),
                        ),
                        new Expanded(child:new Container(
                            child: new Text(
                              "Group Name: ${groupStatusGroupname}",
                              style: new TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                            ),
                            padding: const EdgeInsets.only( left:20.0)
                        ),
                        ),
                      ],
                    ),
                  ],
                ),
                padding: const EdgeInsets.only( left:10.0,top: 5.0,bottom: 5.0),
                decoration: new BoxDecoration(
                  border: new Border(
                    bottom: new BorderSide(width: 1.0, color: const Color.fromRGBO(0, 0, 0, 0.2),style: BorderStyle.solid),
                  ),
                ),
              ),
              new Container(
                child:new Text("Members :",
                  style: new TextStyle(fontSize: 20.0),
                ),
                padding: const EdgeInsets.only( left:10.0,top: 10.0,bottom: 10.0),
                decoration: new BoxDecoration(
                  border: new Border(
                    bottom: new BorderSide(width: 0.0, color: const Color.fromRGBO(0, 0, 0, 0.2),style: BorderStyle.solid),
                  ),
                ),
              ),
              new Column( children: children),
            ],
          ),
          padding: const EdgeInsets.only(top:10.0),
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







