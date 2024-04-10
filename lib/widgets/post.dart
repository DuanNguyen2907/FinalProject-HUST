import 'package:flutter/material.dart';
import '../domain/post.dart';

class PostWidget extends StatelessWidget {
  final Post post;

  PostWidget({
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${post.likes} Likes'),
              Text('${post.comments.length} Comments'),
              Text('${post.shares} Shares'),
            ],
          ),
        ],
      ),
    );
  }
}
