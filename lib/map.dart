import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'homepage.dart';
import 'httpClient/httpClient.dart';
import 'functionsForFirebaseApiCalls.dart';

final userref = FirebaseDatabase.instance.ref('users');
final groupref = FirebaseDatabase.instance.ref('groups');
int? nouserflag;
var twenty;
var sec = const Duration(seconds: 1);
Timer? t2;

class MapSample extends StatefulWidget {
  const MapSample({super.key});
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  List currentLocations = [];

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Map<MarkerId, Marker> _add(locData) {
    var markerIdVal = locData["emailid"];
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        locData["latitude"],
        locData["longitude"],
      ),
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      onTap: () {},
    );

    markers[markerId] = marker;
    return markers;
  }

  StreamSubscription? _getChangesSubscription;

  @override
  void initState() {
    super.initState();
    listenTochanges();
  }

  @override
  void dispose() {
    _getChangesSubscription?.cancel();
    print("Groups listener disposed");
    super.dispose();
  }

  void listenTochanges() {
    print("Groups lister initialised");
    _getChangesSubscription =
        groupref.onChildChanged.listen((event) async {
      if (groupStatusGroupname ==
          (event.snapshot.value as Map?)?["groupname"]) {
        List<dynamic> groupMems =
            (event.snapshot.value as Map?)?["members"] ?? [];

        for (var grpmem in groupMems) {
          if (grpmem["locationShare"] == true) {
            for (var i = 0;
                i < currentLocations.length;
                i++) {
              if (currentLocations[i]["emailid"] ==
                  grpmem["emailid"]) {
                currentLocations[i] = {
                  "latitude": grpmem["location"]["latitude"],
                  "longitude": grpmem["location"]["longitude"],
                  "emailid": grpmem["emailid"]
                };
              }
            }
          }
        }
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getLocsOfMembers(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.data == null ||
                (snapshot.data as List).isEmpty) {
              return const Center(
                child: Text(
                    "No Live location sharing users, Go back and try again"),
              );
            } else {
              currentLocations.forEach((curr) {
                markers = _add(curr);
              });
              return GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(snapshot.data[0]["latitude"],
                      snapshot.data[0]["longitude"]),
                  zoom: 14.4746,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                markers: Set<Marker>.of(markers.values),
              );
            }
          }),
    );
  }

  Future getLocsOfMembers() async {
    // ignore: unused_local_variable
    HttpClientFireBase httpClient = HttpClientFireBase();
    String? groupkey;
    int memcount = 0;
    final DataSnapshot grps = await getGroups();
    Map groupresmap = grps.value as Map;
    groupresmap.forEach((k, v) {
      if (v["groupname"] == groupStatusGroupname) {
        memcount = v["members"].length;
        groupkey = k;
      }
    });
    if (groupkey == null) return currentLocations;
    for (var i = 0; i < memcount; i++) {
      var response1 = await http.get(Uri.parse(
          "https://trovami-bcd81.firebaseio.com/groups/$groupkey/members/$i.json"));
      Map result1 = jsonDecode(response1.body);
      if (result1["locationShare"] == true) {
        if (currentLocations.isEmpty) {
          currentLocations.add({
            "latitude": result1["location"]["latitude"],
            "longitude": result1["location"]["longitude"],
            "emailid": result1["emailid"]
          });
        } else {
          var flag = 0;
          for (var j = 0;
              j < currentLocations.length;
              j++) {
            if (currentLocations[j]["emailid"] ==
                result1["emailid"]) {
              flag = 1;
              currentLocations.removeAt(j);
              currentLocations.add({
                "latitude": result1["location"]["latitude"],
                "longitude": result1["location"]["longitude"],
                "emailid": result1["emailid"]
              });
            }
          }
          if (flag == 0) {
            currentLocations.add({
              "latitude": result1["location"]["latitude"],
              "longitude": result1["location"]["longitude"],
              "emailid": result1["emailid"]
            });
          }
        }
      } else {
        for (var j = 0;
            j < currentLocations.length;
            j++) {
          if (currentLocations[j]["emailid"] ==
              result1["emailid"]) {
            currentLocations.removeAt(j);
          }
        }
      }
    }

    return currentLocations;
  }
}
