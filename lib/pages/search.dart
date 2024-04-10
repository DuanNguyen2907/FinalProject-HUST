import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/post.dart';
import '../pages/post_detail_page.dart';
import '../widgets/post.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchPage> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Search'),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: SearchBar(query: query),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends SearchDelegate<String> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String query;

  SearchBar({required this.query});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          close(context, '');
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Post>>(
      future: _firestore
          .collection('posts')
          .where('context', isGreaterThanOrEqualTo: query)
          .get()
          .then((querySnapshot) =>
              querySnapshot.docs.map((doc) => Post.fromDocument(doc)).toList()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.data!.isEmpty) {
          return Center(child: Text('No results found'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Xử lý sự kiện nhấn để chuyển đến chi tiết bài post
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
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.builder(
      itemCount: query.length > 0 ? 5 : 0,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('$query $index'),
          onTap: () {
            close(context, query);
          },
        );
      },
    );
  }
}
