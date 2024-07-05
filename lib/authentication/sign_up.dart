import 'package:flutter/material.dart';

import 'package:notes/authentication/login.dart';
import 'package:notes/models/user.dart';
import 'package:notes/pages/home_page.dart';
import 'package:notes/shared.dart';
import 'package:notes/theme/my_theme.dart' as my_theme;

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              cursorColor: my_theme.foreGroundColor,
              style: const TextStyle(
                color: my_theme.foreGroundColor,
              ),
              controller: emailController,
              decoration: const InputDecoration(
                hintText: "Email",
                hintStyle: TextStyle(
                  color: my_theme.foreGroundColor,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              cursorColor: my_theme.foreGroundColor,
              style: const TextStyle(
                color: my_theme.foreGroundColor,
              ),
              controller: nameController,
              decoration: const InputDecoration(
                hintText: "Name",
                hintStyle: TextStyle(
                  color: my_theme.foreGroundColor,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              cursorColor: my_theme.foreGroundColor,
              style: const TextStyle(
                color: my_theme.foreGroundColor,
              ),
              controller: passwordController,
              decoration: const InputDecoration(
                hintText: "Password",
                hintStyle: TextStyle(
                  color: my_theme.foreGroundColor,
                ),
              ),
              obscureText: true,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () {
              if (emailController.text.toString().isEmpty ||
                  nameController.text.toString().isEmpty ||
                  passwordController.text.toString().isEmpty) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Alert'),
                      content: const Text('Please fill the required fields'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              } else {
                usersController.registerUser(
                  User(
                      email: emailController.text.toString(),
                      name: nameController.text.toString(),
                      password: passwordController.text.toString(),
                      bio: 'Add Your Bio'),
                );
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const HomePage()),
                    (route) => false);
              }
            },
            child: Container(
              height: 50,
              width: 90,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(
                  color: my_theme.foreGroundColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Already have an account? ",
                style: TextStyle(
                  color: my_theme.foreGroundColor,
                  fontSize: 16,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage(),
                    ),
                  );
                },
                child: const Text(
                  "login",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: my_theme.foreGroundColor,
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
