import 'package:notes/DB/notes_db.dart';
import 'package:notes/models/note.dart';
import 'package:notes/shared.dart';

class NotesController {
  List<Note> currentUserNotes = [], allUsersNotes = [];

  NotesController() {
    getNotes();
  }

  Future<void> getNotes() async {
    NotesSqlDB db = NotesSqlDB();
    await db.initialDB();
    List<Map<String, dynamic>> usersFromDb = await db.readData();
    allUsersNotes = usersFromDb
        .map(
          (noteMap) => Note.fromMap(noteMap),
        )
        .toList();
    currentUserNotes = allUsersNotes.where((element) {
      return element.userId == usersController.currentUser.id;
    }).toList();
  }

  Future<void> addNote(Note note) async {
    NotesSqlDB db = NotesSqlDB();
    await db.initialDB();
    Map<String, dynamic> noteMap = {
      'id': note.id,
      'title': note.title,
      'body': note.body,
      'userId': note.userId,
    };
    await db.insertData(noteMap);
    await getNotes();
  }

  Future<void> updateNote(Note note) async {
    NotesSqlDB db = NotesSqlDB();
    await db.initialDB();
    Map<String, dynamic> noteMap = {
      'id': note.id,
      'title': note.title,
      'body': note.body,
      'userId': note.userId,
    };
    await db.updateData(noteMap);
    await getNotes();
  }

  Future<void> deleteNote(Note note) async {
    NotesSqlDB db = NotesSqlDB();
    await db.initialDB();
    await db.deleteData(note.id);
    await getNotes();
  }
}
