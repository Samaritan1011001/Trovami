import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'groupdetails.dart';
import 'groupstatus.dart';
import 'homepage.dart';
import 'loadingindicator.dart';
import 'signinpage.dart';
import 'signuppage.dart';



var popflag=0;
List<UserData> users=new List<UserData>();
logindetails logindet = new logindetails();
groupDetails grpd=new groupDetails();


final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.blueGrey,
  accentColor: Colors.blueGrey,
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.blueGrey,
  accentColor: Colors.blueGrey,
);


void main() {
  defaultTargetPlatform == TargetPlatform.iOS
      ? MapView.setApiKey("AIzaSyCLw1SjRi8TLDu_Nzcdo2Ufu68H1UXl9BU")
      : MapView.setApiKey("AIzaSyB4xaxweIhP0F36ZCBpfeiDjpoPc741Oe0");

  runApp(new MaterialApp(
    title: "Trovami",
    home: new SignInForm(),
    theme: defaultTargetPlatform == TargetPlatform.iOS
        ? kIOSTheme
        : kDefaultTheme,
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {

          case '/a': return defaultTargetPlatform == TargetPlatform.iOS
              ? new CupertinoPageRoute(builder:  (_) => new SignupLayout(),settings: settings,)
              : new MyCustomRoute(
            builder: (_) => new SignupLayout(),
            settings: settings,
          );

          case '/b': return defaultTargetPlatform == TargetPlatform.iOS
              ? new CupertinoPageRoute(builder:  (_) => new Homepagelayout(),settings: settings,)
              :new MyCustomRoute(
            builder: (_) => new Homepagelayout(),
            settings: settings,
          );
          case '/c': return defaultTargetPlatform == TargetPlatform.iOS
              ? new CupertinoPageRoute(builder:  (_) => new addGroup(),settings: settings,)
              :new MyCustomRoute1(
            builder: (_) => new addGroup(),
            settings: settings,
          );
          case '/d': return defaultTargetPlatform == TargetPlatform.iOS
              ? new CupertinoPageRoute(builder:  (_) => new groupstatuslayout(),settings: settings,)
              :new MyCustomRoute1(
            builder: (_) => new groupstatuslayout(),
            settings: settings,
          );
          case '/g': return defaultTargetPlatform == TargetPlatform.iOS
              ? new CupertinoPageRoute(builder:  (_) => new loadingindlayout(),settings: settings,)
              :new MyCustomRoute1(
            builder: (_) => new loadingindlayout(),
            settings: settings,
          );
        }
        assert(false);
      }
  ),
  );
}

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({ WidgetBuilder builder, RouteSettings settings })
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    if (settings.isInitialRoute)
      return child;
    return new FadeTransition( opacity: animation, child: child);
  }
}

class MyCustomRoute1<T> extends MaterialPageRoute<T> {
  MyCustomRoute1({ WidgetBuilder builder, RouteSettings settings })
      : super(builder: builder, settings: settings);

  @override
  Widget TransitionBuilder(BuildContext context,
      Animation<Offset> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    if (settings.isInitialRoute)
      return child;
    return new SlideTransition( position: animation, child: child);
  }
}


class UserData {
  UserData({this.EmailId,this.password,this.name,this.locationShare,this.groupsIamin,this.location});
   String EmailId ;
   String password;
   String name;
   bool locationShare;
  Map<String,double> location=null;
   List<String> groupsIamin=[];


  UserData.fromJson(Map value){
    EmailId=value["emailid"];
    name=value["name"];
    locationShare=value["locationShare"];
    groupsIamin=value["groupsIamin"];
  }
   Map toJson(){
     return {"name": name,"locationShare": locationShare,"groupsIamin":groupsIamin,"emailid":EmailId,"location":location};
   }
}

class logindetails {
  logindetails({this.EmailId,this.password});
  String EmailId = '';
  String password = '';
  //String name = '';
}


class groupDetails {
  groupDetails({this.groupname,this.groupmembers});
  String groupname = "";
  List<UserData> groupmembers=[];

  groupDetails.fromJson(Map value){
    groupname=value["groupname"];
//    print("value of members:${value["members"]}");
      groupmembers=value["members"];

  }
  Map toJson(){
    return {"groupname": groupname,"members":groupmembers};
  }

}


class currentLoc{
  String EmailId;
  Map<String,double> currentLocation;
  currentLoc({this.EmailId,this.currentLocation});
}

class locationclass{
  double latitude;
  double longitude;

  locationclass({this.latitude, this.longitude});

  Map toJson(){
    return {"latitude":latitude,"longitude":longitude};
  }

}

