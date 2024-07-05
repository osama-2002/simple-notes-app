import 'package:flutter/material.dart';

import 'package:notes/models/note.dart';
import 'package:notes/pages/edit_page.dart';
import 'package:notes/pages/home_page.dart';
import 'package:notes/shared.dart';
import 'package:notes/theme/my_theme.dart' as my_theme;

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
                    await notesController.deleteNote(widget.note);

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const HomePage()));
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
        );
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
            color: my_theme.foreGroundColor,
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}
