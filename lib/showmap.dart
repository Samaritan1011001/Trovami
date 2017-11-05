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

  Map<String,double> _currentLocation;
  StreamSubscription<Map<String,double>> _locationSubscription;
  Location _location = new Location();

  bool currentWidget = true;

  Image image1;
  Image image2;



Image mapimage;
  Image zoominimage;
  Image zoomoutimage;





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




  initPlatformState() async {
    Map<String,double> location;


    try {
      location = await _location.getLocation;
    } on PlatformException {
      location = null;
    }

    if (!mounted)
      return;
      _currentLocation = location;

    setState(() {
      print("location${location}");
      _currentLocation = location;
    });
  }

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
//                    mapimage=
                    new Image.network(
                      "https://maps.googleapis.com/maps/api/staticmap?center=${_currentLocation["latitude"]},${_currentLocation["longitude"]}&size=640x400&markers=color:red%7Clabel:C%7C${_currentLocation["latitude"]},${_currentLocation["longitude"]}&scale=2&key=AIzaSyB88HqtHTTY3K8qjuPMhAzVaR4nWNqjkYk",
                      fit: BoxFit.cover,
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
                              onPressed:null,
                            ),
                          ),
                          new Divider(),
                          //Zoom out
                          new Container(
                            color: Colors.black54,
                            child: new IconButton(
                              icon: new Icon(Icons.remove),
                              color: Colors.white,
                              onPressed: null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],fit: StackFit.expand,
            ),
        );

  }
//  void zoomInMap(bool flag){
//    if (flag==true){
//      // Navigator.of(context).pushNamed('/f');
//      print("true");
//      setState(() {mapimage=zoominimage;});
//    }
//    else{
//      setState((){mapimage=zoomoutimage;});
//
//    }
//  }

}



