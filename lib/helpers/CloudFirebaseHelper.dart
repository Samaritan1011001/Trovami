import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trovami/managers/Groups2Manager.dart';
import 'package:trovami/model/DocItem.dart';

class FirebaseResponse {
  String error;
  Map<String, Object> docs;
  FirebaseResponse() {
    error = "";
    docs = Map<String, Object>();
  }
  String getError() {
    return error;
  }
  bool hasError() {
    return error.isNotEmpty;
  }
  FirebaseResponse setError(String msg){
    error = msg;
    return this;
  }
}
class CloudFirebaseHelper {
  static final CloudFirebaseHelper _instance = new CloudFirebaseHelper._internal();
  factory CloudFirebaseHelper() {
    return _instance;
  }
  CloudFirebaseHelper._internal();

  bool _initialized = false;
  bool _errorInitializing = false;

  // Define an async function to initialize FlutterFire
  Future<FirebaseResponse> assureFireBaseInitialized() async {
    if (_initialized) {
      return FirebaseResponse();
    }

    try {
      await Firebase.initializeApp().then ((FirebaseApp app) => {
        _initialized = true,
        print("CloudFirebaseHelper initialized")
      });
    } catch(e) {
      print("CloudFirebaseHelper.initializedApp encountered error");
      _errorInitializing = true;
      return FirebaseResponse().setError(e.toString());
    }
    return FirebaseResponse();
  }

  bool isInitialized() {
    return _initialized;
  }
  bool isReady() {
    return isInitialized() && !hasError();
  }
  bool hasError() {
    return _errorInitializing;
  }

  static Future postItem(DocItem item, String collectionName) async{
    CollectionReference collection = FirebaseFirestore.instance.collection(collectionName);
    return collection
        .add(item.toJson())
        .then((value) => {
      print("Item ${item.getName()} (${item.id}) added to cloud"),
      item.id = value.id,
      value.update(item.toJson()),
      print("Item ${item.getName()} (${item.id}) updated with id")
    })
        .catchError((error) => print("Failed to add ${item.getName()}: $error"));
  }

  static Future deleteItem(DocItem item, String collectionName) async {
    CollectionReference collection = FirebaseFirestore.instance.collection(collectionName);

    collection.doc(item.id)
        .delete()
        .then((value) => print("FirebaseHelper.deleteItem(): ${item.getName()} deleted"))
        .catchError((error) => print("Failed to delete ${item.getName()}: $error"));
  }

  static Future<FirebaseResponse> getItems(String collectionName, DocItem item) async{
    var response = FirebaseResponse();
    await FirebaseFirestore.instance
        .collection(collectionName)
        .get()
        .then((QuerySnapshot querySnapshot) => {
      querySnapshot.docs.forEach((doc) {
        response.docs.putIfAbsent(doc.id, () => item.fromMap(doc.data()));
      }),
      print("CloudFirebase.getItems() found ${querySnapshot.docs.length} items")
    })
        .catchError((error) => {
      print("Failed to fetch $collectionName: $error"),
      response.error = error.toString()
    });
    return response;
  }

  static Future updateItem(DocItem item, collectionName) async{
    if (item.id != null) {
      Map<String, dynamic> data = item.toJson();
      CollectionReference collection = FirebaseFirestore.instance.collection(collectionName);

      await FirebaseFirestore.instance.runTransaction((Transaction tx) async {
        print("calling updateData with ${item.id} ${item.getName()}");
        await collection.doc(item.id).update(data);
        print("Item ${item.getName()}(${item.id}) updated to cloud");
      });
      print("updateToCloud completed");
    }
  }
}