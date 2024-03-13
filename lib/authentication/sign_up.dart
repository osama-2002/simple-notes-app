import 'package:flutter/material.dart';
import 'package:notes/DB/users_db.dart';
import 'package:notes/authentication/login.dart';

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                style: const TextStyle(
                  color: Colors.white,
                ),
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: "Email",
                  hintStyle: TextStyle(
                    color: Colors.white,
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
                  color: Colors.white,
                ),
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: "Name",
                  hintStyle: TextStyle(
                    color: Colors.white,
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
                  color: Colors.white,
                ),
                controller: passwordController,
                decoration: const InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                obscureText: true,
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
                  registerUser(
                    email: emailController.text.toString(), 
                    name: nameController.text.toString(), 
                    password: passwordController.text.toString()
                  );
                  Navigator.of(context).pushAndRemoveUntil( //!
                    MaterialPageRoute(
                      builder: (context) => const LoginPage()
                    ),
                    (route) => false);
                }
              },
              child: Container(
                height: 50,
                width: 90,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
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
                      color: Colors.white,
                      fontSize: 16,
                    ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const LoginPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "login",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
  void registerUser({email, name, password}) async {
    UsersSqlDB myDB = UsersSqlDB();
    await myDB.initialDB();
    Map<String, dynamic> userData = {
      "email":email,
      "name":name,
      "password":password,
      "bio":"Add Your Bio",
    };
    await myDB.insertData(userData);
  }
}