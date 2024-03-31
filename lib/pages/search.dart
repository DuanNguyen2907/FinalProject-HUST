import 'package:flutter/material.dart';
import '../domain/post.dart';
import '../pages/post_detail_page.dart';
import '../widgets/post.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = '';

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

  void onQueryChanged(String newQuery) {
    setState(() {
      query = newQuery;
    });
  }

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
                  delegate:
                      SearchBar(query: query, onQueryChanged: onQueryChanged),
                );
              },
            ),
          ],
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
      ),
    );
  }
}

class SearchBar extends SearchDelegate<String> {
  final String query;
  final ValueChanged<String> onQueryChanged;

  SearchBar({required this.query, required this.onQueryChanged});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          onQueryChanged('');
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
    return Container(
      child: Center(
        child: Text('Search Results'),
      ),
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
            onQueryChanged(query);
            close(context, query);
          },
        );
      },
    );
  }
}
