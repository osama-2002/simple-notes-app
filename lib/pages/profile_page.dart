import 'package:flutter/material.dart';

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
                  if (value.toString().contains("@")) {
                    return null;
                  } else {
                    return "email must contain @.";
                  }
                },
                style: const TextStyle(color: Colors.white),
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: "Edit Email",
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value.toString().length > 3) {
                    return null;
                  } else {
                    return "name must be more than 3 characters.";
                  }
                },
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
              TextFormField(
                validator: (value) {
                  if (value.toString().length > 3) {
                    return null;
                  } else {
                    return "bio must be more than 3 characters.";
                  }
                },
                style: const TextStyle(color: Colors.white),
                controller: bioController,
                decoration: const InputDecoration(
                  hintText: "Add Your Bio",
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    Map<String, dynamic> updatedUserData = {
                      'id': usersController.currentUser.id,
                      'name': nameController.text,
                      'email': emailController.text,
                      'password': usersController.currentUser.id,
                      'bio': bioController.text,
                    };
                    usersController.updateUserData(updatedUserData);
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
      ),
    );
  }
}
