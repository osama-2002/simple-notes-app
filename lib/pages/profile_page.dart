import 'package:flutter/material.dart';
import 'package:notes/models/user.dart';

import 'package:notes/pages/home_page.dart';
import 'package:notes/shared.dart';
import 'package:notes/theme/my_theme.dart' as my_theme;

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
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    emailController.text = usersController.currentUser.email;
    nameController.text = usersController.currentUser.name;
    bioController.text = usersController.currentUser.bio;
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value != '') {
                    return null;
                  } else {
                    return "email can't be empty";
                  }
                },
                style: const TextStyle(color: my_theme.foreGroundColor),
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: "Edit Email",
                  hintStyle: TextStyle(
                    color: my_theme.foreGroundColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value != '') {
                    return null;
                  } else {
                    return "name can't be empty";
                  }
                },
                style: const TextStyle(color: my_theme.foreGroundColor),
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: "Edit Name",
                  hintStyle: TextStyle(
                    color: my_theme.foreGroundColor,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                validator: (value) {
                  if (value != '') {
                    return null;
                  } else {
                    return "bio can't be empty";
                  }
                },
                style: const TextStyle(color: my_theme.foreGroundColor),
                controller: bioController,
                decoration: const InputDecoration(
                  hintText: "Add Your Bio",
                  hintStyle: TextStyle(
                    color: my_theme.foreGroundColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    await usersController.updateUserData(
                      User(
                          id: usersController.currentUser.id,
                          email: emailController.text,
                          name: nameController.text,
                          password: usersController.currentUser.password,
                          bio: bioController.text),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile updated successfully!'),
                      ),
                    );
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                        (Route<dynamic> route) => false);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Invalid input'),
                      ),
                    );
                  }
                },
                child: Container(
                  height: 50,
                  width: 80,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 22, 82, 150),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: my_theme.foreGroundColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
