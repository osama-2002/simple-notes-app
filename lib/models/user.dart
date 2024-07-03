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
}