import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:trovami/helpers/CloudFirebaseHelper.dart';
import 'package:trovami/managers/LocationsManager.dart';
import 'package:trovami/managers/ProfileManager.dart';
import 'package:trovami/model/TrovLocation.dart';
import 'package:trovami/model/TrovUser.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  var initialLocation = LatLng(30.274143, -97.740669); // TODO: Use device current location

  @override
  void initState();

  @override
  void dispose() {
   super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TrovUser profile = Provider.of<ProfileManager>(context).profile;

    return StreamBuilder<QuerySnapshot>(
          stream: LocationsManager.getLocationsStream(profile.friends),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            print("Building");
            var markerSet = _getMarkers(snapshot);
            if (mapController != null) {
              mapController.moveCamera(_getCameraUpdate());
            }
            return GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: initialLocation,
                zoom: 14.4746,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                mapController = controller;
              },
              markers: markerSet,
            );
        }
    );
  }
  _getMarkers(AsyncSnapshot<QuerySnapshot> querySnapshot) {

    if (querySnapshot.connectionState == ConnectionState.waiting) {
      return Set<Marker>();
    }

    for (DocumentSnapshot docSnapshot in querySnapshot.data.docs) {
      var location = TrovLocation().fromMap(docSnapshot.data());

      var marker = _getMarker(location.id, location);
      markers[marker.markerId] = marker;
    }
    return Set.of(markers.values);
  }
  _getMarker(String id, TrovLocation location){
    return Marker(
      markerId: MarkerId(id),
      position: LatLng(location.geoPoint.latitude,location.geoPoint.longitude,),
      infoWindow: InfoWindow(title: id, snippet: '*'),
      onTap: () {
//        _onMarkerTapped(markerId);
      },
    );}

  _getCameraUpdate() {
    if (markers.length == 0){
      return CameraUpdate.newLatLng(initialLocation);
    } else if (markers.length == 1){
      return CameraUpdate.newLatLng(markers.values.first.position);
    }

    var minLat = double.maxFinite;
    var maxLat = double.minPositive;
    var minLng = double.maxFinite;
    var maxLng = -1000.0; // double.minPositive;

    for (Marker marker in markers.values){
      minLat = min(minLat, marker.position.latitude);
      maxLat = max(maxLat, marker.position.latitude);
      minLng = min(minLng, marker.position.longitude);
      maxLng = max(maxLng, marker.position.longitude);
    }
    return CameraUpdate.newLatLngBounds(LatLngBounds(southwest: LatLng(minLat, minLng), northeast: LatLng(maxLat, maxLng)), 10.0);
  }

}

