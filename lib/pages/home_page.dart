import 'package:flutter/material.dart';
import '../services/database.dart';
import '../pages/post_detail_page.dart';
import '../domain/post.dart';
import '../widgets/post.dart';

class Home extends StatelessWidget {
  DatabaseService dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: FutureBuilder<List<Post>>(
        future: dbService.getPosts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Đã xảy ra lỗi: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Handle tap event to navigate to post detail
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PostDetail(post: snapshot.data![index]),
                    ),
                  );
                },
                child: PostWidget(
                  post: snapshot.data![index],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
