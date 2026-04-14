import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trovami/homepage.dart';
import 'package:trovami/httpClient/httpClient.dart';

import 'InputTextField.dart';
import 'managers/GroupsManager.dart';
import 'core/Group.dart';
import 'core/OldUser.dart';
import 'signinpage.dart';
import 'functionsForFirebaseApiCalls.dart';

var Json = const JsonCodec();
var groupName = "";
Color textFieldColor = const Color.fromRGBO(0, 0, 0, 0.2);
const jsonCodec = JsonCodec(reviver: _reviver);
const jsonCodec1 = JsonCodec(reviver: _reviver1);

TextStyle textStyle = const TextStyle(
    color: Color.fromRGBO(0, 0, 0, 0.9),
    fontSize: 16.0,
    fontWeight: FontWeight.normal);

ThemeData appTheme = ThemeData(
  hintColor: Colors.white,
);

_reviver(key, value) {
  if (key != null && value is Map && key.contains('-')) {
    return OldUser.fromJson(value);
  }
  return value;
}

_reviver1(key, value) {
  if (key != null && value is Map && key.contains('-')) {
    return Group.fromJson(value);
  }
  return value;
}

class AddGroup extends StatefulWidget {
  final dynamic users;
  const AddGroup({super.key, this.users});
  @override
  AddGroupstate createState() => AddGroupstate();
}

class AddGroupstate extends State<AddGroup> {
  final GlobalKey<ScaffoldState> _scaffoldKeySecondary1 =
      GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _groupformKey = GlobalKey<FormState>();

  // ignore: unused_field
  bool _autovalidate1 = false;
  List<OldUser> userstoShowGrpDetailsPage = <OldUser>[];
  List<Widget> children1 = <Widget>[];
  List<OldUser> members = [];
  int count = 0;

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(value)));
  }

  String? checkifnotnull(String? value) {
    if (value == null || value.isEmpty) {
      return 'Groupname must not be empty';
    }
    return null;
  }

  _handleSubmitted() async {
    var httpClient = HttpClientFireBase();
    final FormState? form = _groupformKey.currentState;
    if (form == null) return;
    form.save();
    OldUser loggedInMember = OldUser();
    loggedInMember.EmailId = loggedinUser;
    loggedInMember.locationShare = false;
    for (var i = 0; i < members.length; i++) {
      GroupsManager().currentGroup().groupmembers ??= <OldUser>[];
      GroupsManager().currentGroup().groupmembers!.add(members[i]);
    }
    loggedInMember.name = loggedInUsername;
    GroupsManager().currentGroup().groupmembers ??= <OldUser>[];
    GroupsManager().currentGroup().groupmembers!.add(loggedInMember);
    for (var i = 0;
        i < (GroupsManager().currentGroup().groupmembers?.length ?? 0);
        i++) {
      widget.users.value.forEach((k, v) async {
        if (v["emailid"] ==
            GroupsManager().currentGroup().groupmembers![i].EmailId) {
          if (v["groupsIamin"] == null) {
            List<String> groupsIamin = [];
            groupsIamin
                .add(GroupsManager().currentGroup().groupname ?? '');
            var groupsIaminjson = jsonCodec.encode(groupsIamin);
            await httpClient.put(
                url:
                    'https://trovami-bcd81.firebaseio.com/users/$k/groupsIamin.json?',
                body: groupsIaminjson);
          } else {
            var response2 = await getUserById(k);

            List resmap = [];
            resmap.addAll(response2.value["groupsIamin"]);

            resmap.add(
                GroupsManager().currentGroup().groupname ?? '');
            var groupsIaminjson = jsonCodec.encode(resmap);
            // ignore: unused_local_variable
            var response1 = await httpClient.put(
                url:
                    'https://trovami-bcd81.firebaseio.com/users/$k/groupsIamin.json?',
                body: groupsIaminjson);
          }
        }
      });
    }
    var groupjson =
        jsonCodec1.encode(GroupsManager().currentGroup());
    var url = "https://trovami-bcd81.firebaseio.com/groups.json";
    await httpClient.post(url: url, body: groupjson);
    Navigator.of(context).pop();
  }

  void _select(OldUser user) {
    members.add(user);
    for (var i = 0; i < userstoShowGrpDetailsPage.length; i++) {
      if (userstoShowGrpDetailsPage[i].EmailId == user.EmailId) {
        userstoShowGrpDetailsPage.removeAt(i);
      }
    }
    setState(() {
      userstoShowGrpDetailsPage = userstoShowGrpDetailsPage;
      count = count + 1;
    });
  }

  getusers() {
    widget.users.value.forEach((k, v) {
      OldUser usertoshow = OldUser();
      usertoshow.name = v["name"];
      usertoshow.EmailId = v["emailid"];
      usertoshow.locationShare = false;
      if (usertoshow.EmailId == loggedinUser) {
        // skip logged in user
      } else {
        userstoShowGrpDetailsPage.add(usertoshow);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getusers();
  }

  @override
  Widget build(BuildContext context) {
    if (members.isNotEmpty) {
      children1 = List.generate(
          count, (int i) => MemberListItem(members[i].name ?? ''));
    }

    return Scaffold(
      key: _scaffoldKeySecondary1,
      body: Form(
        autovalidateMode: AutovalidateMode.always,
        key: _groupformKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: <Widget>[
            Container(
              child: Container(
                child: const Text(
                  "Add a Group",
                  style: TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                padding: const EdgeInsets.only(bottom: 20.0),
              ),
              padding: const EdgeInsets.only(top: 50.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      width: 0.0, color: Colors.brown[200]!),
                ),
              ),
            ),
            Container(
                child: Container(
                  child: InputField(
                      hintText: "Groupname",
                      obscureText: false,
                      textInputType: TextInputType.text,
                      textStyle: textStyle,
                      textFieldColor: textFieldColor,
                      icon: Icons.group,
                      validateFunction: checkifnotnull,
                      iconColor: Colors.grey,
                      bottomMargin: 20.0,
                      onSaved: (String? value) {
                        GroupsManager().currentGroup().groupname =
                            value;
                        GroupsManager().currentGroup().groupmembers =
                            <OldUser>[];
                      }),
                  padding: const EdgeInsets.only(
                      bottom: 15.0, top: 0.0, right: 20.0),
                ),
                padding: const EdgeInsets.only(top: 30.0)),
            Row(
              children: <Widget>[
                Container(
                    child: const Text(
                      "Add a member:",
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                    padding: const EdgeInsets.only(left: 13.0)),
                Container(
                    child: CircleAvatar(
                      child: PopupMenuButton<OldUser>(
                          icon: const Icon(Icons.add),
                          onSelected: _select,
                          itemBuilder: (BuildContext context) =>
                              userstoShowGrpDetailsPage
                                  .map((OldUser usertoshow) =>
                                      PopupMenuItem<OldUser>(
                                        value: usertoshow,
                                        child: Text(
                                            usertoshow.name ?? ''),
                                      ))
                                  .toList()),
                      backgroundColor:
                          const Color.fromRGBO(0, 0, 0, 0.2),
                    ),
                    padding: const EdgeInsets.only(left: 50.0)),
              ],
            ),
            Column(
              children: children1,
            ),
            Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.bottomCenter,
                  child: FloatingActionButton(
                    onPressed: _handleSubmitted,
                    child: const Icon(Icons.check),
                  ),
                  padding:
                      const EdgeInsets.only(top: 50.0, left: 100.0),
                ),
                Container(
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) =>
                              Homepage(users: widget.users),
                        ),
                      );
                    },
                    child: const Icon(Icons.clear),
                    heroTag: null,
                  ),
                  padding:
                      const EdgeInsets.only(top: 50.0, left: 50.0),
                ),
              ],
            ),
          ],
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
