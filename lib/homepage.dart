import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import 'UnitTests.dart';
import 'groupdetails.dart';
import 'helpers/RoutesHelper.dart';
import 'core/Group.dart';
import 'core/OldUser.dart';
import 'signinpage.dart';

var temp = [];
String pageName = '';
var groupStatusGroupname = '';
double animValue = 0.0;
List<OldUser> membersToShow = <OldUser>[];
List<String> groupNamesToShow = <String>[];
List<Group> groupsToShow = <Group>[];
Group grps = Group();
const jsonCodec2 = JsonCodec();
List<OldUser> membersToShowHomepage = <OldUser>[];
final groupref = FirebaseDatabase.instance.ref('groups');
final usrref = FirebaseDatabase.instance.ref('users');
DatabaseReference? reference;

class Homepagelayout extends StatelessWidget {
  final dynamic users;
  const Homepagelayout({super.key, this.users});
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Container(
      child: Homepage(users: users),
      width: screenSize.width,
      height: screenSize.height,
    );
  }
}

class GroupBox extends StatelessWidget {
  const GroupBox({
    super.key,
    this.snapshot,
    this.animation,
    this.index,
  });
  final DataSnapshot? snapshot;
  final Animation<double>? animation;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animation!, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 16.0, bottom: 16.0),
              child: CircleAvatar(
                child: IconButton(
                    icon: const Icon(Icons.group), onPressed: null),
                backgroundColor: const Color.fromRGBO(0, 0, 0, 0.2),
              ),
            ),
            TextButton(
                onPressed: () {
                  groupStatusGroupname =
                      (snapshot!.value as String?) ?? '';
                  RoutesHelper.pushRoute(context, ROUTE_GROUP);
                },
                child: Text(
                  (snapshot!.value as String?) ?? '',
                ))
          ],
        ),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
                width: 1.0,
                color: Color.fromRGBO(0, 0, 0, 0.2)),
          ),
        ),
      ),
    );
  }
}

class Homepage extends StatefulWidget {
  final dynamic users;
  const Homepage({super.key, this.users});
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<Homepage>
    with TickerProviderStateMixin {
  var userkey;

  getgroups() {
    groupsToShow = <Group>[];

    widget.users.value.forEach((k, v) {
      if (v["emailid"] == loggedinUser) {
        userkey = k;
      }
    });

    setState(() {
      reference = usrref.child(userkey).child("groupsIamin");
    });
  }

  @override
  void initState() {
    super.initState();
    getgroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Container(),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.group_add),
              onPressed: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        AddGroup(users: widget.users),
                  ),
                );
              },
              iconSize: 42.0,
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                final AnimationController controller =
                    AnimationController(
                        duration:
                            const Duration(milliseconds: 500),
                        vsync: this);
                // ignore: unused_local_variable
                final alpha = Tween(begin: 0.0, end: 255.0)
                    .animate(controller)
                  ..addListener(() {});
                controller.forward();
              },
              iconSize: 35.0,
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => handleMoreMenu(),
              iconSize: 35.0,
            ),
          ],
          title: const Text('Groups'),
        ),
        body: Column(children: <Widget>[
          Flexible(
            child: ((reference != null)
                ? FirebaseAnimatedList(
                    query: reference!,
                    sort: (a, b) =>
                        (b.key ?? '').compareTo(a.key ?? ''),
                    padding: const EdgeInsets.all(8.0),
                    reverse: false,
                    itemBuilder: (_, DataSnapshot snapshot,
                        Animation<double> animation, index) {
                      return GroupBox(
                        snapshot: snapshot,
                        animation: animation,
                        index: index,
                      );
                    },
                  )
                : Container()),
          ),
        ]));
  }

  handleMoreMenu() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UnitTests(),
      ),
    );
  }
}
