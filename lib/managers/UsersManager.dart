
// Singleton to manage Users
import 'package:trovami/model/User.dart';

class UsersManager {
//  Map _items = new LinkedHashMap<String, FileImage>();

  static final UsersManager _instance = new UsersManager._internal();

  factory UsersManager() {
    return _instance;
  }

  UsersManager._internal();

  List<User> users=new List<User>();

}
