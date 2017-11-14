import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_database/firebase_database.dart';



import 'groupdetails.dart';
import 'main.dart';
import 'signinpage.dart';


var temp=[];
String pageName='';
var groupStatusGroupname='';
double animValue=0.0;
List<UserData> membersToShow=new List<UserData>();
List<String> groupNamesToShow=new List<String>();
List<groupDetails> groupsToShow=new List<groupDetails>();
groupDetails grps=new groupDetails();
const jsonCodec2=const JsonCodec(reviver: _reviver2);
List<UserData> membersToShowHomepage=new List<UserData>();
final groupref = FirebaseDatabase.instance.reference().child('groups');

  _reviver2(key,value) {
    if(key!=null&& value is Map){
      return new groupDetails.fromJson(value);
    } else
      return value;
  }


  class Homepagelayout extends StatefulWidget {
    @override
    homepagelayoutstate createState() => new homepagelayoutstate();
  }

  class homepagelayoutstate extends State<Homepagelayout>{
    @override
    Widget build(BuildContext context)=>
    new Scaffold(
      body: new Container(
        child:new Homepage(),
      ),
    );
  }

  class Homepage extends StatefulWidget{
    @override
    homepagestate createState() => new homepagestate();
  }

// ignore: mixin_inherits_from_not_object
  class homepagestate extends State<Homepage> with SingleTickerProviderStateMixin {
    final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
    new GlobalKey<RefreshIndicatorState>();
    List<Widget> homechildren=new List<Widget>();

    Future<Null>   getgroups() async{
  //loggedinuser="m@g.com";
  //loggedinusername="man";
      groupsToShow=new List<groupDetails>();
      String userkey;
       _refreshIndicatorKey.currentState?.show();
      var groupsiaminurl = 'https://fir-trovami.firebaseio.com/users.json?orderBy="\$key"';
      var response=await httpClient.get(groupsiaminurl);
      final Map resstring=jsonCodec.decode(response.body);
      resstring.forEach((k,v){
        if(v.EmailId==loggedinUser) {
          userkey=k;
        }
      });
      var response2 = await httpClient.get(
          'https://fir-trovami.firebaseio.com/users/${userkey}/groupsIamin.json?');
      groupNamesToShow = jsonCodec.decode(response2.body);

      setState(() {
        groupsToShow = groupsToShow;
      });
    }

    @override
    void initState() => getgroups();


    @override
    Widget build(BuildContext context) {
      if(groupNamesToShow!=null) {
        homechildren =
        new List.generate(groupNamesToShow.length, (int i) => new homechildrenlist(
            groupNamesToShow[i]));
      }else homechildren=new List<Widget>();

      return new Scaffold(
        appBar: new AppBar(
        leading: new Container(),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.group_add), onPressed: ()=>    Navigator.of(context).pushNamed('/c')
            ,iconSize: 42.0,
          ),
          new IconButton(
            icon: new Icon(Icons.person), onPressed:
              (){
              //TODO
  //              Animation<double> alpha;
  //
  //              final AnimationController controller = new AnimationController(
  //                  duration: const Duration(milliseconds: 500), vsync: this);
  //              alpha = new Tween(begin: 0.0, end: 255.0).animate(controller)
  //                ..addListener(() {
  //                  setState(() {
  //                    animValue=alpha.value;
  //                    // the state that has changed here is the animation object’s value
  //                  });
  //                });
  //              controller.forward();
              },
            iconSize: 35.0,),
        ],
          title: new Text('Groups'),
        ),
        body: new RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: getgroups,
          child: new ListView(
            children: homechildren,
          ),
        ),
      );
    }
  }


  class homechildrenlist extends StatelessWidget {
    String groupname;
    homechildrenlist(this.groupname);

    @override
    build(BuildContext context) =>
      new Container(
       child: new FlatButton(
         child: new Row(
           children: <Widget>[
             new Container(
               child: new CircleAvatar(child: new IconButton(
                icon: new Icon(Icons.group), onPressed: null),
                 backgroundColor: const Color.fromRGBO(0, 0, 0, 0.2),
               ),
               margin: const EdgeInsets.only(right: 16.0),
               padding: new EdgeInsets.only(top: 10.0,bottom: 10.0),
             ),
             new Container(
               child: new displaygroup(groupname),
             ),
           ]
         ),
         onPressed: () {
           groupStatusGroupname = groupname;
           Navigator.of(context).pushNamed('/d');
         },
       ),
       decoration: new BoxDecoration(
         border: new Border(
           bottom: new BorderSide(width: 1.0, color: const Color.fromRGBO(0, 0, 0, 0.2)),
         ),
       ),
    );
  }

  class displaygroup extends StatefulWidget {
      String groupname;
      displaygroup(this.groupname);
      @override
      displaygroupstate createState() => new displaygroupstate(groupname);
  }

  class displaygroupstate extends State<displaygroup> {
    String groupname;
    List<Widget> memchildren=new List<Widget>();
    displaygroupstate(this.groupname);


    getmembers(String groupname) async{
      membersToShowHomepage=new List<UserData>();
      String groupkey;
      var memcountt;
      var url="https://fir-trovami.firebaseio.com/groups.json";
      var response=await httpClient.get(url);
      Map groupresmap=jsonCodec2.decode(response.body);
      groupresmap.forEach((k,v) {
        if (v.groupname == groupname) {
          groupkey=k;
          memcountt=v.groupmembers.length;
        }
      });
      if(memcountt!=null) {
        for (var i = 0; i < memcountt; i++) {
          var response1 = await httpClient.get(
              'https://fir-trovami.firebaseio.com/groups/${groupkey}/members/${i}.json');
          final Map result1 = jsonCodec.decode(response1.body);
          UserData member = new UserData();
          member.name = result1["name"];
          print("result1[name]:${result1["name"]}");
          membersToShowHomepage.add(member);
        }
      }
      return membersToShowHomepage;
    }

    @override
    build(BuildContext context) =>
    new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //TODO: animate the user details
  //       new Center(
  //         child: new Container(
  //           margin: const EdgeInsets.symmetric(vertical: 10.0),
  //           height: animValue,
  //           width: animValue,
  //           child: const FlutterLogo(),
  //         ),
  //       ),
        new Container(
          child: new Text(groupname,style: new TextStyle(fontWeight: FontWeight.bold),),
        ),
      ],
      mainAxisSize: MainAxisSize.min,
    );
  }

