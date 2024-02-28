import 'package:flutter/material.dart';
import 'package:notes/authentication/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
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
            controller: nameController,
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: "Name",
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
                registerUser(email: emailController.text.toString(), name: nameController.text.toString(), password: passwordController.text.toString());
                Navigator.of(context).pushAndRemoveUntil( //!
                  MaterialPageRoute(
                    builder: (context) => const LoginPage()
                  ),
                  (route) => false);
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
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
  void registerUser({email, name, password}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("userEmail", emailController.text.toString());
    await prefs.setString("userName", nameController.text.toString());
    await prefs.setString("userPassword", passwordController.text.toString());
  }
}