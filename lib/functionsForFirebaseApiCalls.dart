import 'package:firebase_database/firebase_database.dart';

final usrRef = FirebaseDatabase.instance.ref('users');
final groupsRef = FirebaseDatabase.instance.ref('groups');

getUsers() async {
  var snapshot = await usrRef.once();
  return snapshot.snapshot;
}

getUserById(id) async {
  var snapshot = await usrRef.child(id).once();
  return snapshot.snapshot;
}

getGroupsIamIn(userId) async {
  var snapshot = await usrRef.child(userId).child("groupsIamin").once();
  return snapshot.snapshot;
}

getGroups() async {
  var snapshot = await groupsRef.orderByKey().once();
  return snapshot.snapshot;
}

getAGroupAndAMember(groupKey, memberIndex) async {
  var snapshot = await groupsRef.child(groupKey).child("members").once();
  return snapshot.snapshot;
}

getGroupMembers(groupName) {}
