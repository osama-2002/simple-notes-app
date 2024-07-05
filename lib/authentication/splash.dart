import 'package:flutter/material.dart';

import 'package:notes/authentication/sign_up.dart';
import 'package:notes/controllers/notes_controller.dart';
import 'package:notes/controllers/users_controller.dart';
import 'package:notes/pages/home_page.dart';
import 'package:notes/shared.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void initializeControllers() async {
    usersController = UsersController();
    await usersController.getUsers();
    bool isLoggedIn = await usersController.loadUserData();
    notesController = NotesController();
    await notesController.getNotes();

    if (isLoggedIn) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomePage()),
        (Route<dynamic> route) => false,
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => SignUpPage()),
        (Route<dynamic> route) => false,
      );
    }
  }
  
  @override
  void initState() {
    super.initState();
    initializeControllers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
