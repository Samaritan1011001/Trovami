import 'package:flutter/widgets.dart';
import 'package:trovami/helpers/CloudFirebaseHelper.dart';

class LocationsManager extends ChangeNotifier{
  LocationsManager();

  //<editor-fold desc="DB Calls">
  static Stream getLocationsStream(List<String> friendIds){
    return CloudFirebaseHelper.getLocationsStream(friendIds);
  }
  //</editor-fold>
}
