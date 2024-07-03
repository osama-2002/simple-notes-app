import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class Note {
  final String id;
  final String title;
  final String body;
  final String userId;
  
  Note({
    String? id,
    required this.title,
    required this.body,
    required this.userId,
  }) : id = id ?? uuid.v4();
}