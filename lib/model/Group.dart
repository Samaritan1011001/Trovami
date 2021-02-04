import 'User.dart';

class Group {
  Group({this.groupname,this.groupmembers});
  String groupname = "";
  List<User> groupmembers=[];

  Group.fromJson(Map value){
    groupname=value["groupname"];
//    print("value of members:${value["members"]}");
    groupmembers=value["members"];

  }
  Map toJson(){
    return {"groupname": groupname,"members":groupmembers};
  }

}
