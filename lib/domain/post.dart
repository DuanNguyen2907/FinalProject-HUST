import 'package:app_project/domain/tag.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String author;
  final String timeAgo;
  final String content;
  final int likes;
  final List comments;
  final int shares;
  final List imageUrl;
  final String avatarUrl;
  final List<Tag> tags;
  final String id;

  Post({
    required this.author,
    required this.timeAgo,
    required this.content,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.imageUrl,
    required this.avatarUrl,
    required this.tags,
    required this.id,
  });

  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      author: doc['author'],
      timeAgo: doc['timeAgo'],
      content: doc['content'],
      likes: doc['likes'],
      comments: doc['comments'],
      shares: doc['shares'],
      imageUrl: doc['imageUrl'],
      avatarUrl: doc['avatarUrl'],
      tags: doc['tags'],
      id: doc['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'author': author,
      'timeAgo': timeAgo,
      'content': content,
      'likes': likes,
      'comments': comments,
      'shares': shares,
      'imageUrl': imageUrl,
      'avatarUrl': avatarUrl,
      'tags': tags,
      'id': id,
    };
  }
}
