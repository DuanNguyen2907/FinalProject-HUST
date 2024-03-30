import 'package:flutter/material.dart';
import '../pages/post_detail_page.dart';
import '../domain/post.dart';
import '../widgets/post.dart';

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
