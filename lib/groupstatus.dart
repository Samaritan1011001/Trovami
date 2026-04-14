import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'functionsForFirebaseApiCalls.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart' as loc;

import 'helpers/RoutesHelper.dart';
import 'homepage.dart';
import 'httpClient/httpClient.dart';
import 'core/Group.dart';
import 'core/OldUser.dart';
import 'core/UserLocation.dart';
import 'signinpage.dart';

final userref = FirebaseDatabase.instance.ref('users');
final groupref = FirebaseDatabase.instance.ref('groups');
const jsonCodec1 = JsonCodec(reviver: _reviver1);
const jsonCodec = JsonCodec(reviver: _reviver);
const locationJsonCodec = JsonCodec(reviver: _locationReviver);
List<loc.LocationData> currentLocations = <loc.LocationData>[];
bool? locationShare;
Timer? t1;
bool? mapflag;
var temp1 = [];
var length;
bool togglestate = false;

_reviver(key, value) {
  if (key != null && value is Map) {
    return OldUser.fromJson(value);
  } else {
    return value;
  }
}

_locationReviver(key, value) {
  if (key != null) {
    return UserLocation.fromJson(value);
  } else {
    return value;
  }
}

_reviver1(key, value) {
  if (key != null && value is Map) {
    return Group.fromJson(value);
  } else {
    return value;
  }
}

toggleMemberLocation(bool newValue) async {
  HttpClientFireBase httpClient = HttpClientFireBase();

  final DataSnapshot groupresmap = await getGroups();
  Map grps = groupresmap.value as Map;
  var location = loc.Location();
  Stream<loc.LocationData> locationStream = location.onLocationChanged;
  StreamSubscription? locationSub;
  grps.forEach((k, v) async {
    if (v["groupname"] == groupStatusGroupname) {
      for (var i = 0; i < v["members"].length; i++) {
        var response1 = await http.get(Uri.parse(
            "https://trovami-bcd81.firebaseio.com/groups/$k/members/$i.json"));
        Map result1 = jsonCodec.decode(response1.body);
        if (result1["emailid"] == loggedinUser) {
          if (result1["locationShare"] == true) {
            locationSub?.cancel();
            locationShare = false;
          } else {
            loc.LocationData? currLoc;

            try {
              currLoc = await location.getLocation();
              await updateDatabaseLocation(currLoc);
              locationSub = locationStream
                  .listen((loc.LocationData currentLocation) async {
                await updateDatabaseLocation(currentLocation);
              });
            } on PlatformException catch (e) {
              if (e.code == 'PERMISSION_DENIED') {
                print('Permission denied');
              }
              currLoc = null;
            }
            locationShare = true;
          }
          String result2 = jsonCodec.encode(locationShare);
          await httpClient.put(
              url:
                  "https://trovami-bcd81.firebaseio.com/groups/$k/members/$i/locationShare.json",
              body: result2);
        }
      }
    }
  });
}

updateDatabaseLocation(currLoc) async {
  HttpClientFireBase httpClient = HttpClientFireBase();

  var loggedInuserKey = "";
  var updatedLocation;
  String? locUpdated;
  DataSnapshot usersDataSnap = await getUsers();
  Map usersMap = usersDataSnap.value as Map;
  usersMap.forEach((k, v) {
    if (v["emailid"] == loggedinUser) {
      loggedInuserKey = k;
      updatedLocation = {
        "latitude": currLoc.latitude,
        "longitude": currLoc.longitude
      };
    }
  });
  if (loggedInuserKey != "") {
    locUpdated = jsonCodec.encode(updatedLocation);
    await httpClient.put(
        url:
            "https://trovami-bcd81.firebaseio.com/users/$loggedInuserKey/location.json",
        body: locUpdated);
  }
  final DataSnapshot groupresmap = await getGroups();
  Map grps = groupresmap.value as Map;

  grps.forEach((k, v) async {
    if (v["groupname"] == groupStatusGroupname) {
      for (var i = 0; i < v["members"].length; i++) {
        var response1 = await http.get(Uri.parse(
            "https://trovami-bcd81.firebaseio.com/groups/$k/members/$i.json"));
        Map result1 = jsonCodec.decode(response1.body);
        if (result1["emailid"] == loggedinUser) {
          if (result1["locationShare"] == true ||
              result1["location"] == null) {
            await httpClient.put(
                url:
                    "https://trovami-bcd81.firebaseio.com/groups/$k/members/$i/location.json",
                body: locUpdated);
          }
        }
      }
    }
  });
}

class GroupStatusLayout extends StatefulWidget {
  @override
  GroupStatusLayoutState createState() => GroupStatusLayoutState();
}

class GroupStatusLayoutState extends State<GroupStatusLayout> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          child: GroupStatus(),
        ),
      );
}

class GroupStatus extends StatefulWidget {
  @override
  GroupStatusState createState() => GroupStatusState();
}

class GroupStatusState extends State<GroupStatus> {
  var getMemFlag = 0;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKeySecondary2 =
      GlobalKey<ScaffoldState>();
  List<Widget> children = <Widget>[];
  List<String> memberstoShowHomepage1 = <String>[];

  getgrpmembers(String grpkey, int i) async {
    var response1 = await getAGroupAndAMember(grpkey, i);

    memberstoShowHomepage1.add(response1.value[i]["name"]);

    if (response1.value[i]["emailid"] == loggedinUser) {
      setState(() {
        togglestate = response1.value[i]["locationShare"] ?? false;
        locationShare = response1.value[i]["locationShare"];
      });
    }
  }

  Future<void> getmembers1() async {
    String? grpkey;
    var grpmemcount;

    _refreshIndicatorKey.currentState?.show();

    final dynamic groupresmap = await getGroups();

    groupresmap.value.forEach((k, v) {
      if (v["groupname"] == groupStatusGroupname) {
        grpkey = k;
        grpmemcount = v["members"].length;
      }
    });
    if (grpkey == null) return;
    for (var i = 0; i < grpmemcount; i++) {
      getgrpmembers(grpkey!, i);
    }
    setState(() {
      memberstoShowHomepage1 = memberstoShowHomepage1;
    });
  }

  List<String> dedup(List<String> list) {
    List<String> list1 = <String>[];
    Set seen = {};
    int unique = 0;
    for (int i = 0; i < list.length; i++) {
      String element = list[i];
      if (!seen.contains(element)) {
        seen.add(element);
        list1.insert(unique++, element);
      }
    }
    return list1;
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(value)));
  }

  @override
  void initState() {
    super.initState();
    getmembers1();
  }

  @override
  Widget build(BuildContext context) {
    children = List.generate(memberstoShowHomepage1.length,
        (int i) => MemberListItem(memberstoShowHomepage1[i]));
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: getmembers1,
      child: Scaffold(
        key: _scaffoldKeySecondary2,
        appBar: AppBar(
          leading: defaultTargetPlatform == TargetPlatform.iOS
              ? CupertinoButton(
                  child: const Icon(Icons.keyboard_backspace),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              : TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(Icons.keyboard_backspace)),
          actions: <Widget>[
            TextButton(
                onPressed: () async {
                  await Navigator.of(context)
                      .pushNamed(ROUTE_MAP);
                },
                child: const Text("Show Map")),
          ],
          flexibleSpace: const FlexibleSpaceBar(
            title: Text('Group Status'),
          ),
        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(10.0),
                color: Colors.red,
                height: 100,
                child: const Center(
                  child: Text(
                    "DO NOT USE REAL LOCATION",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
              Row(children: <Widget>[
                Container(
                  child: const Text("Share Live Location:",
                      style: TextStyle(fontSize: 20.0)),
                  padding: const EdgeInsets.only(left: 10.0),
                ),
                Container(
                  child: defaultTargetPlatform == TargetPlatform.iOS
                      ? CupertinoSwitch(
                          value: togglestate,
                          onChanged: (bool newValue) {
                            toggleMemberLocation(newValue);
                            setState(() {
                              togglestate = newValue;
                            });
                          },
                        )
                      : Switch(
                          value: togglestate,
                          onChanged: (bool newValue) {
                            toggleMemberLocation(newValue);
                            setState(() {
                              togglestate = newValue;
                            });
                          },
                        ),
                ),
              ]),
              Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const CircleAvatar(
                          child: Icon(Icons.group),
                          backgroundColor:
                              Color.fromRGBO(0, 0, 0, 0.2),
                        ),
                        Expanded(
                          child: Container(
                              child: Text(
                                "Group Name: $groupStatusGroupname",
                                style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              padding: const EdgeInsets.only(
                                  left: 20.0)),
                        ),
                      ],
                    ),
                  ],
                ),
                padding: const EdgeInsets.only(
                    left: 10.0, top: 5.0, bottom: 5.0),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        width: 1.0,
                        color: Color.fromRGBO(0, 0, 0, 0.2),
                        style: BorderStyle.solid),
                  ),
                ),
              ),
              Container(
                child: const Text(
                  "Members :",
                  style: TextStyle(fontSize: 20.0),
                ),
                padding: const EdgeInsets.only(
                    left: 10.0, top: 10.0, bottom: 10.0),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        width: 0.0,
                        color: Color.fromRGBO(0, 0, 0, 0.2),
                        style: BorderStyle.solid),
                  ),
                ),
              ),
              Column(children: children),
            ],
          ),
          padding: const EdgeInsets.only(top: 10.0),
        ),
      ),
    );
  }
}

class MemberListItem extends StatelessWidget {
  final String mem;
  const MemberListItem(this.mem, {super.key});

  @override
  Widget build(BuildContext context) => Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                const CircleAvatar(
                  child: Icon(Icons.person),
                  backgroundColor: Color.fromRGBO(0, 0, 0, 0.2),
                ),
                Container(
                    child: Text(
                      mem,
                      style: const TextStyle(fontSize: 20.0),
                    ),
                    padding: const EdgeInsets.only(left: 20.0)),
              ],
            ),
          ],
        ),
        padding: const EdgeInsets.only(
            left: 10.0, top: 5.0, bottom: 5.0),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 0.0,
              color: Color.fromRGBO(0, 0, 0, 0.2),
            ),
          ),
        ),
      );
}
