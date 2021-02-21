import 'DocItem.dart';

class TrovUser extends DocItem{
  static const String FLD_EMAIL           = "email";
  static const String FLD_FRIENDS         = "friends";
  static const String FLD_SHARE_LOCATION  = "shareLocation";

  String email;
  List<String> friends;
  bool shareLocation;

  TrovUser();

  TrovUser.fromJson(Map value){
    id = value[DocItem.FLD_ID];
    name=value[DocItem.FLD_NAME];
    email=value[FLD_EMAIL];
    shareLocation=value[FLD_SHARE_LOCATION];
    friends=value[FLD_FRIENDS];
  }
   Map toJson(){
     return {DocItem.FLD_ID: id, DocItem.FLD_NAME: name, FLD_EMAIL: email,
             FLD_SHARE_LOCATION: shareLocation, friends: FLD_FRIENDS};
   }

  @override
  fromMap(Map<String, Object> data) {
    TrovUser user = TrovUser();
    user.id = data[DocItem.FLD_ID];
    user.name = data[DocItem.FLD_NAME];
    user.email = data[FLD_EMAIL];
    user.shareLocation = data[FLD_SHARE_LOCATION];
    user.friends = new List<String>();

    if ((data[FLD_FRIENDS] != null) && ( (data[FLD_FRIENDS] as List).length > 0)){
      for (String friendId in (data[FLD_FRIENDS] as List)) {
        user.friends.add(friendId);
      }
    }

    return user;
  }
}
