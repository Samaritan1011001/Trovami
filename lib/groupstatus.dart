import 'main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'homepage.dart';
import 'dart:async';


var httpClient = createHttpClient();
const jsonCodec1=const JsonCodec(reviver: _reviver1);
bool mapflag;
var temp1=[];
var length;
bool togglestate=false;



_reviver1(key,value) {

  if(key!=null&& value is Map){
    return new groupDetails.fromJson(value);
  }
  return value;
}


 togglememberlocation(bool newValue) async{

  var url="https://fir-trovami.firebaseio.com/groups.json";
  var response=await httpClient.get(url);
  print("response:${response.body}");
  Map groupresmap=jsonCodec1.decode(response.body);
  groupresmap.forEach((k,v) async{
  });
}


Future<Null>   getmembers1() async{


}

class groupstatuslayout extends StatefulWidget {
  @override
  groupstatuslayoutstate createState() => new groupstatuslayoutstate();
}

class groupstatuslayoutstate extends State<groupstatuslayout>{






  @override
  Widget build(BuildContext context){
    return new Scaffold(
      body: new Container(
        child:new groupstatus(),
      ),

    );
  }
}


class groupstatus extends StatefulWidget {
  @override
  groupstatusstate createState() => new groupstatusstate();
}

class groupstatusstate extends State<groupstatus>{
  var getmemflag=0;
  bool switch1=false;
  var switch2;

  List<Widget> children=new List<Widget>();




  @override
  Widget build(BuildContext context) {

    if(getmemflag==0) {
      getmembers1();
      getmemflag=1;
    }
    children= new List.generate(temp1.length, (int i) => new memberlist(temp1[i]["name"]));
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
              Navigator.of(context).pushNamed('/e');
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
            new Row(children :<Widget>[
              new Container(child: new Text("Share Live Location:",style: new TextStyle(fontSize: 20.0)),
                padding: new EdgeInsets.only( left:10.0),
              ),
              new Container(
                  child: new Switch(value: togglestate, onChanged: (bool newValue) {
                    togglememberlocation(newValue);
                    setState(() {
                      togglestate = newValue;
                    });
                  },
                  )
              ),
            ],
            ),
            new Container(
              child: new Column(
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new CircleAvatar(
                        child:new Icon(Icons.group),
                        backgroundColor: const Color.fromRGBO(0, 0, 0, 0.2),
                      ),
                      new Container(child:
                      new Text(
                        "Group Name: ${groupstatusgroupname}",
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
                  bottom: new BorderSide(width: 1.0, color: const Color.fromRGBO(0, 0, 0, 0.2),style: BorderStyle.solid),
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
                  bottom: new BorderSide(width: 0.0, color: const Color.fromRGBO(0, 0, 0, 0.2),style: BorderStyle.solid),
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


class memberlist extends StatelessWidget {
  final String mem;
  memberlist(this.mem);

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Row(
            children: <Widget>[
              new CircleAvatar(
                child:new Icon(Icons.person),
                backgroundColor: const Color.fromRGBO(0, 0, 0, 0.2),
              ),
              new Container(child:
              new Text(
                "${mem}",
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
          bottom: new BorderSide(width: 0.0, color: const Color.fromRGBO(0, 0, 0, 0.2),),
        ),
      ),

    );


  }
}