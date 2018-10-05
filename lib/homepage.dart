import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/services.dart';





import 'groupdetails.dart';
import 'main.dart';
import 'signinpage.dart';
import 'functionsForFirebaseApiCalls.dart';

var temp=[];
String pageName='';
var groupStatusGroupname='';
double animValue=0.0;
List<UserData> membersToShow=new List<UserData>();
List<String> groupNamesToShow=new List<String>();
List<groupDetails> groupsToShow=new List<groupDetails>();
groupDetails grps=new groupDetails();
const jsonCodec2=const JsonCodec();
List<UserData> membersToShowHomepage=new List<UserData>();
final groupref = FirebaseDatabase.instance.reference().child('groups');
final usrref = FirebaseDatabase.instance.reference().child('users');
//var _httpClient = createHttpClient();
const _jsonCodec=const JsonCodec(reviver: _reviver);
var reference;



bool _first=true;

_reviver( key, value) {
  if(key!=null&& value is Map && key.contains('-')){
    return new UserData.fromJson(value);
  }
  return value;
}




  class Homepagelayout extends StatelessWidget {
    dynamic users;
    Homepagelayout({this.users});
    @override
    Widget build(BuildContext context) {

      final Size screenSize = MediaQuery
          .of(context)
          .size;

      return
        new Scaffold(
          body: new Container(
            child: new Homepage(users:users),
            width: screenSize.width,
            height: screenSize.height,
          ),
        );
    }


  }

class groupBox extends StatelessWidget {
  groupBox({
    this.snapshot, this.animation,this.index
  });
  final DataSnapshot snapshot;
  final Animation animation;
  final int index;



  @override
  Widget build(BuildContext context) {
    print(snapshot.value);
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(
          parent: animation, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
        new Container(
        margin: const EdgeInsets.only(right: 16.0,bottom: 16.0),
        child: new CircleAvatar(child: new IconButton(
            icon: new Icon(Icons.group), onPressed: null),
          backgroundColor: const Color.fromRGBO(0, 0, 0, 0.2),
        ),
      ),
          new FlatButton(onPressed: () {
           groupStatusGroupname = snapshot.value;
           Navigator.of(context).pushNamed('/d');
         }, child: new Text(
            snapshot.value,))
        ],
      ),
        decoration: new BoxDecoration(
          border: new Border(
            bottom: new BorderSide(width: 1.0, color: const Color.fromRGBO(0, 0, 0, 0.2)),
          ),
        ),
    ),

    );
  }
}





  class Homepage extends StatefulWidget{
    dynamic users;
    Homepage({this.users});
    @override
    homepagestate createState() => new homepagestate(users:users);
  }

  class homepagestate extends State<Homepage> with TickerProviderStateMixin {
    dynamic users;
    var userkey;

    homepagestate({this.users});

    List<Widget> homechildren=new List<Widget>();


    getgroups() {
  //loggedinuser="m@g.com";
  //loggedinusername="man";

      print("init");
      groupsToShow=new List<groupDetails>();


//             _refreshIndicatorKey.currentState?.show();
        users.value.forEach((k,v){
          if(v["emailid"]==loggedinUser) {
            userkey=k;
          }
        });

      setState(()  {
        reference=  usrref.child(userkey).child("groupsIamin");
//        groupsToShow = groupsToShow;
        _first=true;
      });
    }

    @override
    void initState() => getgroups();




    @override
    Widget build(BuildContext context) {
      if(groupNamesToShow!=null) {
//        homechildren =
//        new List.generate(groupNamesToShow.length, (int i) => new homechildrenlist(
//            groupNamesToShow[i]));
      }else homechildren=new List<Widget>();

      return new Scaffold(
        appBar: new AppBar(
        leading: new Container(),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.group_add), onPressed: ()async{

            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => addGroup(users: users),
            ),);
              }
            ,iconSize: 42.0,
          ),
          new IconButton(
            icon: new Icon(Icons.person), onPressed:
              (){
              //TODO
                Animation<double> alpha;

                final AnimationController controller = new AnimationController(
                    duration: const Duration(milliseconds: 500), vsync: this);
                alpha = new Tween(begin: 0.0, end: 255.0).animate(controller)
                  ..addListener(() {
//                    _scaffoldkeyhomepage.currentState.setState(() {
//                      _first=false;
//
//                    });
//                    _scaffoldkeyhomepage.currentState.setState(() {
//                      animValue=alpha.value;
//
//                    });
                  });
                controller.forward();
              },
            iconSize: 35.0,),
        ],
          title: new Text('Groups'),
        ),
        body: new Column(children: <Widget>[
        new Flexible(
        child:
        ((reference!=null)?
        new FirebaseAnimatedList(                            //new
          query: reference,                                       //new
          sort: (a, b) => b.key.compareTo(a.key),                 //new
          padding: new EdgeInsets.all(8.0),                       //new
          reverse: false,                                          //new
          itemBuilder: (_, DataSnapshot snapshot, Animation<double> animation,index) {
            return new groupBox(
                snapshot: snapshot,
                animation: animation,
              index: index,
            );
          },

        ):
        new Container()),                                                        //new
      ),
      ])
      );
    }
  }


//  class homechildrenlist extends StatelessWidget {
//    String groupname;
//    homechildrenlist(this.groupname);
//
//    @override
//    build(BuildContext context) =>
//      new Container(
//       child: new FlatButton(
//         child: new Row(
//           children: <Widget>[
//             new Container(
//               child: new CircleAvatar(child: new IconButton(
//                icon: new Icon(Icons.group), onPressed: null),
//                 backgroundColor: const Color.fromRGBO(0, 0, 0, 0.2),
//               ),
//               margin: const EdgeInsets.only(right: 16.0),
//               padding: new EdgeInsets.only(top: 10.0,bottom: 10.0),
//             ),
//             new Container(
//               child: new displaygroup(groupname),
//             ),
//           ]
//         ),
//         onPressed: () {
//           groupStatusGroupname = groupname;
//           Navigator.of(context).pushNamed('/d');
//         },
//       ),
//       decoration: new BoxDecoration(
//         border: new Border(
//           bottom: new BorderSide(width: 1.0, color: const Color.fromRGBO(0, 0, 0, 0.2)),
//         ),
//       ),
//    );
//  }
//
//  class displaygroup extends StatefulWidget {
//      String groupname;
//      displaygroup(this.groupname);
//      @override
//      displaygroupstate createState() => new displaygroupstate(groupname);
//  }
//
//  class displaygroupstate extends State<displaygroup> {
//    String groupname;
//    List<Widget> memchildren=new List<Widget>();
//    displaygroupstate(this.groupname);
//
//
//    getmembers(String groupname) async{
//      membersToShowHomepage=new List<UserData>();
//      String groupkey;
//      var memcountt;
//
//      Map groupresmap=await getGroups();
//      groupresmap.forEach((k,v) {
//        if (v.groupname == groupname) {
//          groupkey=k;
//          memcountt=v.groupmembers.length;
//        }
//      });
//      if(memcountt!=null) {
//        for (var i = 0; i < memcountt; i++) {
//          var response1 = await httpClient.get(
//              'https://fir-trovami.firebaseio.com/groups/${groupkey}/members/${i}.json');
//          final Map result1 = jsonCodec.decode(response1.body);
//          UserData member = new UserData();
//          member.name = result1["name"];
//          print("result1[name]:${result1["name"]}");
//          membersToShowHomepage.add(member);
//        }
//      }
//      return membersToShowHomepage;
//    }
//
//    @override
//    build(BuildContext context) =>
//        new Column(children: <Widget>[
//        new Flexible(
//        child: new FirebaseAnimatedList(                            //new
//          query: reference,                                       //new
//          sort: (a, b) => b.key.compareTo(a.key),                 //new
//          padding: new EdgeInsets.all(8.0),                       //new
//          reverse: true,                                          //new
//          itemBuilder: (_, DataSnapshot snapshot, Animation<double> animation) { //new
//            return new ChatMessage(                               //new
//                snapshot: snapshot,                                 //new
//                animation: animation                                //new
//            );                                                    //new
//          },                                                      //new
//        ),                                                        //new
//    ),
//    ]);
////    new Column(
////      crossAxisAlignment: CrossAxisAlignment.start,
////      children: <Widget>[
////        //TODO: animate the user details
////  //       new Center(
////  //         child: new Container(
////  //           margin: const EdgeInsets.symmetric(vertical: 10.0),
////  //           height: animValue,
////  //           width: animValue,
////  //           child: const FlutterLogo(),
////  //         ),
////  //       ),
////        new Container(
////          child: new Text(groupname,style: new TextStyle(fontWeight: FontWeight.bold),),
////        ),
////      ],
////      mainAxisSize: MainAxisSize.min,
////    );
//  }
//
