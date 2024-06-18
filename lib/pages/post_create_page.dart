import 'dart:io';

import 'package:app_project/domain/tag.dart';
import '../navigation_example.dart';
import 'package:app_project/services/postService.dart';
import 'package:app_project/services/tagService.dart';
import 'package:app_project/widgets/image_widget.dart';
import 'package:app_project/widgets/tag_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late final _contentController = TextEditingController();
  late final _imageList = <File>[];
  late var _tagsList = <Tag>[];
  late final _selectedTags = <String>[];
  late final postService = PostService();

  @override
  void initState() {
    super.initState();
    _fetchTags();
  }

  Future<void> _fetchTags() async {
    _tagsList = await TagService().getAllTags();
  }

  Future<void> _selectImages() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imageList.add(File(pickedImage.path));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imageList.removeAt(index);
    });
  }

  void _selectTags() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return TagSelectionDialog(
          tags: _tagsList,
          selectedTags: _selectedTags,
          onTagSelected: (tagId) {
            setState(() {
              if (!_selectedTags.contains(tagId)) {
                _selectedTags.add(tagId);
              }
            });
          },
          onTagUnselected: (tagId) {
            setState(() {
              _selectedTags.remove(tagId);
            });
          },
        );
      },
    );
  }

  bool _validateForm() {
    if (_contentController.text.isEmpty) {
      return false;
    }
    if (_imageList.isEmpty) {
      return false;
    }
    return true;
  }

  void _createPost() {
    if (_validateForm()) {
      String content = _contentController.text;
      List<File> imageList = _imageList;
      postService.createPosts(content, imageList, _selectedTags);
      _showPopup(context, "Post bài thành công");
    } else {
      print("Form validation failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Post'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ImageListWidget(
              images: _imageList,
              onRemoveImage: _removeImage,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectImages,
              child: const Text('Choose Images'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectTags,
              child: const Text('Select Tags'),
            ),
            const SizedBox(height: 20),
            SelectedTagsWidget(
              selectedTags: _selectedTags,
              tags: _tagsList,
              onTagUnselected: (tagId) {},
              onTagChanged: (selectedTags) {},
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder(
              valueListenable: _contentController,
              builder: (context, value, child) {
                return TextField(
                  controller: _contentController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: 'Write something...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createPost,
              child: const Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
}

void _showPopup(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NavigationExample(),
                ),
              );
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
