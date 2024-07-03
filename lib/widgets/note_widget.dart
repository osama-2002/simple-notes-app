import 'package:flutter/material.dart';

import 'package:notes/DB/notes_db.dart';
import 'package:notes/models/note.dart';
import 'package:notes/pages/edit_page.dart';
import 'package:notes/shared.dart';

class NoteWidget extends StatefulWidget {
  const NoteWidget({super.key, required this.note, required this.index});
  final Note note;
  final int index;
  @override
  State<StatefulWidget> createState() {
    return _NoteWidgetState();
  }
}

class _NoteWidgetState extends State<NoteWidget> {
  @override
  Widget build(BuildContext context) {
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
                      notesController.currentUserNotes.removeAt(widget.index);
                      notesController.allUsersNotes.removeWhere(
                          (element) => element.id == widget.note.id);
                    });
                    NotesSqlDB db = NotesSqlDB();
                    await db.initialDB();
                    await db.deleteData(widget.note.id).then((value) {
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
            builder: (BuildContext context) => EditPage(widget.note),
          ),
        ).then((newNote) {
          if (newNote != null && newNote.toString().isNotEmpty) {
            setState(() {
              notesController.currentUserNotes.removeAt(widget.index);
              notesController.currentUserNotes.insert(widget.index, newNote);
              notesController.allUsersNotes
                  .removeWhere((element) => element.id == newNote['id']);
              notesController.allUsersNotes.insert(widget.index, newNote);
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
          widget.note.title.toString(),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}
