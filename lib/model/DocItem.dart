// Base class of all items stored in database
abstract class  DocItem {
  static const String FLD_ID    = "id";
  static const String FLD_NAME  = "name";

  String name;
  String id;

  fromMap(Map<String, Object> data);
  toJson();

  getName() {
    if (name == null) return "Unknown";
    return name;
  }
  setName(newName){
    name = newName;
  }
}