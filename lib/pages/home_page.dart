import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:notes/authentication/login.dart';
import 'package:notes/pages/edit_page.dart';
import 'package:notes/pages/profile_page.dart';
import 'package:notes/services/services.dart';
import 'package:notes/shared.dart';
import 'package:notes/widgets/note_widget.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

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
  void initState() {
    getNotes(setState);
    getAllNotes(setState);
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
      body: tabIndex == 0 ? loadPrivateTab() : tabIndex == 1 ? loadPublicTab() : const Placeholder(),
      floatingActionButton: !searchMode && tabIndex == 0 ? IconButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => EditPage(const {}),
            ),
          ).then((newNote) {
            if(newNote != null && newNote.toString().isNotEmpty) {
              setState(() {
                notes.add(newNote);
                allNotes.add(newNote);
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
      bottomNavigationBar: SalomonBottomBar(
          currentIndex: tabIndex,
          onTap: (i) => setState(() { 
            tabIndex = i;
            allNotes = [];
            getAllNotes(setState);
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
      return !searchMode ? ListView(
        children: allNotes.isEmpty ? [
          const Center(
            child: Text(
              "No Public Notes found",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            )
          ),
        ] : [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return note(allNotes[index], index, context, setState);
            },
            itemCount: allNotes.length,
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
              for(int i=0; i<allNotes.length; i++) {
                if((allNotes[i]["title"].toString().toLowerCase().contains(text)
                  || allNotes[i]["body"].toString().toLowerCase().contains(text)) && text != "") {
                  setState(() {
                    notesFound.add(allNotes[i]);
                  });
                }
              }
            },
          ),
          notesFound.isNotEmpty ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return note(notesFound[index], index, context, setState);
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
      );
  }

  Widget loadPrivateTab() {
    return !searchMode ? ListView(
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
              return note(notes[index], index, context, setState);
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
              return note(notesFound[index], index, context, setState);
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
      );
  }
}