import 'main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'homepage.dart';
import 'dart:convert';
import 'dart:collection';
import 'groupdetails.dart';

bool mapflag;

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
  bool switch1=false;
  var switch2;

  List<Widget> children=new List<Widget>();

  void onchange(bool value){
    print(value);
    if(value==true){
      setState(()=> switch1=true);
      mapflag=value;
      //Navigator.of(context).pushNamed('/e');
    }
    else{
      setState(()=> switch1=false);
      mapflag=value;
      //Navigator.of(context).pushNamed('/f');
    }
  }

  @override
  Widget build(BuildContext context) {
    children= new List.generate(members.length, (int i) => new memberlist(members[i].name));
if(switch2=="showme"){
  switch1=true;
}else{
  switch1=false;
}
    return new Scaffold( appBar: new AppBar(
        actions: <Widget>[
          new FlatButton(onPressed: (){
            if(mapflag==true){
              switch2="showme";
              Navigator.of(context).pushNamed('/e');

            }else{
              switch2="showwithoutme";
              Navigator.of(context).pushNamed('/f');

            }
          }, child: new Text("Show Map")),

        ],
          flexibleSpace: new FlexibleSpaceBar(
            title: new Text('Trovami'),

          ),
        ),

                  body :new Container(
                    child: new ListView(
                      children : <Widget> [
                        
                        
//                        new Chip(
//                          label: new Text("Share Live Location",
//                              style: new TextStyle(fontSize: 20.0)
//                          ),
//                          avatar: new CircleAvatar(
//                            child: new Switch(
//                                value: switch1,
//                                onChanged: onchange,
//
//                            ),
//                            backgroundColor: Colors.white,
//                          ),
//                          backgroundColor: Colors.white,
//                        ),
                          new Row(children :<Widget>[
                        new Container(child: new Text("Share Live Location:",style: new TextStyle(fontSize: 20.0)),
                            padding: new EdgeInsets.only( left:10.0),

                        ),
                        new Container(
                            child: new Switch(value: switch1, onChanged: onchange)
                        ),
      ],
    ),
      

      new Container(
        child: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new CircleAvatar(child:new Icon(Icons.group),
                  backgroundColor: Colors.brown[100],
                ),
                new Container(child:
                new Text(
                  "Group Name: ${grpd.groupname}",
                  style: new TextStyle(fontSize: 20.0),
                ),
                    padding: new EdgeInsets.only( left:20.0)

                ),
              ],
            ),
          ],
        ),
        padding: new EdgeInsets.only( left:10.0,top: 5.0,bottom: 5.0),
        decoration: new BoxDecoration(
          border: new Border(
            //top: new BorderSide(width: 16.0, color: Colors.brown[100]),
            bottom: new BorderSide(width: 1.0, color: Colors.brown[200],style: BorderStyle.solid),
          ),
        ),

      ),


                    new Container(
                      child:new Text("Members :",
                        style: new TextStyle(fontSize: 20.0),
                      ),
                        padding: new EdgeInsets.only( left:10.0,top: 10.0,bottom: 10.0),
                        decoration: new BoxDecoration(
                    border: new Border(
                    //top: new BorderSide(width: 16.0, color: Colors.brown[100]),
                    bottom: new BorderSide(width: 0.0, color: Colors.brown[200],style: BorderStyle.solid),
                    ),
                    ),
                    ),


                    new Column( children: children),


                    ],
                  ),
                    padding: new EdgeInsets.only(top:10.0),
                  ),



    );
  }

}