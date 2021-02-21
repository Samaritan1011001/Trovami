import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trovami/model/DocItem.dart';

const String TABLE_GROUPS     = "groups";
const String TABLE_LOCATIONS  = "locations";
const String TABLE_USERS      = "users";

const String FIELD_ID         = "id";
const String FIELD_OWNER      = "owner";

class FirebaseResponse {
  String error;
  Map<String, Object> items;
  FirebaseResponse() {
    error = "";
    items = Map<String, Object>();
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

  // getItem() may be redundent.  Can use getItemsMatching for same purpose
  // getItem() assumes only 1 item returned and doesn't iterate through QuerySnapshots
  static Future<FirebaseResponse> getItem(String collectionName, String field, String value, DocItem item) async{
    var response = FirebaseResponse();
    await FirebaseFirestore.instance
        .collection(collectionName)
        .where(field, isEqualTo: value)
        .get()
        .then((QuerySnapshot querySnapshot) => {
          response.items.putIfAbsent(querySnapshot.docs.first.id, () => item.fromMap(querySnapshot.docs.first.data())),
          print("CloudFirebase.getItems() found ${querySnapshot.docs.length} items")
        })
        .catchError((error) => {
      print("Failed to fetch $collectionName: $error"),
      response.error = error.toString()
    });
    return response;
  }

  static Future<FirebaseResponse> getItemsMatching(String collectionName, String field, String value, DocItem item) async{
    var response = FirebaseResponse();
    await FirebaseFirestore.instance
        .collection(collectionName)
        .where(field, isEqualTo: value)
        .get()
        .then((QuerySnapshot querySnapshot) => {
          querySnapshot.docs.forEach((doc) {
          response.items.putIfAbsent(doc.id, () => item.fromMap(doc.data()));
      }),
      print("CloudFirebase.getItemsMatching() found ${querySnapshot.docs.length} items")
    })
        .catchError((error) => {
      print("Failed to fetch $collectionName: $error"),
      response.error = error.toString()
    });
    return response;
  }

  static Future<FirebaseResponse> getAllItems(String collectionName, DocItem item) async{
    var response = FirebaseResponse();
    await FirebaseFirestore.instance
        .collection(collectionName)
        .get()
        .then((QuerySnapshot querySnapshot) => {
          querySnapshot.docs.forEach((doc) {
          response.items.putIfAbsent(doc.id, () => item.fromMap(doc.data()));
        }),
      print("CloudFirebase.getItems() found ${querySnapshot.docs.length} items")
    })
        .catchError((error) => {
      print("Failed to fetch $collectionName: $error"),
      response.error = error.toString()
    });
    return response;
  }

  static Future<FirebaseResponse> getItemsArrayContains(String collectionName, String field, List list, DocItem item) async{
    var response = FirebaseResponse();
    await FirebaseFirestore.instance
        .collection(collectionName)
        .where(field, arrayContainsAny: list)
        .get()
        .then((QuerySnapshot querySnapshot) => {
          querySnapshot.docs.forEach((doc) {
          response.items.putIfAbsent(doc.id, () => item.fromMap(doc.data()));
      }),
      print("CloudFirebase.getItemsArrayContains() found ${querySnapshot.docs.length} items")
    })
        .catchError((error) => {
      print("Failed to fetch $collectionName: $error"),
      response.error = error.toString()
    });
    return response;
  }

  static Future<FirebaseResponse> getItemIdsArrayContains(String collectionName, String field, List list) async{
    var response = FirebaseResponse();
    await FirebaseFirestore.instance
        .collection(collectionName)
        .where(field, arrayContainsAny: list)
        .get()
        .then((QuerySnapshot querySnapshot) => {
          querySnapshot.docs.forEach((doc) {
          response.items.putIfAbsent(doc.id, () => doc.id);
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