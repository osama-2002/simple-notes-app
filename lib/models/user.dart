import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class User {
  final String id;
  final String email;
  final String name;
  final String password;
  final String bio;

  User({
    String? id,
    required this.email,
    required this.name,
    required this.password,
    required this.bio,
  }) : id = id ?? uuid.v4();

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      name: map['name'],
      password: map['password'],
      bio: map['bio'],
    );
  }
}
