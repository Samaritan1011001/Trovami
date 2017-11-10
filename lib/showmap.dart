//import 'dart:async';
//
//import 'main.dart';
//
//import 'package:flutter/services.dart';
//
//import 'package:flutter/material.dart';
//import 'package:map_view/camera_position.dart';
//import 'package:map_view/location.dart';
//import 'package:map_view/map_options.dart';
//import 'package:map_view/map_view.dart';
//import 'package:map_view/marker.dart';
//import 'package:map_view/toolbar_action.dart';
//import 'dart:core';
//import 'signinpage.dart';
//import 'homepage.dart';
//import 'dart:convert';
//
//
//var httpClient = createHttpClient();
//const jsonCodec1=const JsonCodec(reviver: _reviver1);
//const jsonCodec=const JsonCodec(reviver: _reviver);
//bool locationShare;
//
//_reviver(key,value) {
//
//  if(key!=null&& value is Map) {
//    return new UserData.fromJson(value);
//  }
//  else
//    return value;
//}
//
//_reviver1(key,value) {
//
//  if(key!=null&& value is Map){
//    return new groupDetails.fromJson(value);
//  }
////  else if(key!=null&& value is Map && key.runtimeType==int){
////    return new UserData.fromJson(value);
////  }
//  else
//    return value;
//}
//
//
//getlocationShare() async {
//  var url = "https://fir-trovami.firebaseio.com/groups.json";
//  var response = await httpClient.get(url);
////  print("response:${response.body}");
//  Map groupresmap = jsonCodec1.decode(response.body);
//  groupresmap.forEach((k, v) async {
//    if (v.groupname == groupstatusgroupname) {
//      for (var i = 0; i < v.groupmembers.length; i++) {
//        var response1 = await httpClient.get(
//            "https://fir-trovami.firebaseio.com/groups/${k}/members/${i}.json");
////        print("response1:${response1.body}");
//        Map result1 = jsonCodec.decode(response1.body);
////      print(result1["emailid"]);
//        if (result1["emailid"] == loggedinuser) {
//          if (result1["locationShare"] == true) {
//            locationShare = true;
//          }
//          else
//            locationShare = false;
//        }
//        print("locationShae:${locationShare}");
//      }
//    }
//  });
//}
//
//class MyApp extends StatefulWidget {
//  @override
//  _MyAppState createState() => new _MyAppState();
//}
//
//class _MyAppState extends State<MyApp> {
//  MapView mapView = new MapView();
//  CameraPosition cameraPosition;
//  var compositeSubscription = new CompositeSubscription();
//
//  @override
//  initState() {
//    super.initState();
//    getlocationShare();
//    cameraPosition = new CameraPosition(new Location(0.0, 0.0), 0.0);
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return new MaterialApp(
//      home: new Scaffold(
//          appBar: new AppBar(
//            title: new Text('Map View Example'),
//          ),
//          body: new Column(
//            children: <Widget>[
//              new MaterialButton(
//                onPressed: showMap,
//                child: new Text("Show Map"),
//              ),
//              new Text(
//                  "Camera Position: ${cameraPosition.center.latitude}, ${cameraPosition.center.longitude}. Zoom: ${cameraPosition.zoom}"),
//            ],
//          )),
//    );
//  }
//
//  showMap() {
//    mapView.show(
//        new MapOptions(
//            showUserLocation: locationShare,
//            initialCameraPosition: new CameraPosition(
//                new Location(45.5235258, -122.6732493), 14.0),
//            title: "Recently Visited"),
//        toolbarActions: [new ToolbarAction("Close", 1)]);
//
//    var sub = mapView.onMapReady.listen((_) {
//      mapView.setMarkers(<Marker>[
//        new Marker("1", "Work", 45.523970, -122.663081, color: Colors.blue),
//        new Marker("2", "Nossa Familia Coffee", 45.528788, -122.684633),
//      ]);
//      mapView.addMarker(new Marker("3", "10 Barrel", 45.5259467, -122.687747,
//          color: Colors.purple));
//
//
//      mapView.zoomToFit(padding: 100);
//    });
//    compositeSubscription.add(sub);
//
//    sub = mapView.onLocationUpdated
//        .listen((location) => print("Location updated $location"));
//    compositeSubscription.add(sub);
//
//    sub = mapView.onTouchAnnotation
//        .listen((annotation) => print("annotation tapped"));
//    compositeSubscription.add(sub);
//
//    sub = mapView.onMapTapped
//        .listen((location) => print("Touched location $location"));
//    compositeSubscription.add(sub);
//
//    sub = mapView.onCameraChanged.listen((cameraPosition) =>
//        this.setState(() => this.cameraPosition = cameraPosition));
//    compositeSubscription.add(sub);
//
//    sub = mapView.onToolbarAction.listen((id) {
//      if (id == 1) {
//        _handleDismiss();
//      }
//    });
//    compositeSubscription.add(sub);
//  }
//
//  _handleDismiss() async {
//    double zoomLevel = await mapView.zoomLevel;
//    Location centerLocation = await mapView.centerLocation;
//    List<Marker> visibleAnnotations = await mapView.visibleAnnotations;
//    print("Zoom Level: $zoomLevel");
//    print("Center: $centerLocation");
//    print("Visible Annotation Count: ${visibleAnnotations.length}");
//    mapView.dismiss();
//    compositeSubscription.cancel();
//  }
//}
//
//class CompositeSubscription {
//  Set<StreamSubscription> _subscriptions = new Set();
//
//  void cancel() {
//    for (var n in this._subscriptions) {
//      n.cancel();
//    }
//    this._subscriptions = new Set();
//  }
//
//  void add(StreamSubscription subscription) {
//    this._subscriptions.add(subscription);
//  }
//
//  void addAll(Iterable<StreamSubscription> subs) {
//    _subscriptions.addAll(subs);
//  }
//
//  bool remove(StreamSubscription subscription) {
//    return this._subscriptions.remove(subscription);
//  }
//
//  bool contains(StreamSubscription subscription) {
//    return this._subscriptions.contains(subscription);
//  }
//
//  List<StreamSubscription> toList() {
//    return this._subscriptions.toList();
//  }
//}
//
//
//
//
//
//
//
//
//
//
//
////import 'main.dart';
////import 'package:flutter/material.dart';
////import 'package:flutter/rendering.dart';
////import 'homepage.dart';
////import 'dart:convert';
////import 'dart:core';
////
////import 'signinpage.dart';
////import 'groupstatus.dart';
////import 'dart:collection';
////import 'package:flutter/services.dart';
////import 'package:location/location.dart';
////
////import 'dart:async';
////
////const jsonCodec1=const JsonCodec(reviver: _reviver1);
////const jsonCodec=const JsonCodec(reviver: _reviver);
////
////final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
////new GlobalKey<RefreshIndicatorState>();
////
////_reviver(key,value) {
////
////  if(key!=null&& value is Map) {
////    return new UserData.fromJson(value);
////  }
////  else
////    return value;
////}
////
////
////_reviver1(key,value) {
////
////  if(key!=null&& value is Map){
////    return new groupDetails.fromJson(value);
////  }
//////  else if(key!=null&& value is Map && key.runtimeType==int){
//////    return new UserData.fromJson(value);
//////  }
////  else
////    return value;
////}
////
////class showMap extends StatefulWidget {
////  @override
////  _showMapState createState() => new _showMapState();
////
////}
////
////class _showMapState extends State<showMap> {
////  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
////  new GlobalKey<RefreshIndicatorState>();
////  Map<String,double> _currentLocation;
////  StreamSubscription<Map<String,double>> _locationSubscription;
////  Location _location = new Location();
////  bool currentWidget = true;
////  Image image1;
////  Image image2;
////bool locationsharestate;
////Image currentmap= new Image.asset("graphics/staticmap.gif",fit:BoxFit.fill, );
////  Image mapimage;
////  Image zoominimage;
////  Image zoomoutimage;
////
////  getlocsofmembers() async{
////    var httpClient = createHttpClient();
////    print(1);
////    String groupkey;
////    int memcount=0;
////    String userlockey;
////
////
////    var usersnurl = 'https://fir-trovami.firebaseio.com/users.json?orderBy="\$key"';
////    var userresponse = await httpClient.get(usersnurl);
////    Map resstring = jsonCodec.decode(userresponse.body);
////    var memberlocshared=[];
////    var url="https://fir-trovami.firebaseio.com/groups.json";
//////    _refreshIndicatorKey.currentState.show();
////    var response=await httpClient.get(url);
//////    print("response:${response.body}");
////    Map groupresmap=jsonCodec1.decode(response.body);
////    groupresmap.forEach((k,v) {
////      if(v.groupname==groupstatusgroupname) {
////        memcount=v.groupmembers.length;
////        print("groupstatusgroupname:${groupstatusgroupname}");
////       groupkey = k;
////      }
////    });
////    print("memcount:${memcount}");
////        for(var i=0;i<memcount;i++) {
////          var response1 = await httpClient.get(
////              "https://fir-trovami.firebaseio.com/groups/${groupkey}/members/${i}.json");
//////          print("response1:${response1.body}");
////          Map result1 = jsonCodec.decode(response1.body);
////          print(result1["emailid"]);
////          print(result1["locationShare"]);
//////          if(result1["emailid"]!=loggedinuser) {
////          if (result1["locationShare"] == true) {
//////            memberlocshared.add(i);
////            resstring.forEach((k, v) {
////              if (v.EmailId == result1["emailid"]) {
////                userlockey = k;
////              }
////            });
//////                  print("v.Emaild:${v.EmailId}");
////            var flag = 0;
////            var userlocresponse = await httpClient.get(
////                "https://fir-trovami.firebaseio.com/users/${userlockey}/location.json");
////            Map resmap1 = jsonCodec.decode(userlocresponse.body);
////            print("resmap1:${resmap1}");
////            for (var i = 0; i < currentLocations.length; i++) {
////              if (currentLocations[i].EmailId == result1["emailid"]) {
////                currentLoc currentLocation = new currentLoc();
////                currentLocation.EmailId = result1["emailid"];
////                currentLocation.currentLocation = resmap1;
////                currentLocations.removeAt(i);
////                currentLocations.add(currentLocation);
////                flag = 1;
////              }
////            }
////            print("flag:${flag}");
////            if (flag == 0) {
////              print(3);
////              currentLoc currentLocation = new currentLoc();
////              currentLocation.EmailId = result1["emailid"];
////              currentLocation.currentLocation = resmap1;
////              currentLocations.add(currentLocation);
////            }
////          } else {
////            for (var i = 0; i < currentLocations.length; i++) {
////              print(4);
////              if (currentLocations[i].EmailId == result1["emailid"]) {
////                currentLocations.removeAt(i);
////              }
////            }
////          }
////        }
////
//////          }
//////          else {
//////            print(2);
//////            if (result1["locationShare"] == true) {
//////              resstring.forEach((k, v) async {
//////                var flag=0;
//////                if (v.EmailId == loggedinuser) {
//////                  var response2 = await httpClient.get(
//////                      "https://fir-trovami.firebaseio.com/users/${k}/location.json");
//////                  Map resmap2 = jsonCodec.decode(response2.body);
//////                  if (resmap2 != null) {
//////                    for (var i = 0; i < currentLocations.length; i++) {
//////                      if (currentLocations[i].EmailId == loggedinuser) {
//////                        currentLoc currentLocation = new currentLoc();
//////                        currentLocation.EmailId = loggedinuser;
//////                        currentLocation.currentLocation = resmap2;
//////                        currentLocations.insert(i, currentLocation);
//////
//////                        flag = 1;
//////                      }
//////                    }
//////                    if (flag == 0) {
//////                      currentLoc currentLocation = new currentLoc();
//////                      currentLocation.EmailId = loggedinuser;
//////                      currentLocation.currentLocation = resmap2;
//////                      currentLocations.add(currentLocation);
//////                    }
//////                  }
//////                }
//////                else{
//////                  for (var i = 0; i < currentLocations.length; i++) {
//////                    if (currentLocations[i].EmailId == loggedinuser) {
//////                      currentLocations.removeAt(i);
//////                    }
//////                  }
//////                }
//////              });
//////            }
//////          }
////
////
////    for (var i = 0; i < currentLocations.length; i++) {
////      print("Currentlocations Emaild:${currentLocations[i].EmailId}");
////
////      print("Currentlocations:${currentLocations[i].currentLocation}");
////    }
////    String currmap=buildurl(currentLocations);
////        print("currmap:${currmap}");
////
////
////    setState(() {
////      print("currmap1:${currmap}");
////      if(currmap==null){
////        currentmap= new Image.asset("graphics/staticmap.gif",fit:BoxFit.fill, );
////      }else {
////        currentmap = new Image.network(
////          currmap,
////          fit: BoxFit.fill,
////          gaplessPlayback: true,
////        );
////      }
////    });
////
////
////    httpClient.close();
////
////
////  }
////
////
////
////@override
////initState() {
////  super.initState();
////  getlocsofmembers();
////
//////  initPlatformState();
////
////}
////
////
////
////
//////  initPlatformState() async {
//////    Map<String,double> location;
//////
//////
//////    try {
//////      location = await _location.getLocation;
//////    } on PlatformException {
//////      location = null;
//////    }
//////
//////    if (!mounted)
//////      return;
//////      _currentLocation = location;
//////
//////    setState(() {
//////      _currentLocation = location;
//////    });
//////  }
////
////  @override
////  Widget build(BuildContext context) {
////
//////return new Container();
////    return new Scaffold(
////            appBar: new AppBar(
////              title: new Text('Map'),
////              backgroundColor: Colors.transparent,
////            ),
////            body:
////
////                new Stack(
////                  children: <Widget>[
////                    new Center(
////                      child: new CircularProgressIndicator(),
////                    ),
//////                    //Zoom in Map Image for caching
////////                    zoominimage=new Image.network(
////////                    "https://maps.googleapis.com/maps/api/staticmap?center=${_currentLocation["latitude"]},${_currentLocation["longitude"]}&zoom=20&size=640x400&markers=color:red%7Clabel:C%7C${_currentLocation["latitude"]},${_currentLocation["longitude"]}&key=AIzaSyB88HqtHTTY3K8qjuPMhAzVaR4nWNqjkYk",
////////                    fit: BoxFit.contain,
////////                    ),
////////                    zoomoutimage=new Image.network(
////////                    "https://maps.googleapis.com/maps/api/staticmap?center=${_currentLocation["latitude"]},${_currentLocation["longitude"]}&zoom=14&size=640x400&markers=color:red%7Clabel:C%7C${_currentLocation["latitude"]},${_currentLocation["longitude"]}&key=AIzaSyB88HqtHTTY3K8qjuPMhAzVaR4nWNqjkYk",
////////                    fit: BoxFit.contain,
////////                    ),
////                    currentmap,
//////                    new Image.network(
//////                      currentmap,
//////                      fit: BoxFit.cover,
//////                      gaplessPlayback: true,
//////                    ),
////
////                    new Positioned(
////                      bottom: 16.0,
////                      right: 16.0,
////                      child: new Column(
////                        children: <Widget>[
////                          //Zoom in
////                          new Container(
////                            color: Colors.black54,
////                            child: new IconButton(
////                              icon: new Icon(Icons.add),
////                              color: Colors.white,
////                              onPressed:null,
////                            ),
////                          ),
////                          new Divider(),
////                          //Zoom out
////                          new Container(
////                            color: Colors.black54,
////                            child: new IconButton(
////                              icon: new Icon(Icons.remove),
////                              color: Colors.white,
////                              onPressed: null,
////                            ),
////                          ),
////                        ],
////                      ),
////                    ),
////                  ],fit: StackFit.expand,
////            ),
////        );
////
////  }
//////  void zoomInMap(bool flag){
//////    if (flag==true){
//////      // Navigator.of(context).pushNamed('/f');
//////      print("true");
//////      setState(() {mapimage=zoominimage;});
//////    }
//////    else{
//////      setState((){mapimage=zoomoutimage;});
//////
//////    }
//////  }
////
////}
////
////String buildurl(List<currentLoc> currentLocations) {
////  String mapimage1;
////  String mapimage;
////  print("currentLocations.length:${currentLocations.length}");
////if(currentLocations.length==0){
////  return null;
////}else {
////  for (var i = 0; i < currentLocations.length; i++) {
////    if (currentLocations[i].EmailId == loggedinuser) {
////      print("loggedinuser:${loggedinuser}");
////      print("currentLocations[i].EmailId: ${currentLocations[i].EmailId}");
////      mapimage = "https://maps.googleapis.com/maps/api/staticmap?"
////          "center=${currentLocations[i]
////          .currentLocation["latitude"]},${currentLocations[i]
////          .currentLocation["longitude"]}"
////          "&size=400x640&markers=color:red%7Clabel:C%7C${currentLocations[i]
////          .currentLocation["latitude"]},${currentLocations[i]
////          .currentLocation["longitude"]}";
////    }
////    else {
////      mapimage = "https://maps.googleapis.com/maps/api/staticmap?"
//////          "center=${currentLocations[i].currentLocation["latitude"]},${currentLocations[i].currentLocation["longitude"]}"
////          "size=400x640&markers=color:red%7Clabel:C%7C${currentLocations[i]
////          .currentLocation["latitude"]},${currentLocations[i]
////          .currentLocation["longitude"]}";
////    }
////  }
////  for (var j = 0; j < currentLocations.length; j++) {
////    if (currentLocations[j].EmailId == loggedinuser) {
//////            continue;
////
////    } else {
////      mapimage =
////      "${mapimage}" "&markers=color:red%7Clabel:C%7C${currentLocations[j]
////          .currentLocation["latitude"]},${currentLocations[j]
////          .currentLocation["longitude"]}";
////    }
////  }
////}
////  mapimage1="${mapimage}" "&scale=2&key=AIzaSyB88HqtHTTY3K8qjuPMhAzVaR4nWNqjkYk";
////
////  return mapimage1;
//////  print("mapimage1:${mapimage1}");
////}
////
////
////
