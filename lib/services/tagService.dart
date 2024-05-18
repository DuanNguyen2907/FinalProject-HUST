import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/tag.dart';

class TagService {
  Future<Tag> getTagById(String id) async {
    final tagRef = FirebaseFirestore.instance.collection('tags');
    final tagDoc = await tagRef.doc(id).get();
    if (tagDoc.exists) {
      return Tag(tagName: tagDoc['tagname'], desc: tagDoc['desc'], id: id);
    } else {
      throw Exception('User not found');
    }
  }

  Future<List<Tag>> getAllTags() async {
    final tagRef = FirebaseFirestore.instance.collection('tags');
    final tagSnapshot = await tagRef.get();

    List<Tag> tags = [];
    tagSnapshot.docs.forEach((doc) {
      Tag tag = Tag(tagName: doc['tagname'], desc: doc['desc'], id: doc.id);
      tags.add(tag);
    });

    return tags;
  }
}
