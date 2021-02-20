class UserLocation{
  String EmailId;
  Map<String,double> currentLocation; // TODO: Shouldn't this be map of Location objects?
  UserLocation({this.EmailId,this.currentLocation});

  UserLocation.fromJson(Map value){
    EmailId=value["emailid"];
//    print("value of members:${value["members"]}");
    currentLocation=value["location"];
  }
}
