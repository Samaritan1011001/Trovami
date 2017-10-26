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
              child: new Row(
                  children: <Widget>[
                    new Container(child:
                    new CircleAvatar(child: new IconButton(icon: new Icon(Icons.group), onPressed: null),
                    backgroundColor: Colors.brown[200],

                    ),
                        padding: new EdgeInsets.only( left:10.0)

                    ),
                    new Container(
                      child: new displaygroup(),
                    ),

                  ]
              ),
              decoration: new BoxDecoration(
              border: new Border(
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
  List<Widget> memchildren=new List<Widget>();

  @override
  build(BuildContext context) {
    memchildren= new List.generate(members.length, (int i) => new memchildren1(members[i].name));

    print(grpd.groupname);
          return new Column(
            children: <Widget>[
              new Container(
                child: new FlatButton(
                child: new Text(grpd.groupname),
                  onPressed: () {
                  Navigator.of(context).pushNamed('/d');
                  },
                ),
                padding: new EdgeInsets.only(bottom:0.0),

              ),
              new Container(
                  child: new Row(children: memchildren),
                padding: new EdgeInsets.only(left:20.0),

              )
            ],
          );
    }


  }

class memchildren1 extends StatelessWidget {
  final String grpmem;
  memchildren1(this.grpmem);
  @override
  build(BuildContext context) {
    return new Text("${grpmem},");
  }
}