//import 'dart:async';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'main.dart';
//
//
//
//
//class UserAuth {
//  String statusMsg="Account Created Successfully";
//  //To create new User
//  Future<String> createUser(UserData userData) async{
//    print(userData.EmailId);
//    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//    await firebaseAuth
//        .createUserWithEmailAndPassword(
//        email: userData.EmailId, password: userData.password);
//    return statusMsg;
//  }
//
//  //To verify new User
//  Future<String> verifyUser (logindetails user) async{
//    print(user.EmailId);
//    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//    await firebaseAuth
//        .signInWithEmailAndPassword(email: user.EmailId, password: user.password);
//    return "Login Successfull";
//  }
//}