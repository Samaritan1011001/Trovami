class LocationModel {
  double? latitude;
  double? longitude;

  LocationModel({this.latitude, this.longitude});

  Map toJson() {
    return {"latitude": latitude, "longitude": longitude};
  }
}
