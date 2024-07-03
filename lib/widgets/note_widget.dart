import 'package:flutter/material.dart';

import 'package:notes/DB/notes_db.dart';
import 'package:notes/pages/edit_page.dart';
import 'package:notes/shared.dart';

Widget note(Map note, int index, context, setState) {
  return InkWell(
    onLongPress: () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Delete Note"),
            content: const Text("Are you sure you want to delete this note?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  setState(() {
                    notesController.currentUserNotes.removeAt(index);
                    notesController.allUsersNotes
                        .removeWhere((element) => element['id'] == note['id']);
                  });
                  NotesSqlDB db = NotesSqlDB();
                  await db.initialDB();
                  await db.deleteData(note['id']).then((value) {
                    Navigator.pop(context);
                  });
                },
                child: const Text("Delete"),
              ),
            ],
          );
        },
      );
    },
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => EditPage(note),
        ),
      ).then((newNote) {
        if (newNote != null && newNote.toString().isNotEmpty) {
          setState(() {
            notesController.currentUserNotes.removeAt(index);
            notesController.currentUserNotes.insert(index, newNote);
            notesController.allUsersNotes.removeWhere((element) => element['id'] == newNote['id']);
            notesController.allUsersNotes.insert(index, newNote);
          });
        }
      });
    },
    child: Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 22, 82, 150),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
      child: Text(
        note["title"].toString(),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 30,
        ),
      ),
    ),
  );
}
