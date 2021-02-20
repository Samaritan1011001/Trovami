import 'package:firebase_database/firebase_database.dart';

//var _httpClient = createHttpClient();
// const _jsonCodec=const JsonCodec(reviver: _reviver);
// const _jsonCodec2=const JsonCodec(reviver: _reviver2);

final usrRef = FirebaseDatabase.instance.reference().child('users');
final groupsRef = FirebaseDatabase.instance.reference().child('groups');

// _reviver( key, value) {
//   if(key!=null&& value is Map && key.contains('-')){
//     return new User.fromJson(value);
//   }
//   return value;
// }
//
// _reviver2(key,value) {
//   if(key!=null&& value is Map){
//     return new Group.fromJson(value);
//   } else
//     return value;
// }

getUsers() async {

  var docs= await usrRef.once();
  return docs;
//  HttpClientFireBase httpClient = new HttpClientFireBase();
//  var response= httpClient.get(url: 'https://trovami-bcd81.firebaseio.com/users.json');
////  Map usrmap=await _jsonCodec.decode(response);
//
//  return response;
}

getUserById(id)async{
  dynamic resp=await usrRef.child(id).once();
  print("user: ${resp.value}");
  return resp;
}

getGroupsIamIn(userId)async{
  return await usrRef.child(userId).child("groupsIamin").once();
}

getGroups()async{
//  groupsRef.
//  var url="https://fir-trovami.firebaseio.com/groups.json";
//  var response=await _httpClient.get(url);
//  return _jsonCodec2.decode(response.body);

  dynamic resp=await groupsRef.orderByKey().once();
  return resp;
}

getAGroupAndAMember(groupKey,memberIndex)async{
  return await groupsRef.child(groupKey).child("members").once();
}
getGroupMembers(groupName){

}
