import 'package:app_project/services/userService.dart';
import 'package:flutter/material.dart';
import '../domain/post.dart';
import '../domain/user.dart';

class PostDetail extends StatelessWidget {
  final Post post;
  final UserService userService = UserService();

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
                  Text('${post.comments.length} Comments'),
                  Text('${post.shares} Shares'),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text('Comments', style: TextStyle(fontSize: 20)),
            SizedBox(height: 16),
            FutureBuilder<List<User>>(
              future: Future.wait(post.comments
                  .map((comment) => userService.getUserById(comment['userId']))
                  .toList()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final users = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: post.comments.length,
                    itemBuilder: (context, index) {
                      final comment = post.comments[index];
                      final user = users[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.avatar),
                        ),
                        title: Text(user.username),
                        subtitle: Text(comment['content']),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
