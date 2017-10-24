import 'package:flutter/material.dart';
import 'signuppage.dart';
import 'signinpage.dart';
import 'homepage.dart';
import 'groupdetails.dart';
import 'groupstatus.dart';
import 'showmap.dart';
List<PersonData> users=new List<PersonData>();
logindetails logindet = new logindetails();
groupDetails grpd=new groupDetails();

void main() {

  runApp(new MaterialApp(
    title: "LocatePal",
    home: new BaseLayout(),
    routes: <String, WidgetBuilder> {
      '/a': (BuildContext context) => new SignupLayout(),
      '/b': (BuildContext context) => new Homepagelayout(),
      '/c': (BuildContext context) => new addGroup(),
      '/d': (BuildContext context) => new groupstatuslayout(),
      '/e': (BuildContext context) => new showMap(),
      //'/f': (BuildContext context) => new zoomIn(),




    },
  ),
  );
}

class PersonData {
  PersonData({this.EmailId,this.password,this.name});
   String EmailId ;
  String password;
 String name;
}

class logindetails {
  String EmailId = '';
  String password = '';
  //String name = '';
}


class groupDetails {
  String groupname = '';
  List<PersonData> groupmember=new List<PersonData>();

}




