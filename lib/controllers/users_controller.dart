import 'package:shared_preferences/shared_preferences.dart';

import 'package:notes/DB/users_db.dart';
import 'package:notes/models/user.dart';

class UsersController {
  User currentUser = User(id: '', email: '', name: '', password: '', bio: '');
  List<User> users = [];

  UsersController() {
    getUsers();
  }

  Future<void> getUsers() async {
    UsersSqlDB db = UsersSqlDB();
    await db.initialDB();
    List<Map<String, dynamic>> usersFromDb = await db.readData();
    users = usersFromDb
        .map(
          (userMap) => User.fromMap(userMap),
        )
        .toList();
  }

  Future<void> updateUserData(User user) async {
    UsersSqlDB db = UsersSqlDB();
    await db.initialDB();
    Map<String, dynamic> userMap = {
      'id': user.id,
      'email': user.email,
      'name': user.name,
      'password': user.password,
      'bio': user.bio,
    };
    await db.updateData(userMap);
    await getUsers();
    currentUser = user;
  }

  void registerUser(User user) async {
    UsersSqlDB db = UsersSqlDB();
    await db.initialDB();
    await db.insertData({
      "id": user.id,
      "email": user.email,
      "name": user.name,
      "password": user.password,
      "bio": user.bio,
    });
    currentUser = user;
    saveUserId(user.id);
    await getUsers();
  }

  Future<bool> loadUserData() async {
    String id = await getUserId();
    if (id != '') {
      for (int i = 0; i < users.length; ++i) {
        if (id == users[i].id) {
          currentUser = users[i];
          saveUserId(users[i].id);
          await getUsers();
          return true;
        }
      }
    }
    return false;
  }

  Future<bool> validateLogin({email, password}) async {
    for (int i = 0; i < users.length; ++i) {
      if (users[i].email == email && users[i].password == password) {
        currentUser = users[i];
        saveUserId(users[i].id);
        getUsers();
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
    currentUser = User(id: '', email: '', name: '', password: '', bio: '');
  }
}
