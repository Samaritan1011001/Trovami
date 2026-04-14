import 'package:trovami/core/OldUser.dart';

class Group {
  Group({this.groupname, this.groupmembers});
  String? groupname;
  List<OldUser>? groupmembers;

  Group.fromJson(Map value) {
    groupname = value["groupname"];
    groupmembers = value["members"];
  }

  Map toJson() {
    return {"groupname": groupname, "members": groupmembers};
  }
}
