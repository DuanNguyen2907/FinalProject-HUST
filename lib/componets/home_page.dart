import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final List<Post> posts = [
    Post(
      author: 'John Doe',
      timeAgo: '2 hours ago',
      content: 'This is a sample post on Flutter.',
      likes: 10,
      comments: 5,
      shares: 2,
      imageUrl:
          "https://img.thuthuatphanmem.vn/uploads/2018/10/26/anh-dep-cau-rong-da-nang-viet-nam_055418962.jpg",
      avatarUrl:
          "https://img.thuthuatphanmem.vn/uploads/2018/10/26/anh-dep-cau-rong-da-nang-viet-nam_055418962.jpg",
    ),
    Post(
      author: 'John Doe2',
      timeAgo: '22 hours ago',
      content: 'This is a sample post on Flutter2.',
      likes: 10,
      comments: 5,
      shares: 2,
      imageUrl:
          "https://img.thuthuatphanmem.vn/uploads/2018/10/26/anh-dep-cau-rong-da-nang-viet-nam_055418962.jpg",
      avatarUrl:
          "https://img.thuthuatphanmem.vn/uploads/2018/10/26/anh-dep-cau-rong-da-nang-viet-nam_055418962.jpg",
    )
    // Add more posts here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Handle tap event to navigate to post detail
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostDetail(post: posts[index]),
                ),
              );
            },
            child: PostWidget(
              post: posts[index],
            ),
          );
        },
      ),
    );
  }
}

class Post {
  final String author;
  final String timeAgo;
  final String content;
  final int likes;
  final int comments;
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
}

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
              Text('${post.comments} Comments'),
              Text('${post.shares} Shares'),
            ],
          ),
        ],
      ),
    );
  }
}

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
