// home.dart
import 'package:app_project/domain/tag.dart';
import 'package:app_project/services/tagService.dart';
import 'package:flutter/material.dart';
import '../services/postService.dart';
import '../pages/post_detail_page.dart';
import '../domain/post.dart';
import '../widgets/post.dart';

class Home extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  final PostService _postRepository = PostService();
  final TagService _tagService = TagService();
  Tag? _selectedTag;

  void _onTagSelected(Tag tag) {
    setState(() {
      _selectedTag = tag;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        children: [
          TagList(
            tagService: _tagService,
            onTagSelected: _onTagSelected,
          ),
          Expanded(
            child: PostList(
              postRepository: _postRepository,
              selectedTag: _selectedTag,
            ),
          ),
        ],
      ),
    );
  }
}

// tag_list.dart
class TagList extends StatefulWidget {
  final TagService tagService;
  final ValueChanged<Tag> onTagSelected;
  final Tag? selectedTag;

  const TagList({
    Key? key,
    required this.tagService,
    required this.onTagSelected,
    this.selectedTag,
  }) : super(key: key); // Add 'Key?' and 'super(key: key)'

  @override
  _TagListState createState() => _TagListState();
}

class _TagListState extends State<TagList> {
  List<Tag> _tags = [];

  @override
  void initState() {
    super.initState();
    _loadTags();
  }

  Future<void> _loadTags() async {
    final tags = await widget.tagService.getAllTags();
    setState(() {
      _tags = tags;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _tags.length,
        itemBuilder: (context, index) {
          final tag = _tags[index];
          final isSelected = tag == widget.selectedTag;

          return TagChip(
            tag: tag,
            isSelected: isSelected,
            onTap: () => widget.onTagSelected(tag),
          );
        },
      ),
    );
  }
}

// tag_chip.dart
class TagChip extends StatelessWidget {
  final Tag tag;
  final bool isSelected;
  final VoidCallback onTap;

  TagChip({required this.tag, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: onTap,
          child: Chip(
            label: Center(
              child: Text(tag.tagName),
            ),
            backgroundColor: isSelected ? Colors.blue : Colors.grey.shade200,
            labelStyle: TextStyle(
              fontSize: 16,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

// post_list.dart
class PostList extends StatelessWidget {
  final PostService postRepository;
  final Tag? selectedTag;

  PostList({required this.postRepository, this.selectedTag});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getPosts(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostDetail(post: posts[index]),
                    ),
                  );
                },
                child: PostWidget(
                  post: posts[index],
                  postId: posts[index].id,
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Future<List<Post>> _getPosts() async {
    if (selectedTag != null) {
      return await postRepository.getPostsByTag(selectedTag!.id);
    } else {
      return await postRepository.getPosts();
    }
  }
}
