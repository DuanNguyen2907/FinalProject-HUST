import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String author;
  final String timeAgo;
  final String content;
  final int likes;
  final List comments;
  final int shares;
  final String imageUrl;
  final String avatarUrl;

  Post({
    required this.author,
    required this.timeAgo,
    required this.content,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.imageUrl,
    required this.avatarUrl,
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
    );
  }
}
