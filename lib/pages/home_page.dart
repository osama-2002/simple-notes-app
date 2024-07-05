import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'package:notes/models/note.dart';
import 'package:notes/authentication/login.dart';
import 'package:notes/pages/edit_page.dart';
import 'package:notes/pages/profile_page.dart';
import 'package:notes/shared.dart';
import 'package:notes/widgets/note_widget.dart';
import 'package:notes/theme/my_theme.dart' as my_theme;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> notesFound = [];
  bool searchMode = false;
  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    await notesController.getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: searchMode
            ? const Text(
                "Search",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )
            : const Text(
                "Notes",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
                (Route<dynamic> route) => false);
            usersController.logout();
          },
          icon: const Icon(Icons.logout),
        ),
        actions: searchMode
            ? [
                IconButton(
                  onPressed: () {
                    setState(() {
                      searchMode = false;
                    });
                  },
                  icon: const Icon(Icons.done),
                )
              ]
            : [
                IconButton(
                  onPressed: () {
                    setState(() {
                      searchMode = true;
                    });
                  },
                  icon: const Icon(Icons.search),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const ProfilePage(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.person,
                    size: 20,
                  ),
                ),
              ],
      ),
      body: tabIndex == 0
          ? loadPrivateTab()
          : tabIndex == 1
              ? loadPublicTab()
              : const Padding(
                  padding: EdgeInsets.all(30),
                  child: Center(
                    child: Text(
                      '- A simple offline notes app.\n\n- It supports multiple accounts on the same device and allows notes to be made public for viewing from any account. \n\n- The app was created to practice MVC design pattern and to use essential Flutter packages like sqflite and shared_preferences.',
                      style: TextStyle(
                        color: my_theme.foreGroundColor,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
      floatingActionButton: !searchMode && tabIndex == 0
          ? IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const EditPage(null),
                  ),
                ).then((newNote) {
                  if (newNote != null && newNote.toString().isNotEmpty) {
                    setState(() {
                      notesController.addNote(newNote);
                    });
                  }
                });
              },
              icon: const Icon(
                Icons.add,
                size: 30,
                color: my_theme.foreGroundColor,
              ),
            )
          : Container(),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: tabIndex,
        onTap: (i) => setState(() {
          tabIndex = i;
        }),
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text("Home"),
            selectedColor: Colors.blueAccent,
            unselectedColor: my_theme.foreGroundColor,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.public),
            title: const Text("Public"),
            selectedColor: Colors.blueAccent,
            unselectedColor: my_theme.foreGroundColor,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.info_outline),
            title: const Text("About"),
            selectedColor: Colors.blueAccent,
            unselectedColor: my_theme.foreGroundColor,
          ),
        ],
      ),
    );
  }

  Widget loadPublicTab() {
    return !searchMode
        ? Container(
            child: notesController.allUsersNotes.isEmpty
                ? const Center(
                    child: Text(
                    "No Public Notes found",
                    style: TextStyle(
                      color: my_theme.foreGroundColor,
                      fontSize: 20,
                    ),
                  ))
                : ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return NoteWidget(
                          note: notesController.allUsersNotes[index],
                          index: index);
                    },
                    itemCount: notesController.allUsersNotes.length,
                  ),
          )
        : ListView(
            children: [
              TextField(
                cursorColor: my_theme.foreGroundColor,
                style: const TextStyle(color: my_theme.foreGroundColor),
                decoration: const InputDecoration(
                  hintText: "Search",
                  hintStyle: TextStyle(
                    color: my_theme.foreGroundColor,
                  ),
                ),
                onChanged: (text) {
                  setState(() {
                    notesFound = [];
                  });
                  for (int i = 0;
                      i < notesController.allUsersNotes.length;
                      i++) {
                    if ((notesController.allUsersNotes[i].title
                                .toString()
                                .toLowerCase()
                                .contains(text) ||
                            notesController.allUsersNotes[i].body
                                .toString()
                                .toLowerCase()
                                .contains(text)) &&
                        text != "") {
                      setState(() {
                        notesFound.add(notesController.allUsersNotes[i]);
                      });
                    }
                  }
                },
              ),
              notesFound.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return NoteWidget(
                            note: notesFound[index], index: index);
                      },
                      itemCount: notesFound.length,
                    )
                  : const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: my_theme.foreGroundColor,
                          fontSize: 17,
                        ),
                        "No Notes Found",
                      ),
                    )
            ],
          );
  }

  Widget loadPrivateTab() {
    return !searchMode
        ? ListView(
            children: notesController.currentUserNotes.isEmpty
                ? [
                    Center(
                      child: SizedBox(
                        height: 650,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: CachedNetworkImage(
                                imageUrl:
                                    "https://media1.tenor.com/m/pb0kIF-blqsAAAAC/minion-typing.gif",
                                width: 350,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                "Create you first note!",
                                style: TextStyle(
                                  fontSize: 24,
                                  color: my_theme.foreGroundColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]
                : [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return NoteWidget(
                            note: notesController.currentUserNotes[index],
                            index: index);
                      },
                      itemCount: notesController.currentUserNotes.length,
                    ),
                  ],
          )
        : ListView(
            children: [
              TextField(
                cursorColor: my_theme.foreGroundColor,
                style: const TextStyle(color: my_theme.foreGroundColor),
                decoration: const InputDecoration(
                  hintText: "Search",
                  hintStyle: TextStyle(
                    color: my_theme.foreGroundColor,
                  ),
                ),
                onChanged: (text) {
                  setState(() {
                    notesFound = [];
                  });
                  for (int i = 0;
                      i < notesController.currentUserNotes.length;
                      i++) {
                    if ((notesController.currentUserNotes[i].title
                                .toString()
                                .toLowerCase()
                                .contains(text) ||
                            notesController.currentUserNotes[i].body
                                .toString()
                                .toLowerCase()
                                .contains(text)) &&
                        text != "") {
                      setState(() {
                        notesFound.add(notesController.currentUserNotes[i]);
                      });
                    }
                  }
                },
              ),
              notesFound.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return NoteWidget(
                            note: notesFound[index], index: index);
                      },
                      itemCount: notesFound.length,
                    )
                  : const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: my_theme.foreGroundColor,
                          fontSize: 17,
                        ),
                        "No Notes Found",
                      ),
                    )
            ],
          );
  }
}
