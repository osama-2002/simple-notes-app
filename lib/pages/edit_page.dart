import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notes/DB/notes_db.dart';
import 'package:notes/shared.dart';

// ignore: must_be_immutable
class EditPage extends StatefulWidget {
  Map note;
  EditPage({required this.note, super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  bool isNote = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  List colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.amber,
    Colors.purple,
  ];

  @override
  void initState() {
    if(widget.note.isNotEmpty) {
      isNote = true;
      titleController.text = widget.note['title']!;
      bodyController.text = widget.note['body']!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: isNote ? [
          IconButton(
            onPressed: () {
              setState(() {
                isNote = false;
              });
            },
            icon: const Icon(Icons.edit),
          ),
        ]:[
          IconButton(
            onPressed: () async {
                Map newNote = {
                  "title": titleController.text.toString(),
                  "body": bodyController.text.toString(),
                };
                NotesSqlDB db = NotesSqlDB();
                await db.initialDB();
                Map<String, dynamic> note = {
                  'title': titleController.text.toString(),
                  'body': bodyController.text.toString(),
                  'userId': userData['id'],
                };
                db.insertData(note).then((value) {
                  Navigator.pop(context, newNote);
                });
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: ListView(
        children: isNote ? [
          SizedBox(
            width: 100,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: colors[Random().nextInt(colors.length)],
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(20),
                child: Text(
                  widget.note["title"].toString(),
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
              color: colors[Random().nextInt(colors.length)],
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(20),
            child: Text(
              widget.note["body"].toString(),
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ] : [
          TextField(
            style: const TextStyle(
              color: Colors.white,
            ),
            controller: titleController,
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: "Enter Body",
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
