import 'package:notes/DB/notes_db.dart';
import 'package:notes/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

void saveUserId(int id) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt("userId", id);
}

Future<int> getUserId() async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if(prefs.getInt("userId") == null) return 0;
  return prefs.getInt("userId")!;
}

void logout() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt("userId", 0);
}

void getNotes(setState) async {
  NotesSqlDB db = NotesSqlDB();
  await db.initialDB();
  db.readData().then((value) {
    for(int i=0; i<value.length; ++i) {
      if(value[i]['userId'] == userData['id']) {
        setState(() {
          notes.add(value[i]);
        });
      }
    }
  });
}
  
void getAllNotes(setState) async {
  NotesSqlDB db = NotesSqlDB();
  await db.initialDB();
  db.readData().then((value) {
    for(int i=0; i<value.length; ++i) {
      setState(() {
        allNotes.add(value[i]);
      });
    }
  });
}