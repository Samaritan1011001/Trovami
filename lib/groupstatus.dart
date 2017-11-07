import 'main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'dart:core';
import 'signinpage.dart';
import 'homepage.dart';
import 'dart:async';
import 'package:location/location.dart';




var httpClient = createHttpClient();
const jsonCodec1=const JsonCodec(reviver: _reviver1);
const jsonCodec=const JsonCodec(reviver: _reviver);
Location _location = new Location();
List<currentLoc> currentLocations=new List<currentLoc>();

bool mapflag;
var temp1=[];
var length;
bool togglestate=false;

_reviver(key,value) {

  if(key!=null&& value is Map) {
    return new UserData.fromJson(value);
  }
  else
    return value;
}

_reviver1(key,value) {

  if(key!=null&& value is Map){
    return new groupDetails.fromJson(value);
  }
//  else if(key!=null&& value is Map && key.runtimeType==int){
//    return new UserData.fromJson(value);
//  }
 else
  return value;
}


 togglememberlocation(bool newValue) async{
bool locationShare;
  var url="https://fir-trovami.firebaseio.com/groups.json";
  var response=await httpClient.get(url);
//  print("response:${response.body}");
  Map groupresmap=jsonCodec1.decode(response.body);
  groupresmap.forEach((k,v) async{
    if(v.groupname==groupstatusgroupname) {
      for(var i=0;i<v.groupmembers.length;i++) {
        var response1 = await httpClient.get(
            "https://fir-trovami.firebaseio.com/groups/${k}/members/${i}.json");
//        print("response1:${response1.body}");
      Map result1=jsonCodec.decode(response1.body);
//      print(result1["emailid"]);
      if(result1["emailid"]==loggedinuser){

        if(result1["locationShare"]==true) {
          locationShare = false;
        }
        else locationShare=true;
        String result2=jsonCodec.encode(locationShare);
        var response2=await httpClient.put(
            "https://fir-trovami.firebaseio.com/groups/${k}/members/${i}/locationShare.json",body: result2);

        if (locationShare == true) {
          var usersnurl = 'https://fir-trovami.firebaseio.com/users.json?orderBy="\$key"';
          var response = await httpClient.get(usersnurl);
          Map resstring = jsonCodec.decode(response.body);
          resstring.forEach((k, v) async {
            var flag=0;
            if (v.EmailId == loggedinuser) {
              var response1 = await httpClient.get(
                  'https://fir-trovami.firebaseio.com/users/${k}/location.json?');
              Map resmap1 = jsonCodec.decode(response1.body);
              if (resmap1 != null) {
                for (var i = 0; i < currentLocations.length; i++) {
                  if (currentLocations[i].EmailId == loggedinuser) {
                    currentLoc currentLocation = new currentLoc();
                    currentLocation.EmailId = loggedinuser;
                    currentLocation.currentLocation = resmap1;
                    currentLocations.insert(i, currentLocation);

                    flag = 1;
                  }
                }
                if(flag==0) {
                  currentLoc currentLocation = new currentLoc();
                  currentLocation.EmailId = loggedinuser;
                  currentLocation.currentLocation = resmap1;
                  currentLocations.add(currentLocation);
                }
              } else {
                Map<String, double> location;
                try {
                  location = await _location.getLocation;
                } on PlatformException {
                  location = null;
                }
                var usersnurl = 'https://fir-trovami.firebaseio.com/users.json?orderBy="\$key"';
                var response = await httpClient.get(usersnurl);
                Map resstring = jsonCodec.decode(response.body);
                resstring.forEach((k, v) async {
                  var flag1=0;
                  if (v.EmailId == loggedinuser) {
                    print("location:${location}");
                    String result2 = jsonCodec.encode(location);
                    var response1 = await httpClient.put(
                        'https://fir-trovami.firebaseio.com/users/${k}/location.json?',
                        body: result2);
                    for (var i = 0; i < currentLocations.length; i++) {
                      if (currentLocations[i].EmailId == loggedinuser) {
                        currentLoc currentLocation = new currentLoc();
                        currentLocation.EmailId = loggedinuser;
                        currentLocation.currentLocation = resmap1;
                        currentLocations.insert(i, currentLocation);

                        flag1 = 1;
                      }
                    }
                    if(flag1==0) {
                      currentLoc currentLocation = new currentLoc();
                      currentLocation.EmailId = loggedinuser;
                      currentLocation.currentLocation = resmap1;
                      currentLocations.add(currentLocation);
                    }
                    print("response1:${response1.body}");
                  }
                });
              }
              print("response1:${response1.body}");
            }
          });
        }
        else {
          for (var i = 0; i < currentLocations.length; i++) {
            if (currentLocations[i].EmailId == loggedinuser) {
              currentLocations.removeAt(i);
            }
          }
        }

      }
      }
    }
  });

}




class groupstatuslayout extends StatefulWidget {
  @override
  groupstatuslayoutstate createState() => new groupstatuslayoutstate();
}

class groupstatuslayoutstate extends State<groupstatuslayout>{






  @override
  Widget build(BuildContext context){
    return new Scaffold(
      body: new Container(
        child:new groupstatus(),
      ),

    );
  }
}


class groupstatus extends StatefulWidget {
  @override
  groupstatusstate createState() => new groupstatusstate();
}

class groupstatusstate extends State<groupstatus>{





//  initPlatformState(String emailid) async {
//    Map<String,double> location;
//
//
//    try {
//      location = await _location.getLocation;
//    } on PlatformException {
//      location = null;
//    }
//
//    if (!mounted)
//      return;
////    currentLoc currentLocation=new currentLoc();
////    currentLocation.EmailId=emailid;
////    currentLocation.currentLocation=location;
////    currentLocations.add(currentLocation);
//
//    var usersnurl = 'https://fir-trovami.firebaseio.com/users.json?orderBy="\$key"';
//    var response=await httpClient.get(usersnurl);
//    Map resstring=jsonCodec.decode(response.body);
//    resstring.forEach((k,v) async {
//      if(v.EmailId==emailid){
//        print("location:${location}");
//        String result2=jsonCodec.encode(location);
//        var response1=await httpClient.put('https://fir-trovami.firebaseio.com/users/${k}/location.json?',body: result2);
//        print("response1:${response1.body}");
//      }
//    });
//  }

  var getmemflag=0;
  bool switch1=false;
  var switch2;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  List<Widget> children=new List<Widget>();
  List<String> memberstoshowhomepage1=new List<String>();



  getgrpmembers(String grpkey,int i) async{
    var response1 = await httpClient. get (
        "https://fir-trovami.firebaseio.com/groups/${grpkey}/members/${i}.json");
    //          print("response1:${response1.body}");
    Map result1 = jsonCodec.decode(response1.body);
    ////          print(result1["locationShare"]);
    memberstoshowhomepage1.add(result1["name"]);

    if (result1["emailid"] == loggedinuser) {
      setState(() {
        togglestate = result1["locationShare"];
      });
    }
    setState(() {
      memberstoshowhomepage1=dedup(memberstoshowhomepage1);
    });
  }

  Future<Null>   getmembers1() async {
    String grpkey;
    var grpmemcount;
    var url = "https://fir-trovami.firebaseio.com/groups.json";
    _refreshIndicatorKey.currentState?.show();
    var response = await httpClient.get(url);
//    print("response:${response.body}");
    Map groupresmap = jsonCodec1.decode(response.body);
    groupresmap.forEach((k, v){
      if (v.groupname == groupstatusgroupname) {
        grpkey=k;
        grpmemcount=v.groupmembers.length;

      }
      });
    print("grpmemcount:${grpmemcount}");
          for(var i = 0;i<grpmemcount;i++)
          {
            getgrpmembers(grpkey,i);
          }


//      togglestate = togglestate;

  }
   List<String> dedup(List<String> list) {
    List<String> list1=new List<String>();
    Set seen = new Set();
    int unique = 0;
//    list1.insert(0, list[0]);
    for (int i = 0; i < list.length; i++) {
      String element = list[i];
      if (!seen.contains(element)) {
        seen.add(element);
        list1.insert(unique++,element);
      }
//      list.length = unique;
    }return list1;
  }

  @override
  void initState() {
    super.initState();
    getmembers1();
  }


  @override
  Widget build(BuildContext context) {





//    if(getmemflag==0) {
//      getmembers1();
//      getmemflag=1;
//    }
    children= new List.generate(memberstoshowhomepage1.length, (int i) => new memberlist(memberstoshowhomepage1[i]));
    if(switch2=="showme"){
      switch1=true;
    }else{
      switch1=false;
    }
    return new RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: getmembers1,
        child: new Scaffold( appBar: new AppBar(
        actions: <Widget>[
          new FlatButton(onPressed: (){
//            if(mapflag==true){
//              switch2="showme";
              Navigator.of(context).pushNamed('/e');
//            }else{
//              switch2="showwithoutme";
//              Navigator.of(context).pushNamed('/e');
//            }
          }, child: new Text("Show Map")),
        ],
      flexibleSpace: new FlexibleSpaceBar(
            title: new Text('Trovami'),
          ),
        ),

      body :new Container(
        child: new ListView(
          children : <Widget> [
            new Row(children :<Widget>[
              new Container(child: new Text("Share Live Location:",style: new TextStyle(fontSize: 20.0)),
                padding: new EdgeInsets.only( left:10.0),
              ),
              new Container(
                  child: new Switch(value: togglestate, onChanged: (bool newValue) {
                    togglememberlocation(newValue);
                    setState(() {
                      togglestate = newValue;
                    });
                  },
                  )
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
                      new Container(child:
                      new Text(
                        "Group Name: ${groupstatusgroupname}",
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
                  bottom: new BorderSide(width: 1.0, color: const Color.fromRGBO(0, 0, 0, 0.2),style: BorderStyle.solid),
                ),
              ),
            ),


            new Container(
              child:new Text("Members :",
                style: new TextStyle(fontSize: 20.0),
              ),
              padding: new EdgeInsets.only( left:10.0,top: 10.0,bottom: 10.0),
              decoration: new BoxDecoration(
                border: new Border(
                  bottom: new BorderSide(width: 0.0, color: const Color.fromRGBO(0, 0, 0, 0.2),style: BorderStyle.solid),
                ),
              ),
            ),
            new Column( children: children),
          ],
        ),
        padding: new EdgeInsets.only(top:10.0),
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
}