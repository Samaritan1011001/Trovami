import 'main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'groupdetails.dart';
import 'dart:async';
import 'signinpage.dart';


var temp=[];
String pagename='';
List<UserData> memberstoshow=new List<UserData>();
List<String> groupnamestoshow=new List<String>();
List<groupDetails> groupstoshaw=new List<groupDetails>();
groupDetails grps=new groupDetails();
const jsonCodec2=const JsonCodec(reviver: _reviver2);
List<UserData> memberstoshowhomepage=new List<UserData>();


var groupstatusgroupname='';

_reviver2(key,value) {

  if(key!=null&& value is Map){
    return new groupDetails.fromJson(value);
  }

  else
    return value;
}
class Homepagelayout extends StatefulWidget {
  @override
  homepagelayoutstate createState() => new homepagelayoutstate();
}

class homepagelayoutstate extends State<Homepagelayout>{
  @override
  Widget build(BuildContext context){
    return new Scaffold(
      body: new Container(
        child:new Homepage(),
      ),

    );
  }
}


class Homepage extends StatefulWidget{
  var membersflag=0;
  var groupsflag=0;
  @override
  homepagestate createState() => new homepagestate(groupsflag,membersflag);
}

class homepagestate extends State<Homepage>{
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  var membersflag;
  var groupsflag;
  List<Widget> homechildren=new List<Widget>();

  homepagestate(this.groupsflag,this.membersflag);



  Future<Null>   getgroups() async{
//loggedinuser="v@g.com";
//loggedinusername="var";
groupstoshaw=new List<groupDetails>();
String userkey;
    _refreshIndicatorKey.currentState?.show();
    var groupsiaminurl = 'https://fir-trovami.firebaseio.com/users.json?orderBy="\$key"';
    var response=await httpClient.get(groupsiaminurl);
    Map resstring=jsonCodec.decode(response.body);
    resstring.forEach((k,v){
      if(v.EmailId==loggedinuser) {
        userkey=k;
      }
    });
        var response2 = await httpClient.get(
            'https://fir-trovami.firebaseio.com/users/${userkey}/groupsIamin.json?');
            print(response2.body);
        groupnamestoshow = jsonCodec.decode(response2.body);
        print("groupnamestoshow:${groupnamestoshow}");


//    print("groupnamestoshow.length:${groupnamestoshow.length}");
//    for(var i=0;i<groupnamestoshow.length;i++){
//      grps=new groupDetails();
//      grps.groupname=groupnamestoshow[i];
//      print("grps.groupname:${grps.groupname}");
//      grps.groupmembers=
//null;
//    groupstoshaw.add(grps);
//    }

        setState(() {
          groupstoshaw = groupstoshaw;
        });
  }



  void addgroup(){
Navigator.of(context).pushNamed('/c');
  }
  @override
  void initState() {
    getgroups();
  }


  @override
  Widget build(BuildContext context) {


    if(groupnamestoshow!=null) {
      homechildren =
      new List.generate(groupnamestoshow.length, (int i) => new homechildrenlist(
          groupnamestoshow[i], membersflag));
    }else homechildren=new List<Widget>();
    return new Scaffold(
      appBar: new AppBar(
      leading: new Container(),
      actions: <Widget>[
        new IconButton(
          icon: new Icon(Icons.group_add), onPressed: addgroup,iconSize: 42.0,
        ),
        new IconButton(
          icon: new Icon(Icons.person), onPressed: () {
            showModalBottomSheet<Null>(context: context, builder: (BuildContext context) {
              return new Container(
                  child: new Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: new ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        children: <Widget>[
                          new Container(
                            child: new Text(
                              "User Details",
                              textAlign: TextAlign.center,
                            ),
                          ),
                          new Container(
                            child: new Text(
                              "Name:${logindet.EmailId}",
                              textAlign: TextAlign.center,
                          ),
                          ),
                          new Container(
                            child: new Text(
                              "EmailID:${logindet.EmailId}",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      )
                  )
              );
            });
          },
          iconSize: 35.0,),
      ],
      title: new Text('Trovami'),
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
  var membersflag;
  String groupname;
  homechildrenlist(this.groupname,this.membersflag);

  @override
  build(BuildContext context) {
   return new Container(
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
             child: new displaygroup(groupname,membersflag),
           ),
         ]
       ),
       onPressed: () {
         groupstatusgroupname = groupname;
         Navigator.of(context).pushNamed('/d');
       },
     ),
     decoration: new BoxDecoration(
       border: new Border(
         bottom: new BorderSide(width: 1.0, color: Colors.brown[200]),
       ),
     ),
   );
  }
}

  class displaygroup extends StatefulWidget {
    var membersflag;
    String groupname;

    displaygroup(this.groupname,this.membersflag);
    @override
    displaygroupstate createState() => new displaygroupstate(groupname,membersflag);
  }
class displaygroupstate extends State<displaygroup> {

    var membersflag;
    String groupname;

    displaygroupstate(this.groupname,this.membersflag);
    List<Widget> memchildren=new List<Widget>();
    getmembers(String groupname) async{
      memberstoshowhomepage=new List<UserData>();
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
      for (var i = 0; i < memcountt; i++) {
        var response1 = await httpClient.get(
            "https://fir-trovami.firebaseio.com/groups/${groupkey}/members/${i}.json");
        Map result1 = jsonCodec.decode(response1.body);
        UserData member=new UserData();
        member.name=result1["name"];
        print("result1[name]:${result1["name"]}");
        memberstoshowhomepage.add(member);
      }
//    setState(() {
//      memberstoshowhomepage = memberstoshowhomepage;
//    });
//      setState(() {
//        groupmemberstoshow = groupmemberstoshow;
//      });
      return memberstoshowhomepage;

    }
    @override
    void initState() {
      getmembers(groupname);

    }


  @override
  build(BuildContext context) {

    memchildren= new List.generate(1, (int i) => new memchildren1(""));
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Flexible(
          child: new Container(
          child: new Text(groupname,style: new TextStyle(fontWeight: FontWeight.bold),),
        ),
          fit: FlexFit.loose,
        ),
        new Container(
          child: new Row(children: memchildren),
          padding: new EdgeInsets.only(left:0.0,top: 3.0),
        )
      ],
      mainAxisSize: MainAxisSize.min,
    );
  }
}

class memchildren1 extends StatelessWidget {
  final String grpmem;
  memchildren1(this.grpmem);
  @override
  build(BuildContext context) {
    return new Text("${grpmem}",style: new TextStyle(fontWeight: FontWeight.normal),);
  }
}