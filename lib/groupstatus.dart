import 'main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'dart:core';
import 'signinpage.dart';
import 'homepage.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

import 'dart:async';
import 'loadingindicator.dart';
import 'main.dart';


import 'package:map_view/camera_position.dart';
import 'package:map_view/location.dart';
import 'package:map_view/map_options.dart';
import 'package:map_view/map_view.dart';
import 'package:map_view/marker.dart';
import 'package:map_view/toolbar_action.dart';
//import 'package:location/location.dart';

final userref = FirebaseDatabase.instance.reference().child('users');          // new
final groupref = FirebaseDatabase.instance.reference().child('groups');          // new


bool locationShare;

var httpClient = createHttpClient();
const jsonCodec1=const JsonCodec(reviver: _reviver1);
const jsonCodec=const JsonCodec(reviver: _reviver);
//const jsonCodec3=const JsonCodec(reviver: _reviver3);

//Location _location = new Location();
List<currentLoc> currentLocations=new List<currentLoc>();
Timer t1;
bool mapflag;
var temp1=[];
var length;
bool togglestate=false;

//_reviver3(key,value) {
//
//  if(key!=null&& value is Map) {
//    return new locationclass.fromJson(value);
//  }
//  else
//    return value;
//}
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
        else {
          print("true");
//          MapView mapView = new MapView();
////          CameraPosition cameraPosition;
//          var compositeSubscription = new CompositeSubscription();
//          var sub =  mapView.onLocationUpdated
//              .listen((location) async {
//            print("true1");
//            locationclass loc=new locationclass();
//            loc.latitude=location.latitude;
//            loc.longitude=location.longitude;
//            String result2 = jsonCodec.encode(loc);
//            bool locationflag=true;
//            await groupref.orderByKey().once().then((DataSnapshot snapshot) {
//              snapshot.value.forEach((k, v) {
//                print("v[members]:${v["members"]}");
//                for (v in v["members"]) {
//                  print(v);
//                  if (v["name"] == loggedinusername && v["locationShare"] == true) {
//                    print("v[name]:${v["name"]}");
//                    locationflag = false;
//                  }
//                };
//              }
//              );
//            });
//            if(locationflag==false){
//              print("true");
//              var groupsiaminurl = 'https://fir-trovami.firebaseio.com/users.json?orderBy="\$key"';
//              var response = await httpClient.get(groupsiaminurl);
//              Map resstring = jsonCodec.decode(response.body);
//              resstring.forEach((k, v) async {
//                if (v.EmailId == loggedinuser) {
//                  var response1 = await httpClient.put(
//                      'https://fir-trovami.firebaseio.com/users/${k}/location.json?',
//                      body: result2);
//                  print("Response1:${response1.body}");
//                }
//              });
//            }
//          });
//          compositeSubscription.add(sub);
//          mapView.dismiss();
//          compositeSubscription.cancel();
          locationShare=true;
        }
        String result2=jsonCodec.encode(locationShare);
        var response2=await httpClient.put(
            "https://fir-trovami.firebaseio.com/groups/${k}/members/${i}/locationShare.json",body: result2);

//        if (locationShare == true) {
//          var usersnurl = 'https://fir-trovami.firebaseio.com/users.json?orderBy="\$key"';
//          var response = await httpClient.get(usersnurl);
//          Map resstring = jsonCodec.decode(response.body);
//          resstring.forEach((k, v) async {
//            var flag=0;
//            if (v.EmailId == loggedinuser) {
//              var response1 = await httpClient.get(
//                  'https://fir-trovami.firebaseio.com/users/${k}/location.json?');
//              Map resmap1 = jsonCodec.decode(response1.body);
//              if (resmap1 != null) {
//                for (var i = 0; i < currentLocations.length; i++) {
//                  if (currentLocations[i].EmailId == loggedinuser) {
//                    currentLoc currentLocation = new currentLoc();
//                    currentLocation.EmailId = loggedinuser;
//                    currentLocation.currentLocation = resmap1;
//                    currentLocations.insert(i, currentLocation);
//
//                    flag = 1;
//                  }
//                }
//                if(flag==0) {
//                  currentLoc currentLocation = new currentLoc();
//                  currentLocation.EmailId = loggedinuser;
//                  currentLocation.currentLocation = resmap1;
//                  currentLocations.add(currentLocation);
//                }
//              } else {
//                Map<String, double> location;
//                try {
////                  location = await _location.getLocation;
//                } on PlatformException {
//                  location = null;
//                }
//                var usersnurl = 'https://fir-trovami.firebaseio.com/users.json?orderBy="\$key"';
//                var response = await httpClient.get(usersnurl);
//                Map resstring = jsonCodec.decode(response.body);
//                resstring.forEach((k, v) async {
//                  var flag1=0;
//                  if (v.EmailId == loggedinuser) {
//                    print("location:${location}");
//                    String result2 = jsonCodec.encode(location);
//                    var response1 = await httpClient.put(
//                        'https://fir-trovami.firebaseio.com/users/${k}/location.json?',
//                        body: result2);
//                    for (var i = 0; i < currentLocations.length; i++) {
//                      if (currentLocations[i].EmailId == loggedinuser) {
//                        currentLoc currentLocation = new currentLoc();
//                        currentLocation.EmailId = loggedinuser;
//                        currentLocation.currentLocation = resmap1;
//                        currentLocations.insert(i, currentLocation);
//
//                        flag1 = 1;
//                      }
//                    }
//                    if(flag1==0) {
//                      currentLoc currentLocation = new currentLoc();
//                      currentLocation.EmailId = loggedinuser;
//                      currentLocation.currentLocation = resmap1;
//                      currentLocations.add(currentLocation);
//                    }
//                    print("response1:${response1.body}");
//                  }
//                });
//              }
//              print("response1:${response1.body}");
//            }
//          });
//        }
//        else {
//          for (var i = 0; i < currentLocations.length; i++) {
//            if (currentLocations[i].EmailId == loggedinuser) {
//              currentLocations.removeAt(i);
//            }
//          }
//        }

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



  var getmemflag=0;
  bool switch1=false;
  var switch2;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  List<Widget> children=new List<Widget>();
  List<String> memberstoshowhomepage1=new List<String>();

  getlocsofmembers() async{

    var httpClient = createHttpClient();
    print(1);
    String groupkey;
    int memcount=0;
    String userlockey;


    var usersnurl = 'https://fir-trovami.firebaseio.com/users.json?orderBy="\$key"';
    var userresponse = await httpClient.get(usersnurl);
    Map resstring = jsonCodec.decode(userresponse.body);
    var memberlocshared=[];
    var url="https://fir-trovami.firebaseio.com/groups.json";
//    _refreshIndicatorKey.currentState.show();
    var response=await httpClient.get(url);
//    print("response:${response.body}");
    Map groupresmap=jsonCodec1.decode(response.body);
    groupresmap.forEach((k,v) {
      if(v.groupname==groupstatusgroupname) {
        memcount=v.groupmembers.length;
        print("groupstatusgroupname:${groupstatusgroupname}");
        groupkey = k;
      }
    });
    print("memcount:${memcount}");
    for(var i=0;i<memcount;i++) {
      var response1 = await httpClient.get(
          "https://fir-trovami.firebaseio.com/groups/${groupkey}/members/${i}.json");
//          print("response1:${response1.body}");
      Map result1 = jsonCodec.decode(response1.body);
      print(result1["emailid"]);
      print(result1["locationShare"]);
//          if(result1["emailid"]!=loggedinuser) {
      if (result1["locationShare"] == true) {
//            memberlocshared.add(i);
        resstring.forEach((k, v) {
          if (v.EmailId == result1["emailid"]) {
            userlockey = k;
          }
        });
//                  print("v.Emaild:${v.EmailId}");
        var flag = 0;
        var userlocresponse = await httpClient.get(
            "https://fir-trovami.firebaseio.com/users/${userlockey}/location.json");
        Map resmap1 = jsonCodec.decode(userlocresponse.body);
        print("resmap1:${resmap1}");
        for (var i = 0; i < currentLocations.length; i++) {
          if (currentLocations[i].EmailId == result1["emailid"]) {
            currentLoc currentLocation = new currentLoc();
            currentLocation.EmailId = result1["emailid"];
            currentLocation.currentLocation = resmap1;
            currentLocations.removeAt(i);
            currentLocations.add(currentLocation);
            flag = 1;
          }
        }
        print("flag:${flag}");
        if (flag == 0) {
          print(3);
          currentLoc currentLocation = new currentLoc();
          currentLocation.EmailId = result1["emailid"];
          currentLocation.currentLocation = resmap1;
          currentLocations.add(currentLocation);
        }
      } else {
        for (var i = 0; i < currentLocations.length; i++) {
          print(4);
          if (currentLocations[i].EmailId == result1["emailid"]) {
            currentLocations.removeAt(i);
          }
        }
      }
    }

//          }
//          else {
//            print(2);
//            if (result1["locationShare"] == true) {
//              resstring.forEach((k, v) async {
//                var flag=0;
//                if (v.EmailId == loggedinuser) {
//                  var response2 = await httpClient.get(
//                      "https://fir-trovami.firebaseio.com/users/${k}/location.json");
//                  Map resmap2 = jsonCodec.decode(response2.body);
//                  if (resmap2 != null) {
//                    for (var i = 0; i < currentLocations.length; i++) {
//                      if (currentLocations[i].EmailId == loggedinuser) {
//                        currentLoc currentLocation = new currentLoc();
//                        currentLocation.EmailId = loggedinuser;
//                        currentLocation.currentLocation = resmap2;
//                        currentLocations.insert(i, currentLocation);
//
//                        flag = 1;
//                      }
//                    }
//                    if (flag == 0) {
//                      currentLoc currentLocation = new currentLoc();
//                      currentLocation.EmailId = loggedinuser;
//                      currentLocation.currentLocation = resmap2;
//                      currentLocations.add(currentLocation);
//                    }
//                  }
//                }
//                else{
//                  for (var i = 0; i < currentLocations.length; i++) {
//                    if (currentLocations[i].EmailId == loggedinuser) {
//                      currentLocations.removeAt(i);
//                    }
//                  }
//                }
//              });
//            }
//          }


    for (var i = 0; i < currentLocations.length; i++) {
      print("Currentlocations Emaild:${currentLocations[i].EmailId}");

      print("Currentlocations:${currentLocations[i].currentLocation}");
    }
//    String currmap=buildurl(currentLocations);
//        print("currmap:${currmap}");


//    setState(() {
//      print("currmap1:${currmap}");
//      if(currmap==null){
//        currentmap= new Image.asset("graphics/staticmap.gif",fit:BoxFit.fill, );
//      }else {
//        currentmap = new Image.network(
//          currmap,
//          fit: BoxFit.fill,
//          gaplessPlayback: true,
//        );
//      }
//    });


    httpClient.close();

//    showMap();


  }

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
        locationShare=result1["locationShare"];
      });
    }
    setState(() {
      memberstoshowhomepage1=dedup(memberstoshowhomepage1);
    });
  }

  Future<Null>   getmembers1() async {
    if(nouserflag==1){
      showInSnackBar("No users online");
    }
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
  final GlobalKey<ScaffoldState> _scaffoldKeySecondary2 = new GlobalKey<ScaffoldState>();

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
//  MapView mapView = new MapView();
//  CameraPosition cameraPosition;
//  var compositeSubscription = new CompositeSubscription();

  @override
  Widget build(BuildContext context) {

    children= new List.generate(memberstoshowhomepage1.length, (int i) => new memberlist(memberstoshowhomepage1[i]));
    if(switch2=="showme"){
      switch1=true;
    }else{
      switch1=false;
    }
    return new RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: getmembers1,
        child: new Scaffold(
          key: _scaffoldKeySecondary2,
          appBar: new AppBar(
            leading: new FlatButton(onPressed: (){
              Navigator.of(context).pushReplacementNamed('/b');
            }, child:new Icon(Icons.keyboard_backspace)),
        actions: <Widget>[
          new FlatButton(onPressed:()async {
//            const oneSec = const Duration(seconds: 20);
//            new Timer.periodic(oneSec, (Timer t) async {
//              t1=t;
              Navigator.of(context).pushNamed('/g');

//              _handleDismiss();
//
////              print("key:${key}");
//              await getlocsofmembers();
//              mapView = new MapView();
//              compositeSubscription = new CompositeSubscription();
//              showMap();
//            });
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
                      new Expanded(child:new Container(
                          child:
                      new Text(
                        "Group Name: ${groupstatusgroupname}",
                        style: new TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                      ),
                          padding: new EdgeInsets.only( left:20.0)
                      ),
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

//  showMapagain() async {
//    _handleDismiss();
//
//    await getlocsofmembers();
//        mapView = new MapView();
//    compositeSubscription = new CompositeSubscription();
//        const oneSec = const Duration(seconds:5);
//        Timer t;
//    new Timer(oneSec, () => showMap(t));
//
//
//
//  }


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







