import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String username;
  final String avatar;
  final String content;

  Comment({
    required this.username,
    required this.avatar,
    required this.content,
  });
}
