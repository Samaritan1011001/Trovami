import 'package:flutter/material.dart';
import 'signuppage.dart';
import 'signinpage.dart';
import 'homepage.dart';
import 'groupdetails.dart';
import 'groupstatus.dart';
import 'showmap.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'showMapwithoutme.dart';



List<PersonData> users=new List<PersonData>();
logindetails logindet = new logindetails();
groupDetails grpd=new groupDetails();


final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.brown,
  accentColor: Colors.brown,
);

void main() {

  runApp(new MaterialApp(
    title: "Trovami",
    home: new BaseLayout(),
    theme: defaultTargetPlatform == TargetPlatform.iOS
        ? kIOSTheme
        : kDefaultTheme,
    routes: <String, WidgetBuilder> {
      '/a': (BuildContext context) => new SignupLayout(),
      '/b': (BuildContext context) => new Homepagelayout(),
      '/c': (BuildContext context) => new addGroup(),
      '/d': (BuildContext context) => new groupstatuslayout(),
      '/e': (BuildContext context) => new showMap(),
      '/f': (BuildContext context) => new showMapwithoutme(),

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




