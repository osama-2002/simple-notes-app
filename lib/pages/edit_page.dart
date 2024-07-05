import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:notes/pages/home_page.dart';
import 'package:notes/models/note.dart';
import 'package:notes/shared.dart';
import 'package:notes/theme/my_theme.dart' as my_theme;

var uuid = const Uuid();

class EditPage extends StatefulWidget {
  const EditPage(this.note, {super.key});
  final Note? note;

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  bool isNote = false, editMode = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      isNote = true;
      titleController.text = widget.note!.title;
      bodyController.text = widget.note!.body;
      editMode = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isNote
            ? const Text(
                "Edit",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )
            : const Text(
                "Add new Note",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
        actions: isNote
            ? [
                IconButton(
                  onPressed: () async {
                    setState(() {
                      isNote = false;
                      editMode = true;
                    });
                  },
                  icon: const Icon(Icons.edit),
                ),
              ]
            : [
                IconButton(
                  onPressed: () async {
                    if (editMode) {
                      await notesController.updateNote(Note(
                          id: widget.note!.id,
                          title: titleController.text.toString(),
                          body: bodyController.text.toString(),
                          userId: usersController.currentUser.id));
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const HomePage()));
                    } else {
                      await notesController.addNote(Note(
                          title: titleController.text.toString(),
                          body: bodyController.text.toString(),
                          userId: usersController.currentUser.id));
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const HomePage()));
                    }
                  },
                  icon: const Icon(Icons.save),
                ),
              ],
      ),
      body: ListView(
        children: isNote
            ? [
                SizedBox(
                  width: 100,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 22, 82, 150),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.all(20),
                      child: Text(
                        widget.note!.title.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: my_theme.foreGroundColor,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 22, 82, 150),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(20),
                  child: Text(
                    widget.note!.body.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      color: my_theme.foreGroundColor,
                    ),
                  ),
                ),
              ]
            : [
                const SizedBox(
                  height: 220,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    cursorColor: my_theme.foreGroundColor,
                    style: const TextStyle(
                      color: my_theme.foreGroundColor,
                    ),
                    controller: titleController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 255, 255, 255),
                      hintText: "Enter Title",
                      hintStyle: TextStyle(
                        color: my_theme.foreGroundColor,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    cursorColor: my_theme.foreGroundColor,
                    style: const TextStyle(
                      color: my_theme.foreGroundColor,
                    ),
                    controller: bodyController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 255, 255, 255),
                      hintText: "Enter Body",
                      hintStyle: TextStyle(
                        color: my_theme.foreGroundColor,
                      ),
                    ),
                  ),
                ),
              ],
      ),
    );
  }
}
