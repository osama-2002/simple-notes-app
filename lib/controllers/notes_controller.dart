import 'package:notes/DB/notes_db.dart';
import 'package:notes/models/note.dart';
import 'package:notes/shared.dart';

class NotesController {
  List<Note> currentUserNotes = [], allUsersNotes = [];
  NotesController() {
    getNotes();
  }
  void getNotes() async {
    NotesSqlDB db = NotesSqlDB();
    await db.initialDB();
    List<Map<String, dynamic>> usersFromDb = await db.readData();
    allUsersNotes = usersFromDb.map((noteMap) => Note.fromMap(noteMap),).toList();
    currentUserNotes = allUsersNotes.where((element) {
      return element.userId == usersController.currentUser.id;
    }).toList();
  }
}
