import 'main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'homepage.dart';
import 'dart:convert';
import 'dart:collection';


class groupstatuslayout extends StatefulWidget {
  @override
  groupstatuslayoutstate createState() => new groupstatuslayoutstate();
}

class groupstatuslayoutstate extends State<groupstatuslayout>{
  @override
  Widget build(BuildContext context){
    return new Scaffold(
//      appBar: new AppBar(centerTitle: true,title: new Text("Trovami"),elevation: 0.0),
      body: new Container(
//        decoration: new BoxDecoration(
//          image: new DecorationImage(
//            image: new AssetImage("graphics/back.jpg"),
//            fit: BoxFit.cover,
//          ),
//        ),
        child:new groupstatus(),
        //color: Colors.brown,
      ),

    );
  }
}


class groupstatus extends StatefulWidget {
  @override
  groupstatusstate createState() => new groupstatusstate();
}

class groupstatusstate extends State<groupstatus>{

void mapLocation(){

}
  @override
  Widget build(BuildContext context) {

    return new Scaffold( body: new CustomScrollView(
      slivers: <Widget>[
        new SliverAppBar(
          pinned: true,
          expandedHeight: 50.0,
        actions: <Widget>[
          new FlatButton(onPressed: (){
            Navigator.of(context).pushNamed('/e');
          }, child: new Text("Show Map")),

        ],
          //floating: true,
          flexibleSpace: new FlexibleSpaceBar(
            title: new Text('Trovami'),

          ),
        ),
        new SliverFixedExtentList(
          itemExtent: 80.0,
          delegate: new SliverChildBuilderDelegate(
                (BuildContext context,int index) {
                  return new Container(
                    child:new Column( children: <Widget>[
                      new Text(
                          "Group Name: ${grpd.groupname}",
                          style: new TextStyle(color: Colors.black, fontSize: 20.0),
                          //textAlign: TextAlign.center,
                          //style: new TextStyle(fontFamily:'Nexa',fontSize: 50.0)
                        ),
                         new Text("Members:",
                           style: new TextStyle(color: Colors.black, fontSize: 20.0),

                           //"Acceptance:${grpd.groupmember.inviteStatus}",
                            //textAlign: TextAlign.center,
                         ),

                   ],
                  ),
                    padding: new EdgeInsets.only(top:30.0),
                  );
                },
            childCount: 1,
          ),
        ),
      ],
    ),
    );
  }

}