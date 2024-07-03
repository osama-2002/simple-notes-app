import 'package:notes/DB/users_db.dart';
import 'package:notes/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersController {
  Map<String, dynamic> userData = {};
  List users = [];

  UsersController() {
    getUsers();
  }

  void getUsers() async {
    UsersSqlDB db = UsersSqlDB();
    await db.initialDB();
    users = await db.readData();
  }

  void updateUserData(Map<String, dynamic> updatedUserData) async {
    UsersSqlDB db = UsersSqlDB();
    await db.initialDB();
    await db.updateData(updatedUserData);
    userData = updatedUserData;
  }

  void registerUser(User user) async {
    UsersSqlDB db = UsersSqlDB();
    await db.initialDB();
    await db.insertData(userData);
    userData = {
      "id": user.id,
      "email": user.email,
      "name": user.name,
      "password": user.password,
      "bio": user.bio,
    };
    saveUserId(user.id);
  }

  Future<bool> loadUserData() async {
    String id = await getUserId();
    if (id != '') {
      for (int i = 0; i < users.length; ++i) {
        if (id == users[i]['id']) {
          userData = {
            "id": users[i]['id'],
            "email": users[i]['email'],
            "name": users[i]['name'],
            "password": users[i]['password'],
            "bio": users[i]['bio'],
          };
          saveUserId(users[i]['id']);
          return true;
        }
      }
    }
    return false;
  }

  Future<bool> validateLogin({email, password}) async {
    for (int i = 0; i < users.length; ++i) {
      if (users[i]['email'] == email && users[i]['password'] == password) {
        userData = {
          "id": users[i]['id'],
          "email": users[i]['email'],
          "name": users[i]['name'],
          "password": users[i]['password'],
          "bio": users[i]['bio'],
        };
        saveUserId(users[i]['id']);
        return true;
      }
    }
    return false;
  }

  void saveUserId(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("currentUserId", id);
  }

  Future<String> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("currentUserId") == null) return '';
    return prefs.getString("currentUserId")!;
  }

  void logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("currentUserId", '');
    userData = {};
  }
}
