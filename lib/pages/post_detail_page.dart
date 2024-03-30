import 'package:flutter/material.dart';
import '../domain/post.dart';

class PostDetail extends StatelessWidget {
  final Post post;

  PostDetail({
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Detail'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(post.avatarUrl),
              ),
              title: Text(post.author),
              subtitle: Text(post.timeAgo),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(post.content),
            ),
            Image.network(post.imageUrl),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${post.likes} Likes'),
                  Text('${post.comments} Comments'),
                  Text('${post.shares} Shares'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
