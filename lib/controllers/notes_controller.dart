import 'package:notes/DB/notes_db.dart';
import 'package:notes/shared.dart';

class NotesController {
  List currentUserNotes = [], allUsersNotes = [];
  NotesController() {
    getNotes();
  }
  void getNotes() async {
    NotesSqlDB db = NotesSqlDB();
    await db.initialDB();
    allUsersNotes = await db.readData();
    currentUserNotes = allUsersNotes.where((element) {
      return element['userId'] == usersController.userData['id'];
    }).toList();
  }
}
