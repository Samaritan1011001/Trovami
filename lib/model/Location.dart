class Location{
  double latitude;
  double longitude;

  Location({this.latitude, this.longitude});

  Map toJson(){
    return {"latitude":latitude,"longitude":longitude};
  }

}

