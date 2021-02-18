import 'package:cloud_firestore/cloud_firestore.dart';
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
}
class CloudFirebaseHelper {
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
        })
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