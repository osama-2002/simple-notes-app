import 'package:flutter/material.dart';
import 'package:notes/authentication/sign_up.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: IconButton(
          onPressed: () {
            Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const SignUpPage(),
                ),
              );
          },
          icon: const Icon(Icons.check),)
      ),
    );
  }
}