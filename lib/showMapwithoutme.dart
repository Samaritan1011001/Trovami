import 'main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'homepage.dart';
import 'dart:convert';
import 'dart:collection';
import 'package:flutter/services.dart';

import 'dart:async';
import 'groupstatus.dart';





class showMapwithoutme extends StatefulWidget {
  @override
  showMapwithoutmeState createState() => new showMapwithoutmeState();

}

class showMapwithoutmeState extends State<showMapwithoutme> {
  Image mapimage;
  Image zoominimage;
  Image zoomoutimage;
  bool currentWidget = true;
  Map<String,double> _currentLocation;




//  @override
//  initState() {
//    super.initState();
//    initPlatformState();
////    _locationSubscription =
////        _location.onLocationChanged.listen((Map<String,double> result) {
////          setState(() {
////            _currentLocation = result;
////          });
////        });
//  }




  // Platform messages are asynchronous, so we initialize in an async method.
//  initPlatformState() async {
//    Map<String,double> location;
//    // Platform messages may fail, so we use a try/catch PlatformException.
//
//
//
//    try {
//      location = await _location.getLocation;
//    } on PlatformException {
//      location = null;
//    }
//
//
//    // If the widget was removed from the tree while the asynchronous platform
//    // message was in flight, we want to discard the reply rather than calling
//    // setState to update our non-existent appearance.
//    if (!mounted)
//      return;
//    //_currentLocation = location;
//
//    setState(() {
//      print("location${location}");
//      _currentLocation = location;
//    });
//  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Map'),
        backgroundColor: Colors.transparent,
      ),
      body:

      new Stack(
        children: <Widget>[
          new Center(
            child: new CircularProgressIndicator(),
          ),
          //Zoom in Map Image for caching
//                    zoominimage=new Image.network(
//                    "https://maps.googleapis.com/maps/api/staticmap?center=${_currentLocation["latitude"]},${_currentLocation["longitude"]}&zoom=20&size=640x400&markers=color:red%7Clabel:C%7C${_currentLocation["latitude"]},${_currentLocation["longitude"]}&key=AIzaSyB88HqtHTTY3K8qjuPMhAzVaR4nWNqjkYk",
//                    fit: BoxFit.contain,
//                    ),
//                    zoomoutimage=new Image.network(
//                    "https://maps.googleapis.com/maps/api/staticmap?center=${_currentLocation["latitude"]},${_currentLocation["longitude"]}&zoom=14&size=640x400&markers=color:red%7Clabel:C%7C${_currentLocation["latitude"]},${_currentLocation["longitude"]}&key=AIzaSyB88HqtHTTY3K8qjuPMhAzVaR4nWNqjkYk",
//                    fit: BoxFit.contain,
//                    ),
          mapimage=new Image.network(
            "https://maps.googleapis.com/maps/api/staticmap?center=12.9121268,77.5982595&size=640x400&markers=color:red%7Clabel:C%7CElitaPromenade%7C12.9121268,77.5982595&scale=2&key=AIzaSyB88HqtHTTY3K8qjuPMhAzVaR4nWNqjkYk",
            fit: BoxFit.cover,
            gaplessPlayback: true,
            //height: 10.0,
          ),

          new Positioned(
            bottom: 16.0,
            right: 16.0,
            child: new Column(
              children: <Widget>[
                //Zoom in
                new Container(
                  color: Colors.black54,
                  child: new IconButton(
                    icon: new Icon(Icons.add),
                    color: Colors.white,
                    onPressed: () => zoomInMap(true),
                  ),
                ),
                new Divider(),
                //Zoom out
                new Container(
                  color: Colors.black54,
                  child: new IconButton(
                    icon: new Icon(Icons.remove),
                    color: Colors.white,
                    onPressed: () => zoomInMap(false),
                  ),
                ),
              ],
            ),
          ),
        ],fit: StackFit.expand,
      ),
    );

  }
  void zoomInMap(bool flag){
    if (flag==true){
      // Navigator.of(context).pushNamed('/f');
      print("true");
      setState(() {mapimage=zoominimage;});
    }
    else{
      setState((){mapimage=zoomoutimage;});

    }
  }

}



