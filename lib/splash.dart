import 'package:flutter/material.dart';
import 'package:notes/DB/users_db.dart';
import 'package:notes/authentication/sign_up.dart';
import 'package:notes/pages/home_page.dart';
import 'package:notes/services/services.dart';
import 'package:notes/shared.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    check();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.check),)
      ),
    );
  }
  void check() {
    getUserId().then((id) async {
      if(id != 0) {
        UsersSqlDB db = UsersSqlDB();
        await db.initialDB();
        db.readData().then((users) {        
          for(int i=0; i<users.length; ++i) {
            if(users[i]['id'] == id) {
              userData = users[i];
              break;
            }
          }
        });
        Navigator.push<void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const HomePage(),
          ),
        );
      } else {
        Navigator.push<void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const SignUpPage(),
          ),
        );
      }
    });
  }
}