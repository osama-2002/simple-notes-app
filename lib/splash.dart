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
  
  void check() async {
    bool isLoggedIn = await usersController.loadUserData();
    if (isLoggedIn) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
          (Route<dynamic> route) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => SignUpPage(),
          ),
          (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    usersController = UsersController();
    notesController = NotesController();
    check();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

}
