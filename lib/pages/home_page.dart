import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:notes/DB/notes_db.dart';
import 'package:notes/authentication/login.dart';
import 'package:notes/pages/edit_page.dart';
import 'package:notes/pages/profile_page.dart';
import 'package:notes/services/services.dart';
import 'package:notes/shared.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List notes = [], notesFound = [];
  List colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.amber,
    Colors.purple,
  ];
  bool searchMode = false;
  
  @override
  void initState() {
    getNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: searchMode ? const Text(
          "Search",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ) : const Text(
          "Notes",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
              (Route<dynamic> route) => false
            );
            logout();
          },
          icon: const Icon(Icons.logout),
        ),
        actions: searchMode ? [
          IconButton(
            onPressed: (){
              setState(() {
                searchMode = false;
              });
            },
            icon: const Icon(Icons.done),
          )
        ]:[
          IconButton(
            onPressed: (){
              setState(() {
                searchMode = true;
              });
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const ProfilePage(),
                ),
              );
            },
            icon: const Icon(Icons.person, size: 20,),
          ),
        ],
      ),
      body: !searchMode ? ListView(
        children: notes.isEmpty ? [
          Center(
            child: SizedBox(
              height: 650,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: 
                    CachedNetworkImage(
                      imageUrl: "https://media1.tenor.com/m/pb0kIF-blqsAAAAC/minion-typing.gif",
                      width: 350,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(20), 
                    child: Text(
                      "Create you first note!",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ] : [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return note(notes[index], index);
            },
            itemCount: notes.length,
          ),
        ],
      ) : ListView(
        children: [
          TextField(
            style: const TextStyle(
              color: Colors.white
            ),
            decoration: const InputDecoration(
              hintText: "Search",
              hintStyle: TextStyle(
                color: Colors.white,
              ),
            ),
            onChanged: (text) {
              setState(() {
                notesFound = [];
              });
              for(int i=0; i<notes.length; i++) {
                if((notes[i]["title"].toString().toLowerCase().contains(text)
                  || notes[i]["body"].toString().toLowerCase().contains(text)) && text != "") {
                  setState(() {
                    notesFound.add(notes[i]);
                  });
                }
              }
            },
          ),
          notesFound.isNotEmpty ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return note(notesFound[index], index);
            },
            itemCount: notesFound.length,
          ) : const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
              "No Notes Found",
            ),
          )
        ],
      ),
      floatingActionButton: !searchMode ? IconButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => EditPage(note: const {}),
            ),
          ).then((newNote) {
            if(newNote.toString() != 'null') {
              setState(() {
                notes.add(newNote);
              });
            }
          });
        },
        icon: const Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        )
      ): Container(),
    );
  }
  Widget note(Map note, int index) {
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
                  onPressed: () {
                    setState(() {
                      notes.removeAt(index);
                    });
                    Navigator.pop(context);
                  },
                  child: const Text("Delete"),
                ),
              ],
            );
          },
        );
      }
      ,onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => EditPage(note: note),
            ),
          ).then((newNote) {
            if(newNote.toString() != 'null') {
              setState(() {
                notes.removeAt(index);
                notes.insert(index, newNote);
              });
            }
          }
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: colors[Random().nextInt(colors.length)],
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
  void getNotes() async {
    NotesSqlDB db = NotesSqlDB();
    await db.initialDB();
    db.readData().then((value) {
      for(int i=0; i<value.length; ++i) {
        if(userData['id'] == value[i]['userId']) {
          setState(() {
            notes.add(value[i]);
          });
        }
      }
    });
  }
}