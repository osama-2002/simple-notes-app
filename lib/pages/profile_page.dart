import 'package:flutter/material.dart';
import 'package:notes/DB/users_db.dart';
import 'package:notes/pages/home_page.dart';
import 'package:notes/shared.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    emailController.text = userData['email'];
    nameController.text = userData['name'];
    bioController.text = userData['bio'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20
            ),
            TextField(
              style: const TextStyle(color: Colors.white),
              controller: emailController,
              decoration: const InputDecoration(
                hintText: "Edit Email",
                hintStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 20
            ),
            TextField(
              style: const TextStyle(color: Colors.white),
              controller: nameController,
              decoration: const InputDecoration(
                hintText: "Edit Name",
                hintStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              style: const TextStyle(color: Colors.white),
              controller: bioController,
              decoration: const InputDecoration(
                hintText: "Add Your Bio",
                hintStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 20
            ),
            InkWell(
              onTap: () async {
                Map<String, dynamic> updatedUserData = {
                  'id': userData['id'],
                  'name': nameController.text,
                  'email': emailController.text,
                  'password': userData['password'],
                  'bio': bioController.text,
                };
                UsersSqlDB db = UsersSqlDB();
                await db.initialDB();
                await db.updateData(updatedUserData).then((value) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                    (Route<dynamic> route) => false
                  );
                });
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
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}