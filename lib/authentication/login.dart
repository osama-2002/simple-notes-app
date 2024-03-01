import 'package:flutter/material.dart';
import 'package:notes/DB/users_db.dart';
import 'package:notes/pages/home_page.dart';
import 'package:notes/services/services.dart';
import 'package:notes/shared.dart';

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
          const SizedBox(
            height: 20,
          ),
          TextField(
            style: const TextStyle(
              color: Colors.white,
            ),
            controller: emailController,
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: "Email",
              hintStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            style: const TextStyle(
              color: Colors.white,
            ),
            controller: passwordController,
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: "Password",
              hintStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
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
                validateUserInput(
                  email: emailController.text.toString(),
                  password : passwordController.text.toString()
                ).then((value) {
                  if(value['isValid']) {
                    saveUserId(userData['id']);
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                      (Route<dynamic> route) => false
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
    List users = [];
    UsersSqlDB db = UsersSqlDB();
    db.initialDB();
    Map result = {
      "isValid": false,
    };
    await db.readData().
    then((value) {
      users = value;
    });
    for(int i=0; i<users.length; ++i) {
      if(users[i]['email'] == email && users[i]['password'] == password) {
        userData = users[i];
        result['isValid'] = true;
        return result;
      }
    }
    return result;
  }
}