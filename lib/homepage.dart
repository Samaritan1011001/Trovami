import 'main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';
import 'groupdetails.dart';

//final List groupdisplayarray=[];
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
  @override
  homepagestate createState() => new homepagestate();
}

class homepagestate extends State<Homepage>{
  void addgroup(){
    Navigator.of(context).pushNamed('/c');
  }



  @override
  Widget build(BuildContext context) {
  return new CustomScrollView(
    slivers: <Widget>[
      new SliverAppBar(
        leading: new Container(),
        pinned: true,
        expandedHeight: 50.0,
        //floating: true,
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.group_add), onPressed: addgroup,iconSize: 42.0,),
          new IconButton(icon: new Icon(Icons.person), onPressed: () {
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
                              //style: new TextStyle(fontFamily:'Nexa',fontSize: 50.0)
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
        flexibleSpace: new FlexibleSpaceBar(
          title: new Text('Trovami'),
          //background: ,
          //centerTitle: true,

        ),
      ),
      new SliverFixedExtentList(
        itemExtent: 80.0,
        delegate: new SliverChildBuilderDelegate(
              (BuildContext context,int index) {
                print(grpd.groupname);
            return new Container(
              alignment: Alignment.center,
              //color: Colors.black,
              child: new Row(children: <Widget>[
                new IconButton(icon: new Icon(Icons.group), onPressed: null),
                new Container(
                child: new displaygroup(),

                ),
                ]),decoration: new BoxDecoration(
              border: new Border(
                //top: new BorderSide(width: 16.0, color: Colors.brown[100]),
                bottom: new BorderSide(width: 1.0, color: Colors.brown[200]),
              ),
            ),
            );
          },
          childCount: 1,
        ),
      ),
    ],
  );



  }
  }

  class displaygroup extends StatefulWidget{

  @override
  displaygroupstate createState() => new displaygroupstate();


}


class displaygroupstate extends State<displaygroup>{
  @override
  build(BuildContext context) {
      print(grpd.groupname);
          return new Container(
            child: new FlatButton(
                child: new Text(grpd.groupname),
              onPressed: () {
                Navigator.of(context).pushNamed('/d');
              },
              //color: Colors.black,
            ),

          );
    }


  }
