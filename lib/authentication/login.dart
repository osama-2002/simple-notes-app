import 'package:flutter/material.dart';

import 'package:notes/authentication/sign_up.dart';
import 'package:notes/pages/home_page.dart';
import 'package:notes/shared.dart';
import 'package:notes/theme/my_theme.dart' as my_theme;

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
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
                usersController
                    .validateLogin(
                        email: emailController.text.toString(),
                        password: passwordController.text.toString())
                    .then((valid) async {
                  if (valid) {
                    await notesController.getNotes();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                        (Route<dynamic> route) => false);
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Alert'),
                          content: const Text('Wrong Credentials'),
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
                  }
                });
              }
            },
            child: Container(
              height: 50,
              width: 80,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Enter',
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
                "Don't have an account? ",
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
                      builder: (BuildContext context) => SignUpPage(),
                    ),
                  );
                },
                child: const Text(
                  "sign up",
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
