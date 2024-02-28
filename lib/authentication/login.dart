import 'package:flutter/material.dart';
import 'package:notes/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: ListView(
        children: [
          TextField(
            style: const TextStyle(
              color: Colors.white,
            ),
            controller: emailController,
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: "Enter Body",
              hintStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          TextField(
            style: const TextStyle(
              color: Colors.white,
            ),
            controller: passwordController,
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: "Enter Body",
              hintStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              if(emailController.text.toString().isEmpty ||
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
                validateUserInput(email: emailController.text.toString() ,password : passwordController.text.toString())
                .then((value) {
                  if(value['isValid']) {
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const HomePage(),
                      ),
                    );
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
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Enter',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
  Future<Map> validateUserInput({email, password}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Map result = {
      "isValid": false,
    };
    if(email != prefs.getString("userEmail") ||
      password != prefs.getString("userPassword")) {
      return result;
    }
    result['isValid'] = true;
    return result;
  }
}