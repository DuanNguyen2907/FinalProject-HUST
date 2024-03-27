import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  // List<PostData> posts = [
  //   PostData(
  //     author: 'John Doe',
  //     timeAgo: '2 hours ago',
  //     content: 'This is a sample post on Flutter.',
  //     likes: 10,
  //     comments: 5,
  //     shares: 2,
  //     imageUrl: "https://example.com/image1.jpg",
  //     avatarUrl: "https://example.com/avatar1.jpg",
  //   ),
  //   PostData(
  //     author: 'Jane Smith',
  //     timeAgo: '1 day ago',
  //     content: 'Another post for testing purposes.',
  //     likes: 20,
  //     comments: 8,
  //     shares: 3,
  //     imageUrl: "https://example.com/image2.jpg",
  //     avatarUrl: "https://example.com/avatar2.jpg",
  //   ),
  //   // Add more posts here
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: ListView(
        children: [
          PostWidget(
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
          // Add more PostWidget here
        ],
      ),
    );
  }
}

class PostWidget extends StatelessWidget {
  final String author;
  final String timeAgo;
  final String content;
  final int likes;
  final int comments;
  final int shares;
  final String imageUrl; // Thêm trường để chứa URL của hình ảnh
  final String avatarUrl; // Thêm trường để chứa URL của avatar

  PostWidget({
    required this.author,
    required this.timeAgo,
    required this.content,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.imageUrl,
    required this.avatarUrl,
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
              // Thêm avatar người dùng
              backgroundImage: NetworkImage(avatarUrl),
            ),
            title: Text(author),
            subtitle: Text(timeAgo),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(content),
          ),
          Image.network(imageUrl), // Thêm hình ảnh vào bài post
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$likes Likes'),
              Text('$comments Comments'),
              Text('$shares Shares'),
            ],
          ),
        ],
      ),
    );
  }
}
