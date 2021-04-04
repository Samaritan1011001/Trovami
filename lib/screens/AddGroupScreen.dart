import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:trovami/managers/ProfileManager.dart';
import 'package:trovami/model/TrovUser.dart';

import '../Strings.dart';
import '../widgets/InputTextField.dart';
import '../managers/ThemeManager.dart';

class AddGroupScreen extends StatefulWidget {
  AddGroupScreen();
  @override
  AddGroupScreenState createState() => new AddGroupScreenState();
}

class AddGroupScreenState extends State<AddGroupScreen>{
  AddGroupScreenState();
  final GlobalKey<ScaffoldState> _scaffoldKeySecondary1 = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _groupformKey = new GlobalKey<FormState>();

  List<Widget> children1=new List<Widget>();
  List<String> selectedIds=[];

  void showInSnackBar(String value) {
    _scaffoldKeySecondary1.currentState.showSnackBar(
        new SnackBar(
            content: new Text(value)
        )
    );
  }

  String checkifnotnull(String value){
    if(value.isEmpty) {
      return 'Groupname must not be empty';
    }
    return null;
  }

   _handleSubmitted() async {
//      var httpClient = HttpClientFireBase();
    final FormState form = _groupformKey.currentState;
    form.save();
   Navigator.of(context).pop();
  }

  void _select(String friendId) {
    setState(() {
      print("Trovami.AddGroupToScreen: New member selected");
    });
  }

  void toggleSelection(String id) {
    setState(() {
      if (selectedIds.contains(id)) {
        selectedIds.remove(id);
      } else {
        selectedIds.add(id);
      }
    });
  }

  @override
  void initState();

  @override
  Widget build(BuildContext context) {

    ProfileManager profileMgr = Provider.of<ProfileManager>(context);

    if(profileMgr.profile.friends.isNotEmpty) {
      children1 = List.generate(profileMgr.profile.friends.length,
                               (int i) => FriendRow(context, profileMgr.profile.friends[i], selectedIds.contains(profileMgr.profile.friends[i]), toggleSelection));
    }

    return new Scaffold(
      key: _scaffoldKeySecondary1,
      body: new Form(
        autovalidate: true,
          key: _groupformKey,
          child: new ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              new Container(
                child: new Container(
                  child: new Text(Strings.addGroup,
                    style: ThemeManager().getStyle(STYLE_TITLE),
                    textAlign: TextAlign.center,
                  ),
                  padding: const EdgeInsets.only(bottom:20.0),
                ),
                padding: const EdgeInsets.only(top:50.0),
                decoration: new BoxDecoration(
                  border: new Border(
                    bottom: new BorderSide(width: 0.0, color: Colors.brown[200]),
                  ),
                ),
              ),
              // Group Name
              Container(
                child: new Container(
                  child: new InputField(
                    hintText: "Groupname",
                    obscureText: false,
                    textInputType: TextInputType.text,
                    textStyle: ThemeManager().getStyle(STYLE_TEXT_EDIT),
                    textFieldColor: ThemeManager().getStyle(COLOR_TEXT_FIELD),
                    icon: Icons.group,
                    validateFunction: checkifnotnull,
                    iconColor: Colors.grey,
                    bottomMargin: 20.0,
                    onSaved: (String value) {
                      // GroupsManager().currentGroup().groupname=value;
                      // GroupsManager().currentGroup().groupmembers=new List<TrovUser>();
                      print("Trovami.AddGroupScreen: SAVE GROUP NOT IMPLEMENTED");
                    }
                  ),
                  padding: const EdgeInsets.only( bottom:15.0, top:0.0,right: 20.0),
                ),
                  padding: const EdgeInsets.only( top:30.0)
              ),
              // Select Friends instructions
              Center(child:
                Text(Strings.selectFriendsForGroup,style: ThemeManager().getStyle(STYLE_NORMAL)),
              ),
              SizedBox(height:20.0),
              Column(
                children:children1,
              ),
              SizedBox(height:20.0),
              // Submit/Cancel buttons
              Row(children: <Widget>[
                  Spacer(),
                  FloatingActionButton(
                    heroTag: "tag1",
                    onPressed: _handleSubmitted,
                    child: Icon(Icons.check),
                  ),
                  SizedBox(width: 40.0),
                  FloatingActionButton(
                    heroTag: "tag2",
                    onPressed: (){
  //                      RoutesHelper.pushRoute(context, ROUTE_GROUP_DETAILS);
                      Navigator.of(context).pop();
                    },
                    child: new Icon(Icons.clear),
                  ),
                Spacer(),
              ],
              ),
            ],
          ),
        ),
      );
    }
  }

class FriendRow extends StatelessWidget {
  ProfileManager profileMgr;
  final friendId;
  final selectedCallback;
  var friendData;
  var isSelected;

  FriendRow(BuildContext context, this.friendId, this.isSelected, this.selectedCallback){
    profileMgr = Provider.of<ProfileManager>(context);
    friendData = profileMgr.getFriendData(friendId);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        selectedCallback(friendId);
      },
      child: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  child: new Icon(Icons.person),
                  backgroundColor: const Color.fromRGBO(0, 0, 0, 0.2),
                ),
                Container(child:
                Text(friendData.name, style: TextStyle(fontSize: 20.0),),
                    padding: EdgeInsets.only(left: 20.0)
                ),
              ],
            ),
          ],
        ),
        padding: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
        decoration: BoxDecoration(
          color: isSelected ? ThemeManager().getColor(COLOR_PRIMARY) : ThemeManager().getColor(COLOR_CANVAS),
          border: Border(bottom: BorderSide(color: const Color.fromRGBO(0, 0, 0, 0.2),),
          ),
        ),
      ),
    );
  }
}
