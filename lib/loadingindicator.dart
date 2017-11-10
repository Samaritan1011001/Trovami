import 'main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:map_view/camera_position.dart';
import 'package:map_view/location.dart';
import 'package:map_view/map_options.dart';
import 'package:map_view/map_view.dart';
import 'package:map_view/marker.dart';
import 'package:map_view/toolbar_action.dart';
import 'package:firebase_database/firebase_database.dart';

import 'groupstatus.dart';
import 'dart:math';

import 'homepage.dart';
import 'signinpage.dart';

final userref = FirebaseDatabase.instance.reference().child('users');          // new
final groupref = FirebaseDatabase.instance.reference().child('groups');
 int nouserflag;
var httpClient = createHttpClient();


class loadingindlayout extends StatefulWidget {
  @override
  loadingindlayoutstate createState() => new loadingindlayoutstate();
}

class loadingindlayoutstate extends State<loadingindlayout> {


  MapView mapView = new MapView();
  CameraPosition cameraPosition;
  var compositeSubscription = new CompositeSubscription();


Timer tim;
  loadshowmap() async {
//    var twenty = const Duration(seconds: 10);
//     tim=new Timer.periodic(twenty, (Timer t) async {
      _handleDismiss();
//              print("key:${key}");
    await getlocsofmembers(0);
      if(currentLocations.length!=0) {
        mapView = new MapView();
        compositeSubscription = new CompositeSubscription();
        showMap(currentLocations);
      }
    await getlocsofmembers(1);



//    });
  }

  @override
  void initState() {
//    super.initState();
    loadshowmap();
//  getlocsofmembers();
  }

  @override
  Widget build(BuildContext context) {
    return  new Scaffold( appBar: new AppBar(
      title:  new Text('Trovami'),
      backgroundColor: Colors.black,
      leading: new Container(),
//    flexibleSpace: new FlexibleSpaceBar(
//    title: new Text('Trovami'),
//    ),
    ),
    body: new Center(child: new Container(
        child:new CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
//
        ),
//      padding: new EdgeInsets.only(top:20.0,left: 10.0),
        )),
      );


//      new Container(child: new CircularProgressIndicator(
//      valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
//      key: new Key("nnnn"),

  }


  getlocsofmembers(var flag) async {
    var httpClient = createHttpClient();
    print(1);
    String groupkey;
    int memcount = 0;
    String userlockey;
if(flag==0) {
  var usersnurl = 'https://fir-trovami.firebaseio.com/users.json?orderBy="\$key"';
  var userresponse = await httpClient.get(usersnurl);
  Map resstring = jsonCodec.decode(userresponse.body);

  var memberlocshared = [];
  var url = "https://fir-trovami.firebaseio.com/groups.json";
//    _refreshIndicatorKey.currentState.show();
  var response = await httpClient.get(url);
//    print("response:${response.body}");
  Map groupresmap = jsonCodec1.decode(response.body);
  groupresmap.forEach((k, v) {
    if (v.groupname == groupstatusgroupname) {
      memcount = v.groupmembers.length;
      print("groupstatusgroupname:${groupstatusgroupname}");
      groupkey = k;
    }
  });
  print("memcount:${memcount}");
  for (var i = 0; i < memcount; i++) {
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
  httpClient.close();

}else {
  userref.onChildChanged.listen((event) async {
    print("${event.snapshot.value["location"]}");
    if(event.snapshot.value["emailid"]!=loggedinuser) {
      await groupref.orderByKey().once().then((DataSnapshot snapshot) {
        snapshot.value.forEach((k, v) {
//                print("v[members]:${v["members"]}");
          if (v["groupname"] == groupstatusgroupname) {
            for (v in v["members"]) {
              print(v);
              if (v["emailid"] == event.snapshot.value["emailid"] &&
                  v["locationShare"] == true) {
                print("here");
                var flag = 0;
                if (currentLocations.length != 0) {
                  for (var i = 0; i < currentLocations.length; i++) {
                    if (currentLocations[i].EmailId ==
                        event.snapshot.value["emailid"]) {
                      currentLoc currentLocation = new currentLoc();
                      currentLocation.EmailId = event.snapshot.value["emailid"];
                      currentLocation.currentLocation =
                      event.snapshot.value["location"];
                      currentLocations.removeAt(i);
                      currentLocations.add(currentLocation);
                      flag = 1;
                    }
                  }
                  if (flag == 0) {
                    currentLoc currentLocation = new currentLoc();
                    currentLocation.EmailId = event.snapshot.value["emailid"];
                    currentLocation.currentLocation =
                    event.snapshot.value["location"];
                    currentLocations.add(currentLocation);
                  }
                  _handleDismiss();

                  var twenty = const Duration(seconds: 15);
                  new Timer(twenty, () {
                    mapView = new MapView();
                    compositeSubscription = new CompositeSubscription();
                    showMap(currentLocations);
                  });
                }
                print("currentLocations.length:${currentLocations.length}");
                for (var i = 0; i < currentLocations.length; i++) {
                  print(
                      "Currentlocations Emaild:${currentLocations[i].EmailId}");

                  print(
                      "Currentlocations:${currentLocations[i]
                          .currentLocation}");
                }
              } else {
//              for (var i = 0; i < currentLocations.length; i++) {
//                print("currentLocations[i].EmailId:${currentLocations[i].EmailId}");
//                print("event.snapshot.value[emailid]:${event.snapshot.value["emailid"]}");
//                if (currentLocations[i].EmailId ==
//                    event.snapshot.value["emailid"]) {
//                  currentLocations.removeAt(i);
//                }
//              }
              }
              print("currentLocations.length2:${currentLocations.length}");
              for (var i = 0; i < currentLocations.length; i++) {
                print(
                    "Currentlocations Emaild2:${currentLocations[i].EmailId}");

                print(
                    "Currentlocations2:${currentLocations[i].currentLocation}");
              }
            }
          };
        }
        );
      });
    }
//    _handleDismiss();
//
//    var twenty = const Duration(seconds: 10);
//    new Timer(twenty, () {
//      mapView = new MapView();
//      compositeSubscription = new CompositeSubscription();
//      showMap(currentLocations);
//    });
  });
//  nouserflag=0;
//  if(currentLocations.length!=0){
//    for (var i = 0; i < currentLocations.length; i++) {
//      if(currentLocations[i].currentLocation==null){
//        Navigator.of(context).pop();
//        nouserflag=1;
//      }
//      print(
//          "Currentlocations Emaild2:${currentLocations[i].EmailId}");
//
//      print(
//          "Currentlocations2:${currentLocations[i].currentLocation}");
//    }
//  }



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



//    showMap();
}

  }

  showMap(List<currentLoc> currentLocations) {
    var httpClient = createHttpClient();

//    const oneSec = const Duration(seconds:20);
//    new Timer.periodic(oneSec, (Timer t)  => getlocsofmembers()
//    );
//    _refreshIndicatorKey1.currentState?.show();
  double lat;
  double long;
//    for (var i = 0; i < currentLocations.length; i++) {
//      mapView.setMarkers(<Marker>[
//        new Marker("1", "Work", 45.523970, -122.663081, color: Colors.blue),
//        new Marker("2", "Nossa Familia Coffee", 45.528788, -122.684633),
//      ]);
    print("currentLocations.length1:${currentLocations.length}");
    for (var i = 0; i < currentLocations.length; i++) {
      print("Currentlocations Emaild1:${currentLocations[i].EmailId}");

      print(
          "Currentlocations1:${currentLocations[i].currentLocation}");
    }

//    nouserflag=0;
//    for (var i = 0; i < currentLocations.length; i++) {
//      if (currentLocations[i].currentLocation == null) {
//        _handleDismiss();
//        Navigator.of(context).pushReplacementNamed('/d');
//        nouserflag = 1;
//      }
//    }
      if (currentLocations.length!=0&& currentLocations[0].currentLocation!=null) {
        lat=currentLocations[0].currentLocation["latitude"];
        long=currentLocations[0].currentLocation["longitude"];
      }
      else{
        lat=12.9716;
        long=77.5946;
      }
//    }
    print("showmap");
    mapView.show(
        new MapOptions(
            showUserLocation: locationShare,
            initialCameraPosition: new CameraPosition(
                new Location(lat, long), 14.0),
            title: "Live locator"),
        toolbarActions: [
          new ToolbarAction("Close", 1), new ToolbarAction("refresh", 2)]);

    var sub1 = mapView.onMapReady.listen((_) async {


      if(currentLocations.length!=0) {
        for (var i = 0; i < currentLocations.length; i++) {

//      mapView.setMarkers(<Marker>[
//        new Marker("1", "Work", 45.523970, -122.663081, color: Colors.blue),
//        new Marker("2", "Nossa Familia Coffee", 45.528788, -122.684633),
//      ]);
//        if (currentLocations[i].EmailId == loggedinuser) {
////        mapView.setMarkers(<Marker>[
////        new Marker("0", "${currentLocations[i].EmailId}", currentLocations[i].currentLocation["latitude"],
////            currentLocations[i].currentLocation["longitude"],
////            color: Colors.blue),
////        new Marker("2", "Nossa Familia Coffee", 45.528788, -122.684633),
//          mapView.addMarker(new Marker("${i}", "${currentLocations[i].EmailId}",
//              currentLocations[i].currentLocation["latitude"],
//              currentLocations[i].currentLocation["longitude"],
//              color: Colors.blue));
////      ]);
//        } else {
//          print("currentLocations[i].EmailId:${currentLocations[i].EmailId}");
//          print("Currentlocations:${currentLocations[i].currentLocation}");
//          nouserflag=0;
//
//          if(currentLocations[i].currentLocation==null){
//            _handleDismiss();
//            Navigator.of(context).pushReplacementNamed('/d');
//            nouserflag=1;
//          }
//          var lat= await currentLocations[i].currentLocation["latitude"];
//          var long= await currentLocations[i].currentLocation["longitude"];
//          await mapView.setCameraPosition(lat, long, 10.0);
        if(currentLocations[i].currentLocation!=null&&currentLocations[i].EmailId!=loggedinuser) {

          mapView.addMarker(new Marker("${i}", "${currentLocations[i].EmailId}",
              currentLocations[i].currentLocation["latitude"],
              currentLocations[i].currentLocation["longitude"],
              color: Colors.redAccent));
        }
        }
      }
//      else{
//        mapView.addMarker(new Marker("0", "${loggedinuser}",
//            currentLocations[i].currentLocation["latitude"],
//            currentLocations[i].currentLocation["longitude"],
//            color: Colors.redAccent));
//      }
      mapView.zoomToFit(padding: 100);
    });
    compositeSubscription.add(sub1);

    var sub2 = mapView.onLocationUpdated
        .listen((location)  {

      var twenty = const Duration(seconds: 30);
     new Timer(twenty, () async
      {
        locationclass loc = new locationclass();
        int decimals = 3;
        int fac = pow(10, decimals);
        double d = location.latitude;
        loc.latitude = (d * fac).round() / fac;

        double d1 = location.longitude;
        loc.longitude = (d1 * fac).round() / fac;
//        print("d: $d");
//        loc.latitude = location.latitude;
//        loc.longitude = location.longitude;
        String result2 = jsonCodec.encode(loc);
        bool locationflag = true;
        await groupref.orderByKey().once().then((DataSnapshot snapshot) {
          snapshot.value.forEach((k, v) {
//                print("v[members]:${v["members"]}");
            for (v in v["members"]) {
              print(v);
              if (v["name"] == loggedinusername && v["locationShare"] == true) {
//                    print("v[name]:${v["name"]}");
                locationflag = false;
              }
            };
          }
          );
        });
        if (locationflag == false) {
          print("true");
          var groupsiaminurl = 'https://fir-trovami.firebaseio.com/users.json?orderBy="\$key"';
          var response = await httpClient.get(groupsiaminurl);
          Map resstring = jsonCodec.decode(response.body);
          resstring.forEach((k, v) async {
            if (v.EmailId == loggedinuser) {
              var response1 = await httpClient.put(
                  'https://fir-trovami.firebaseio.com/users/${k}/location.json?',
                  body: result2);
              print("Response1:${response1.body}");
            }
          });
        }
      });
    });
    compositeSubscription.add(sub2);


    var sub3 = mapView.onTouchAnnotation
        .listen((annotation) => print("annotation tapped"));
    compositeSubscription.add(sub3);

    var sub4 = mapView.onMapTapped
        .listen((location) => print("Touched location $location"));
    compositeSubscription.add(sub4);

    var sub5 = mapView.onCameraChanged.listen((cameraPosition) =>
        this.setState((){
      this.cameraPosition = cameraPosition;
    }));
    compositeSubscription.add(sub5);
    int dismissflag = 0;
    var sub6 = mapView.onToolbarAction.listen((id) {
      if (id == 1) {
//        tim.cancel();
      print("dismiss");
        _handleDismiss();
        Navigator.of(context).pushReplacementNamed('/d');
      }
//      if (id == 2) {
//
//        showMapagain();
//      }
    });
    compositeSubscription.add(sub6);
    if (dismissflag == 0) {

    }
  }

  _handleDismiss() async {
//    double zoomLevel = await mapView.zoomLevel;
//    Location centerLocation = await mapView.centerLocation;
//    List<Marker> visibleAnnotations = await mapView.visibleAnnotations;
//    print("Zoom Level: $zoomLevel");
//    print("Center: $centerLocation");
//    print("Visible Annotation Count: ${visibleAnnotations.length}");
  httpClient.close();
    mapView.dismiss();
    compositeSubscription.cancel();
  }
}
  class CompositeSubscription

  {
  Set<StreamSubscription> _subscriptions = new Set();

  void cancel() {
  for (var n in this._subscriptions) {
  n.cancel();
  }
  this._subscriptions = new Set();
  }

  void add(StreamSubscription subscription) {
  this._subscriptions.add(subscription);
  }

  void addAll(Iterable<StreamSubscription> subs) {
  _subscriptions.addAll(subs);
  }

  bool remove(StreamSubscription subscription) {
  return this._subscriptions.remove(subscription);
  }

  bool contains(StreamSubscription subscription) {
  return this._subscriptions.contains(subscription);
  }

  List<StreamSubscription> toList() {
  return this._subscriptions.toList();

  }}
