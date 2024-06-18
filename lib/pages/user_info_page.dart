import 'package:app_project/domain/post.dart';
import 'package:app_project/domain/user.dart';
import 'package:app_project/pages/edit_post_page.dart';
import 'package:app_project/pages/edit_user_info_page.dart';
import 'package:app_project/pages/login_page.dart';
import 'package:app_project/services/postService.dart';
import 'package:app_project/services/userService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserInfoPage extends StatelessWidget {
  const UserInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Info'),
      ),
      body: const Column(
        children: [
          UserInfoPart(),
          Expanded(
            child: PostList(),
          ),
          SignOutButton(),
        ],
      ),
    );
  }
}

class PostList extends StatelessWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context) {
    final PostService postService = PostService();
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return FutureBuilder<List<Post>>(
      future: postService.getPostsByUserId(currentUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostCard(post: post);
              },
            );
          } else {
            return const Text('No posts found');
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(post.imageUrl[0]),
        title: Text(post.content.length > 50
            ? '${post.content.substring(0, 50)}...'
            : post.content),
        subtitle: Text('${post.timeAgo} - ${post.author}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditPostScreen(
                      postId: post.id,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _showPopup(
                    context, "Bạn chắc chắn muốn xoá post chứ !", post.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}

void _showPopup(BuildContext context, String message, String postId) {
  final PostService postService = PostService();
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              postService.deletePost(postId);
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

class UserInfoPart extends StatelessWidget {
  const UserInfoPart({super.key});

  @override
  Widget build(BuildContext context) {
    final UserService userService = UserService();
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return FutureBuilder<AAA?>(
      future: userService.getUserById(currentUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return _buildUserDetails(snapshot, context);
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget _buildUserDetails(AsyncSnapshot<AAA?> snapshot, BuildContext context) {
    if (snapshot.hasData) {
      final AAA user = snapshot.data!;
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildAvatar(user.avatar),
          const SizedBox(height: 20),
          ..._buildUserInfo(user),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const EditUserInfoPage()),
              );
            },
            child: const Text('Edit'),
          ),
        ],
      );
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      return const Text('User not found');
    }
  }

  Widget _buildAvatar(String avatarUrl) {
    return CircleAvatar(backgroundImage: NetworkImage(avatarUrl));
  }

  List<Widget> _buildUserInfo(AAA user) {
    return [
      _buildInfoRow('Username: ', user.username),
      _buildInfoRow('Email: ', user.email),
      _buildInfoRow('Phone: ', user.phone),
      _buildInfoRow('Address: ', user.address),
      _buildInfoRow('Date of Birth: ',
          DateFormat('dd/MM/yyyy').format(user.dob.toDate())),
    ];
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        FirebaseAuth.instance.signOut();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      },
      child: const Text("Sign Out"),
    );
  }
}
