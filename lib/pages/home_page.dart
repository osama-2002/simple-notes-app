import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'package:notes/authentication/login.dart';
import 'package:notes/pages/edit_page.dart';
import 'package:notes/pages/profile_page.dart';
import 'package:notes/shared.dart';
import 'package:notes/widgets/note_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List notesFound = [];
  bool searchMode = false;
  int tabIndex = 0;

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
              : const Placeholder(),
      floatingActionButton: !searchMode && tabIndex == 0
          ? IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => EditPage(const {}),
                  ),
                ).then((newNote) {
                  if (newNote != null && newNote.toString().isNotEmpty) {
                    setState(() {
                      notesController.currentUserNotes.add(newNote);
                      notesController.allUsersNotes.add(newNote);
                    });
                  }
                });
              },
              icon: const Icon(
                Icons.add,
                size: 30,
                color: Colors.white,
              ))
          : Container(),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: tabIndex,
        onTap: (i) => setState(() {
          tabIndex = i;
          //notesController.allUsersNotes = [];
        }),
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text("Home"),
            selectedColor: Colors.blueAccent,
            unselectedColor: Colors.white,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.public),
            title: const Text("Public"),
            selectedColor: Colors.pink,
            unselectedColor: Colors.white,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.account_circle_outlined),
            title: const Text("Profile"),
            selectedColor: Colors.teal,
            unselectedColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget loadPublicTab() {
    return !searchMode
        ? ListView(
            children: notesController.allUsersNotes.isEmpty
                ? [
                    const Center(
                        child: Text(
                      "No Public Notes found",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    )),
                  ]
                : [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return note(notesController.allUsersNotes[index], index, context, setState);
                      },
                      itemCount: notesController.allUsersNotes.length,
                    ),
                  ],
          )
        : ListView(
            children: [
              TextField(
                style: const TextStyle(color: Colors.white),
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
                  for (int i = 0; i < notesController.allUsersNotes.length; i++) {
                    if ((notesController.allUsersNotes[i]["title"]
                                .toString()
                                .toLowerCase()
                                .contains(text) ||
                            notesController.allUsersNotes[i]["body"]
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
                        return note(
                            notesFound[index], index, context, setState);
                      },
                      itemCount: notesFound.length,
                    )
                  : const Padding(
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
                  ]
                : [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return note(notesController.currentUserNotes[index], index, context, setState);
                      },
                      itemCount: notesController.currentUserNotes.length,
                    ),
                  ],
          )
        : ListView(
            children: [
              TextField(
                style: const TextStyle(color: Colors.white),
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
                  for (int i = 0; i < notesController.currentUserNotes.length; i++) {
                    if ((notesController.currentUserNotes[i]["title"]
                                .toString()
                                .toLowerCase()
                                .contains(text) ||
                            notesController.currentUserNotes[i]["body"]
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
                        return note(
                            notesFound[index], index, context, setState);
                      },
                      itemCount: notesFound.length,
                    )
                  : const Padding(
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
          );
  }
}
