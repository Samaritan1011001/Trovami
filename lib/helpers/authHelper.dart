import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trovami/helpers/CloudFirebaseHelper.dart';
import 'package:trovami/model/TrovUser.dart';

class UserAuthHelper {
  //To create new User
  void createUser(String email, String password) async {
    //  print(userData.EmailId);
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

//  //To verify new User
//  Future<String> verifyUser (logindetails user) async{
//    print(user.EmailId);
//    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//    await firebaseAuth
//        .signInWithEmailAndPassword(email: user.EmailId, password: user.password);
//    return "Login Successfull";
//  }
}
