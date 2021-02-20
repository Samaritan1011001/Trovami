import 'package:firebase_auth/firebase_auth.dart';
import 'package:trovami/model/DocItem.dart';

import 'TrovUser.dart';

class Group2 extends DocItem{
  static const String FLD_MEMBERS    = "members";
  static const String FLD_OWNER     = "owner";

  List<String> members=[];
  String owner = "";

  Group2();

  Group2.fromJson(Map value){
    id=value[DocItem.FLD_ID];
    name=value[DocItem.FLD_NAME];
    members=value[FLD_MEMBERS];
  }

  Map toJson(){
    return {DocItem.FLD_ID: id, DocItem.FLD_NAME: name, FLD_OWNER: owner,
            FLD_MEMBERS:members};
  }

  @override
  Group2 fromMap(Map<String, Object> data) {
    Group2 group = Group2();
    group.id = data[DocItem.FLD_ID];
    group.name = data[DocItem.FLD_NAME];

    group.members = new List<String>();

    if ((data[FLD_MEMBERS] != null) && ( (data[FLD_MEMBERS] as List).length > 0)){
      for (String memberId in (data[FLD_MEMBERS] as List)) {
        group.members.add(memberId);
      }
    }
    return group;
  }

}
