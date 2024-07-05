import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:notes/pages/home_page.dart';
import 'package:notes/models/note.dart';
import 'package:notes/shared.dart';

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
                    ),
                  ),
                ),
              ]
            : [
                TextField(
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  controller: titleController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: "Enter Title",
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                TextField(
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  controller: bodyController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: "Enter Body",
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
      ),
    );
  }
}
