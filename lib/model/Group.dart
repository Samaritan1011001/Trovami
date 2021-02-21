import 'package:trovami/model/DocItem.dart';

class Group extends DocItem{
  static const String FLD_MEMBERS    = "members";
  static const String FLD_OWNER     = "owner";

  List<String> members=[];
  String owner = "";

  Group();

  Group.fromJson(Map value){
    id=value[DocItem.FLD_ID];
    name=value[DocItem.FLD_NAME];
    members=value[FLD_MEMBERS];
  }

  Map toJson(){
    return {DocItem.FLD_ID: id, DocItem.FLD_NAME: name, FLD_OWNER: owner,
            FLD_MEMBERS:members};
  }

  @override
  Group fromMap(Map<String, Object> data) {
    Group group = Group();
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
