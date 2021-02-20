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
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

import 'helpers/RoutesHelper.dart';
import 'homepage.dart';
import 'httpClient/httpClient.dart';
import 'map.dart';
import 'main.dart';
import 'core/Group.dart';
import 'core/OldUser.dart';
import 'core/UserLocation.dart';
import 'signinpage.dart';


final userref = FirebaseDatabase.instance.reference().child('users');          // new
final groupref = FirebaseDatabase.instance.reference().child('groups');          // new
//var httpClient = createHttpClient();
const jsonCodec1=const JsonCodec(reviver: _reviver1);
const jsonCodec=const JsonCodec(reviver: _reviver);
const locationJsonCodec=const JsonCodec(reviver: _locationReviver);
List<Location> currentLocations=new List<Location>();
bool locationShare;
Timer t1;
bool mapflag;
var temp1=[];
var length;
bool togglestate=false;

_reviver(key,value) {

  if(key!=null&& value is Map) {
    return new OldUser.fromJson(value);
  }
  else return value;
}

_locationReviver(key,value) {
  if(key!=null) {
    return new UserLocation.fromJson(value);
  }
  else return value;
}

_reviver1(key,value) {

  if(key!=null&& value is Map){
    return new Group.fromJson(value);
  }
  else return value;
}

toggleMemberLocation(bool newValue) async{
  HttpClientFireBase httpClient = HttpClientFireBase();

  final DataSnapshot groupresmap=await getGroups();
  Map grps = groupresmap.value as Map;
  var location = new Location();
  Stream<LocationData> locationStream = location.onLocationChanged();
  StreamSubscription locationSub;
  grps.forEach((k,v) async{

    if(v["groupname"]==groupStatusGroupname) {
      for(var i=0;i<v["members"].length;i++) {
        var response1 = await http.get("https://trovami-bcd81.firebaseio.com/groups/${k}/members/${i}.json");
//        print(response1);
      Map result1=jsonCodec.decode(response1.body);
      if(result1["emailid"]==loggedinUser){
        if(result1["locationShare"]==true) {
          if(locationSub!=null)
            locationSub.cancel();
          locationShare = false;
        }
        else {
          LocationData currLoc;


          try {

            currLoc = await location.getLocation();
            await updateDatabaseLocation(currLoc);
            locationSub = locationStream.listen((LocationData currentLocation) async{
              await updateDatabaseLocation(currentLocation);
            });

          } on PlatformException catch (e) {
            if (e.code == 'PERMISSION_DENIED') {
              print('Permission denied');
            }
            currLoc = null ;
          }
          locationShare=true;
        }
        String result2=jsonCodec.encode(locationShare);
        await httpClient.put(
            url: "https://trovami-bcd81.firebaseio.com/groups/${k}/members/${i}/locationShare.json",body: result2);

      }
      }
    }
  });



}

updateDatabaseLocation (currLoc) async{
  HttpClientFireBase httpClient = HttpClientFireBase();


// Platform messages may fail, so we use a try/catch PlatformException.

    var loggedInuserKey = "";
    var updatedLocation ;
    String locUpdated;
    DataSnapshot usersDataSnap = await getUsers();
    Map usersMap = usersDataSnap.value as Map;
    usersMap.forEach((k,v){
      if(v["emailid"]==loggedinUser){
        loggedInuserKey = k;
        updatedLocation = {"latitude":currLoc.latitude,"longitude":currLoc.longitude};
      }
    });
    if (loggedInuserKey!="") {
      locUpdated = jsonCodec.encode(updatedLocation);
      await httpClient.put(
          url: "https://trovami-bcd81.firebaseio.com/users/${loggedInuserKey}/location.json",
          body: locUpdated);
    }
    final DataSnapshot groupresmap=await getGroups();
    Map grps = groupresmap.value as Map;

    grps.forEach((k,v) async{
      if(v["groupname"]==groupStatusGroupname) {
        for(var i=0;i<v["members"].length;i++) {
          var response1 = await http.get("https://trovami-bcd81.firebaseio.com/groups/${k}/members/${i}.json");
          print("response1->${response1}");
          Map result1=jsonCodec.decode(response1.body);
          if(result1["emailid"]==loggedinUser){
            if(result1["locationShare"]==true||result1["location"]==null) {
              await httpClient.put(
                  url: "https://trovami-bcd81.firebaseio.com/groups/${k}/members/${i}/location.json",body: locUpdated);
            }

          }
        }
      }
    });
}


class GroupStatusLayout extends StatefulWidget {
  @override
  GroupStatusLayoutState createState() => new GroupStatusLayoutState();
}

class GroupStatusLayoutState extends State<GroupStatusLayout>{

  @override
  Widget build(BuildContext context)=>
      new Scaffold(
        body: new Container(
          child:new GroupStatus(),
        ),
      );
}


class GroupStatus extends StatefulWidget {
  @override
  GroupStatusState createState() => new GroupStatusState();
}

class GroupStatusState extends State<GroupStatus>{

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
//    if(nouserflag==1){
//      showInSnackBar("No users online");
//    }
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
              await Navigator.of(context).pushNamed(ROUTE_MAP);
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
              Container(
                margin: const EdgeInsets.all(10.0),
                color: Colors.red,
                height: 100,
                child: Center(
                  child: Text("DO NOT USE REAL LOCATION",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                ),
              ),
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







