import 'DocItem.dart';

class TrovUser extends DocItem{
  static const String FLD_EMAIL = "email";

  TrovUser();
   String email;

  TrovUser.fromJson(Map value){
    id = value[DocItem.FLD_ID];
    name=value[DocItem.FLD_NAME];
    email=value[FLD_EMAIL];
  }
   Map toJson(){
     return {DocItem.FLD_ID: id, DocItem.FLD_NAME: name, FLD_EMAIL: email};
   }

  @override
  fromMap(Map<String, Object> data) {
    TrovUser user = TrovUser();
    user.id = data[DocItem.FLD_ID];
    user.name = data[DocItem.FLD_NAME];
    user.email = data[FLD_EMAIL];
    return user;
  }
}
