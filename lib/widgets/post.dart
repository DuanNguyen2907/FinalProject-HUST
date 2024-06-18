// post_widget.dart
import 'package:app_project/services/postService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../domain/post.dart';

class PostWidget extends StatelessWidget {
  final Post post;
  final String postId;
  final PostService postService = PostService();

  PostWidget({required this.post, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PostHeader(post: post),
          _PostContent(post: post),
          _PostImages(post: post),
          _PostActions(post: post, postService: postService),
        ],
      ),
    );
  }
}

// _post_header.dart
class _PostHeader extends StatelessWidget {
  final Post post;

  _PostHeader({required this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(post.avatarUrl),
            radius: 25,
          ),
          title: Text(
            post.author,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          subtitle: Text(
            post.timeAgo,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
        // Add the tags row here
        Row(
          children: post.tags
              .map((tag) => Chip(
                    label: Text(tag.tagName),
                    backgroundColor: Colors.grey.shade200,
                    labelStyle: TextStyle(fontSize: 12),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

// _post_content.dart
class _PostContent extends StatelessWidget {
  final Post post;

  _PostContent({required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        post.content,
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
    );
  }
}

// _post_images.dart
class _PostImages extends StatelessWidget {
  final Post post;

  _PostImages({required this.post});

  @override
  Widget build(BuildContext context) {
    return post.imageUrl.length > 1
        ? AspectRatio(
            aspectRatio: 16 / 9,
            child: PageView.builder(
              itemCount: post.imageUrl.length,
              itemBuilder: (context, index) {
                return Image.network(
                  post.imageUrl[index],
                  fit: BoxFit.cover,
                );
              },
            ),
          )
        : AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              post.imageUrl[0],
              fit: BoxFit.cover,
            ),
          );
  }
}

// _post_actions.dart
class _PostActions extends StatefulWidget {
  final Post post;
  final PostService postService;

  _PostActions({required this.post, required this.postService});

  @override
  _PostActionsState createState() => _PostActionsState();
}

class _PostActionsState extends State<_PostActions> {
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _checkIfPostIsLiked();
  }

  Future<void> _checkIfPostIsLiked() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final isLiked =
        await widget.postService.isPostLikedByUser(widget.post.id, userId);
    if (isLiked) {
      setState(() {
        _isLiked = isLiked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              // Handle like button press
              widget.postService.likePost(widget.post.id);
              print('Like button pressed');
              setState(() {
                _isLiked = !_isLiked;
              });
            },
            style: TextButton.styleFrom(
              backgroundColor: _isLiked ? Colors.blue : Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.blue.withAlpha(100)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.thumb_up,
                  color: Colors.blue,
                  size: 16,
                ),
                SizedBox(width: 4),
                Text(
                  'Like',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              // Handle comment button press
              print('Comment button pressed');
            },
            child: Row(
              children: [
                Icon(
                  Icons.comment,
                  color: Colors.grey,
                  size: 16,
                ),
                SizedBox(width: 4),
                Text(
                  'Comment',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
          ),
        ],
      ),
    );
  }
}
