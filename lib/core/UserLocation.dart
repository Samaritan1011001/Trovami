class UserLocation {
  String? EmailId;
  Map<String, double>? currentLocation;
  UserLocation({this.EmailId, this.currentLocation});

  UserLocation.fromJson(Map value) {
    EmailId = value["emailid"];
    currentLocation = value["location"];
  }
}
