import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();



  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  List<LatLng> polylines;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    polylines = decodePolyline("ytmcFh}chVAEGU?AAA?AA?AAA?E?");
    print("decoded s => ${polylines}");
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set()
          ..add(
            Marker(
              markerId: MarkerId("1"),
//              position: LatLng(37.43296265331129, -122.08832357078792),
              position: LatLng(37.43069, -122.08613),
              draggable: true,
            ),
          )
          ..add(
              Marker(
            markerId: MarkerId("2"),
            position: LatLng(37.42796133580664, -121.085749655962),
            draggable: true,
          )),
        polylines: Set()
          ..add(
              Polyline(
            polylineId: PolylineId("1"),
            width: 1,
            points: polylines
          )),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}

List<LatLng> decodePolyline(String encodedPolyline){
  final List<LatLng> poly = <LatLng>[];
  final int len = encodedPolyline.length;

  int index = 0;
  int lat = 0;
  int lng = 0;

  while (index < len) {
    int b, shift = 0, result = 0;
    do {
      b = encodedPolyline.codeUnits[index++] - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);

    final int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
    lat += dlat;

    shift = 0;
    result = 0;
    do {
      b = encodedPolyline.codeUnits[index++] - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);

    final int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
    lng += dlng;

    final LatLng p = new LatLng(lat / 1E5, lng / 1E5);
    poly.add(p);
  }

  return poly;
}