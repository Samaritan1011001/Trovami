import 'dart:convert';
import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
//import 'package:map_view/camera_position.dart';
//import 'package:map_view/location.dart';
//import 'package:map_view/map_options.dart';
//import 'package:map_view/map_view.dart';
//import 'package:map_view/marker.dart';
//import 'package:map_view/toolbar_action.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:trovami/screens/AddGroupScreen.dart';

import 'GroupDetailsScreen.dart';
import 'GroupsScreen.dart';
import '../helpers/httpClient.dart';
import '../main.dart';
import 'SignInScreen.dart';
import '../helpers/functionsForFirebaseApiCalls.dart';

class HomeScreen extends StatefulWidget {
  List currentLocations = [];
  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{
  }; // CLASS MEMBER, MAP OF MARKS
  var initialLocation = LatLng(30.274143, -97.740669);

//  Map<MarkerId, Marker> _add(locData) {
//     final MarkerId markerId = MarkerId(markerIdVal);
//
//     // creating a new MARKER
//     final Marker marker = Marker(
//       markerId: markerId,
//       position: LatLng(
//         locData["latitude"],
//         locData["longitude"],
//       ),
//       infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
//       onTap: () {
// //        _onMarkerTapped(markerId);
//       },
//     );

  // adding a new marker to map
  // markers[markerId] = marker;
  // return markers;
//  }

//  StreamSubscription _getChangesSubscription;

  @override
  void initState() {
  }

  @override
  void dispose() {
//    _getChangesSubscription?.cancel();
//    print("Groups listener disposed");
//    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body:
      GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: initialLocation,
          zoom: 14.4746,

        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set<Marker>.of(markers.values),
      ),
    );
  }
}
