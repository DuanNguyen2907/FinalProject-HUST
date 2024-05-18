import 'package:app_project/domain/user.dart';
import 'package:app_project/services/userService.dart';
import 'package:flutter/material.dart';
import '../domain/post.dart';

class PostDetail extends StatefulWidget {
  final Post post;
  final UserService userService = UserService();

  PostDetail({
    required this.post,
  });

  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  final _commentController = TextEditingController();
  UserService userService = UserService();

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
                backgroundImage: NetworkImage(widget.post.avatarUrl),
              ),
              title: Text(widget.post.author),
              subtitle: Text(widget.post.timeAgo),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.post.content),
            ),
            Image.network(widget.post.imageUrl[0]),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${widget.post.likes} Likes'),
                  Text('${widget.post.comments.length} Comments'),
                  Text('${widget.post.shares} Shares'),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text('Comments', style: TextStyle(fontSize: 20)),
            SizedBox(height: 16),
            FutureBuilder<List<AAA?>>(
              future: Future.wait(widget.post.comments
                  .map((comment) =>
                      widget.userService.getUserById(comment['userId']))
                  .toList()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final users = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: widget.post.comments.length,
                    itemBuilder: (context, index) {
                      final comment = widget.post.comments[index];
                      final user = users[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user!.avatar),
                        ),
                        title: Text(user.username),
                        subtitle: Text(comment['content']),
                      );
                    },
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Add a comment...',
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      // Add comment logic here
                      // final comment = {
                      //   'userId': widget.userService.currentUser.id,
                      //   'content': _commentController.text,
                      // };
                      // widget.post.comments.add(comment);
                      // Update the post comments in the database
                      //...
                      _commentController.clear();
                    },
                    child: Text('Comment'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
