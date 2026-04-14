import 'package:trovami/model/DocItem.dart';

class Group2 extends DocItem {
  static const String FLD_MEMBERS = "members";
  static const String FLD_OWNER = "owner";

  List<String> members = [];
  String owner = "";

  Group2();

  Group2.fromJson(Map value) {
    id = value[DocItem.FLD_ID] as String?;
    name = value[DocItem.FLD_NAME] as String?;
    members = (value[FLD_MEMBERS] as List?)?.cast<String>() ?? [];
  }

  @override
  Map toJson() {
    return {
      DocItem.FLD_ID: id,
      DocItem.FLD_NAME: name,
      FLD_OWNER: owner,
      FLD_MEMBERS: members
    };
  }

  @override
  Group2 fromMap(Map<String, Object> data) {
    Group2 group = Group2();
    group.id = data[DocItem.FLD_ID] as String?;
    group.name = data[DocItem.FLD_NAME] as String?;

    group.members = <String>[];

    if ((data[FLD_MEMBERS] != null) &&
        ((data[FLD_MEMBERS] as List).isNotEmpty)) {
      for (String memberId in (data[FLD_MEMBERS] as List).cast<String>()) {
        group.members.add(memberId);
      }
    }
    return group;
  }
}
