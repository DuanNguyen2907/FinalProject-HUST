import 'package:app_project/services/postService.dart';
import 'package:flutter/material.dart';
import '../domain/post.dart';

class PostDetail extends StatefulWidget {
  final Post post;

  const PostDetail({
    super.key,
    required this.post,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Detail'),
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
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: widget.post.imageUrl.map((url) {
                return Image.network(url);
              }).toList(),
            ),
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
            const SizedBox(height: 16),
            const Text('Comments', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: widget.post.comments.length,
              itemBuilder: (context, index) {
                final comment = widget.post.comments[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(comment['avatar']),
                  ),
                  title: Text(comment["username"]),
                  subtitle: Text(comment["content"]),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Add a comment...',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      _comment(widget.post.id, _commentController.text);
                      _commentController.clear();
                    },
                    child: const Text('Comment'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _comment(String postId, String comment) async {
    PostService postService = PostService();
    postService.addComment(postId, comment);
  }
}
