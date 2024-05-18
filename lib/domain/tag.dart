import 'package:cloud_firestore/cloud_firestore.dart';

class Tag {
  final String tagName;
  final String desc;
  final String id;

  Tag({
    required this.tagName,
    required this.desc,
    required this.id,
  });

  factory Tag.fromDocument(DocumentSnapshot doc) {
    return Tag(tagName: doc['tagName'], desc: doc['desc'], id: doc['id']);
  }
}
