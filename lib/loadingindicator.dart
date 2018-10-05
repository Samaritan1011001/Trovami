import 'dart:math';
import 'dart:async';


import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:map_view/camera_position.dart';
import 'package:map_view/location.dart';
import 'package:map_view/map_options.dart';
import 'package:map_view/map_view.dart';
import 'package:map_view/marker.dart';
import 'package:map_view/toolbar_action.dart';
import 'package:firebase_database/firebase_database.dart';

import 'groupstatus.dart';
import 'homepage.dart';
import 'main.dart';
import 'signinpage.dart';
import 'functionsForFirebaseApiCalls.dart';

final userref = FirebaseDatabase.instance.reference().child('users');          // new
final groupref = FirebaseDatabase.instance.reference().child('groups');
int nouserflag;
var twenty;
var sec = const Duration(seconds: 1);
Timer t2;
//var httpClient = HttpClient();


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
          _handleDismiss();
        await getlocsofmembers(0);
          if(currentLocations.isNotEmpty) {
            mapView = new MapView();
            compositeSubscription = new CompositeSubscription();
            Navigator.of(context).pop();
            showMap(currentLocations);
          }
        await getlocsofmembers(1);
      }

      @override
      void initState() {
        super.initState();
        loadshowmap();
        twenty = const Duration(seconds: 10);
        t2=new Timer(sec, ()=>{});
      }

      @override
      void dispose(){
        super.dispose();

      }

      @override
      Widget build(BuildContext context) =>
      new Scaffold(
        appBar: new AppBar(
          title:  new Text('Trovami'),
          backgroundColor: Colors.black,
          leading: new Container(),
        ),
        body: new Center(
            child: new Container(
              child:new CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            )
        ),
      );

      getlocsofmembers(var flag) async {
//        var httpClient = createHttpClient();
//        String groupkey;
//        int memcount = 0;
//        String userlockey;
//        if(flag==0) {
//
//          final Map resstring = await getUsers();
//
//          final Map groupresmap = await getGroups();
//          groupresmap.forEach((k, v) {
//            if (v.groupname == groupStatusGroupname) {
//              memcount = v.groupmembers.length;
//              print("groupstatusgroupname:${groupStatusGroupname}");
//              groupkey = k;
//            }
//          });
//          for (var i = 0; i < memcount; i++) {
//            var response1 = await httpClient.get(
//                "https://fir-trovami.firebaseio.com/groups/${groupkey}/members/${i}.json");
//            Map result1 = jsonCodec.decode(response1.body);
//            print(result1["emailid"]);
//            print(result1["locationShare"]);
//            if (result1["locationShare"] == true) {
//              resstring.forEach((k, v) {
//                if (v.EmailId == result1["emailid"]) {
//                  userlockey = k;
//                }
//              });
//              var flag = 0;
//              var userlocresponse = await httpClient.get(
//                  "https://fir-trovami.firebaseio.com/users/${userlockey}/location.json");
//              final Map resmap1 = jsonCodec.decode(userlocresponse.body);
//              for (var i = 0; i < currentLocations.length; i++) {
//                if (currentLocations[i].EmailId == result1["emailid"]) {
//                  currentLoc currentLocation = new currentLoc();
//                  currentLocation.EmailId = result1["emailid"];
//                  currentLocation.currentLocation = resmap1;
//                  currentLocations.removeAt(i);
//                  currentLocations.add(currentLocation);
//                  flag = 1;
//                }
//              }
//              if (flag == 0) {
//                currentLoc currentLocation = new currentLoc();
//                currentLocation.EmailId = result1["emailid"];
//                currentLocation.currentLocation = resmap1;
//                currentLocations.add(currentLocation);
//              }
//            } else {
//              for (var i = 0; i < currentLocations.length; i++) {
//                if (currentLocations[i].EmailId == result1["emailid"]) {
//                  currentLocations.removeAt(i);
//                }
//              }
//            }
//          }
//          httpClient.close();
//        }else {
//          userref.onChildChanged.listen((event) async {
//            if(event.snapshot.value["emailid"]!=loggedinUser) {
//              await groupref.orderByKey().once().then((DataSnapshot snapshot) {
//                snapshot.value.forEach((k, v) {
//                  if (v["groupname"] == groupStatusGroupname) {
//                    for (v in v["members"]) {
//                      if (v["emailid"] == event.snapshot.value["emailid"] &&
//                          v["locationShare"] == true) {
//                        var flag = 0;
//                        if (currentLocations.isNotEmpty) {
//                          for (var i = 0; i < currentLocations.length; i++) {
//                            if (currentLocations[i].EmailId ==
//                                event.snapshot.value["emailid"]) {
//                              currentLoc currentLocation = new currentLoc();
//                              currentLocation.EmailId = event.snapshot.value["emailid"];
//                              currentLocation.currentLocation =
//                              event.snapshot.value["location"];
//                              currentLocations.removeAt(i);
//                              currentLocations.add(currentLocation);
//                              flag = 1;
//                            }
//                          }
//                          if (flag == 0) {
//                            currentLoc currentLocation = new currentLoc();
//                            currentLocation.EmailId = event.snapshot.value["emailid"];
//                            currentLocation.currentLocation =
//                            event.snapshot.value["location"];
//                            currentLocations.add(currentLocation);
//                          }
////                          _handleDismiss();
//
////                          var twenty = const Duration(seconds: 15);
////                          new Timer(twenty, () {
//                            if(currentLocations.length!=0) {
//                              for (var i = 0; i < currentLocations.length; i++) {
//                                if(currentLocations[i].currentLocation!=null&&currentLocations[i].EmailId!=loggedinUser &&currentLocations[i].EmailId==event.snapshot.value["emailid"])
//                                {
//                                  mapView.removeMarker(new Marker("${currentLocations[i].EmailId}", "${currentLocations[i].EmailId}",
//                                      currentLocations[i].currentLocation["latitude"],
//                                      currentLocations[i].currentLocation["longitude"],
//                                      color: Colors.redAccent));
//                                  mapView.addMarker(new Marker("${currentLocations[i].EmailId}", "${currentLocations[i].EmailId}",
//                                      currentLocations[i].currentLocation["latitude"],
//                                      currentLocations[i].currentLocation["longitude"],
//                                      color: Colors.redAccent));
//                                  mapView.zoomToFit(padding: 500);
//
//                                }
//                              }
////
//                            }
////                          });
//                        }
//                      } else {}
//                    }
//                  };
//                }
//                );
//              });
//            }
//          });
//        }
      }

      showMap(List<currentLoc> currentLocations) {
        double lat;
        double long;
        if (currentLocations.length!=0&& currentLocations[0].currentLocation!=null) {
          lat=currentLocations[0].currentLocation["latitude"];
          long=currentLocations[0].currentLocation["longitude"];
        } else{
          lat=12.9716;
          long=77.5946;
        }
        mapView.show(
            new MapOptions(
                showUserLocation: locationShare,
                initialCameraPosition: new CameraPosition(
                    new Location(lat, long), 14.0),
                title: "Live locator"),
            toolbarActions: [
              new ToolbarAction("Close", 1)
            ]);
        var sub1 = mapView.onMapReady.listen((_) async {
          if(currentLocations.isNotEmpty) {
            for (var i = 0; i < currentLocations.length; i++) {
              if(currentLocations[i].currentLocation!=null&&currentLocations[i].EmailId!=loggedinUser) {
                    mapView.addMarker(new Marker("${currentLocations[i].EmailId}", "${currentLocations[i].EmailId}",
                    currentLocations[i].currentLocation["latitude"],
                    currentLocations[i].currentLocation["longitude"],
                    color: Colors.redAccent));
              }
            }
          }
          mapView.zoomToFit(padding: 100);
        });
        compositeSubscription.add(sub1);

        var sub2 = mapView.onLocationUpdated
            .listen((location) async {
          print(1);
         if(!t2.isActive) {
        t2= new  Timer(twenty,await updateLocation(location)
          );
          }
        });
        compositeSubscription.add(sub2);

        var sub3 = mapView.onTouchAnnotation
            .listen((annotation) => print("annotation tapped"));
        compositeSubscription.add(sub3);

        var sub4 = mapView.onMapTapped
            .listen((location) => print("Touched location $location"));
        compositeSubscription.add(sub4);

        var sub5 = mapView.onCameraChanged.listen(
                (cameraPosition) {
//                  this.setState(() {
//                    this.cameraPosition = cameraPosition;
//                  })
                }
        );
        compositeSubscription.add(sub5);

        var sub6 = mapView.onToolbarAction.listen((id) {
          if (id == 1) {
            _handleDismiss();
//            Navigator.of(context).pushReplacementNamed('/d');
          }
        });
        compositeSubscription.add(sub6);

      }

      _handleDismiss() async {
//        httpClient.close();
          mapView.dismiss();
          compositeSubscription.cancel();

      }
}
  class CompositeSubscription {
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

    bool remove(StreamSubscription subscription) => this._subscriptions.remove(subscription);


    bool contains(StreamSubscription subscription) => this._subscriptions.contains(subscription);


    List<StreamSubscription> toList() => this._subscriptions.toList();

  }





  updateLocation(location) async{
//    var httpClient = createHttpClient();
    bool locationflag = true;
    locationclass loc = new locationclass();
    loc.latitude = location.latitude;
    loc.longitude = location.longitude;
    int decimals = 5;

    int fac = pow(10, decimals);
    double d = location.latitude;
    loc.latitude = (d * fac).round() / fac;
    double d1 = location.longitude;
    loc.longitude = (d1 * fac).round() / fac;
    String result2 = jsonCodec.encode(loc);
    await groupref.orderByKey().once().then((DataSnapshot snapshot) {
      snapshot.value.forEach((k, v) {
        for (v in v["members"]) {
          if (v["name"] == loggedInUsername && v["locationShare"] == true) {
            locationflag = false;
          }
        };
      }
      );
    });
    if (locationflag == false) {
      final Map resstring = await getUsers();
      resstring.forEach((k, v) async {
        if (v.EmailId == loggedinUser) {
//         await httpClient.put(
//          'https://fir-trovami.firebaseio.com/users/${k}/location.json?',
//          body: result2);
        }
      });
    }
  }
