import 'main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'homepage.dart';
import 'dart:convert';
import 'dart:collection';
import 'package:flutter/services.dart';

import 'package:location/location.dart';
import 'dart:async';





class showMap extends StatefulWidget {
  @override
  _showMapState createState() => new _showMapState();

}

class _showMapState extends State<showMap> {
  StreamSubscription<Map<String,double>> _locationSubscription;
  Location _location = new Location();
  Image mapimage;
  Image zoominimage;
  Image zoomoutimage;
  bool currentWidget = true;
  Map<String,double> _currentLocation;




  @override
  initState() {
    super.initState();
    initPlatformState();
    _locationSubscription =
        _location.onLocationChanged.listen((Map<String,double> result) {
          setState(() {
            _currentLocation = result;
          });
        });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    Map<String,double> location;
    // Platform messages may fail, so we use a try/catch PlatformException.



    try {
      location = await _location.getLocation;
    } on PlatformException {
      location = null;
    }


    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted)
      return;

    setState(() {
      print("location${location}");
      _currentLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("abc");
//    if(currentWidget){
//      image1 = new Image.network("https://maps.googleapis.com/maps/api/staticmap?center=${_currentLocation["latitude"]},${_currentLocation["longitude"]}&zoom=18&size=640x400&key=AIzaSyB88HqtHTTY3K8qjuPMhAzVaR4nWNqjkYk");
//      currentWidget = !currentWidget;
//    }else{
//      image2 = new Image.network("https://maps.googleapis.com/maps/api/staticmap?center=${_currentLocation["latitude"]},${_currentLocation["longitude"]}&zoom=18&size=640x400&key=AIzaSyB88HqtHTTY3K8qjuPMhAzVaR4nWNqjkYk");
//      currentWidget = !currentWidget;
//    }

    //Zoom out Map Image for caching


    return new Scaffold(
            appBar: new AppBar(
              title: new Text('Plugin example app'),
            ),
            body:
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Stack(
                  children: <Widget>[
                    new Center(
                      child: new CircularProgressIndicator(),
                    ),
                    //Zoom in Map Image for caching
                    zoominimage=new Image.network(
                    "https://maps.googleapis.com/maps/api/staticmap?center=${_currentLocation["latitude"]},${_currentLocation["longitude"]}&zoom=20&size=640x400&key=AIzaSyB88HqtHTTY3K8qjuPMhAzVaR4nWNqjkYk",
                    fit: BoxFit.contain,
                    ),
                    zoomoutimage=new Image.network(
                    "https://maps.googleapis.com/maps/api/staticmap?center=${_currentLocation["latitude"]},${_currentLocation["longitude"]}&zoom=14&size=640x400&key=AIzaSyB88HqtHTTY3K8qjuPMhAzVaR4nWNqjkYk",
                    fit: BoxFit.contain,
                    ),
                    //Map Image
                    mapimage=new Image.network(
                      "https://maps.googleapis.com/maps/api/staticmap?center=${_currentLocation["latitude"]},${_currentLocation["longitude"]}&zoom=16&size=640x400&key=AIzaSyB88HqtHTTY3K8qjuPMhAzVaR4nWNqjkYk",
                      fit: BoxFit.contain,
                      gaplessPlayback: true,
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
                  ],
                ),
                new Center(child:new Text('$_currentLocation\n')),
              ],
            )
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



