import 'package:cloud_firestore/cloud_firestore.dart';

import 'DocItem.dart';

class TrovLocation extends DocItem{
  static const String FLD_GEOPOINT         = "location";
  static const String FLD_TIMESTAMP        = "timestamp";

  GeoPoint geoPoint;
  Timestamp timestamp;

  TrovLocation();

  Map toJson(){
    return {DocItem.FLD_ID: id, FLD_GEOPOINT: geoPoint, FLD_TIMESTAMP: timestamp};
  }

  @override
  TrovLocation fromMap(Map<String, Object> data) {
    TrovLocation location = TrovLocation();
    location.id = data[DocItem.FLD_ID];
    location.geoPoint = data[FLD_GEOPOINT];
    location.timestamp = data[FLD_TIMESTAMP];
    return location;
  }

}

