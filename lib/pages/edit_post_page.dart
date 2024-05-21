// edit_post_screen.dart
import 'dart:io';

import 'package:app_project/domain/tag.dart';
import 'package:app_project/pages/post_create_page.dart';
import 'package:app_project/services/postService.dart';
import 'package:app_project/services/tagService.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditPostScreen extends StatefulWidget {
  final String postId;

  const EditPostScreen({required this.postId});

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  late final _contentController = TextEditingController();
  late final _imageList = <File>[];
  late var _tagsList = <Tag>[];
  late final _selectedTags = <String>[];
  late final postService = PostService();

  @override
  void initState() {
    super.initState();
    _fetchTags();
    _fetchPostDetails();
  }

  Future<void> _fetchTags() async {
    final tags = await TagService().getAllTags();
    setState(() {
      _tagsList = tags;
    });
  }

  Future<void> _fetchPostDetails() async {
    final post = await postService.getPostById(widget.postId);
    setState(() {
      _contentController.text = post.content;
      _imageList
          .addAll(post.imageUrl.map((url) => File.fromUri(Uri.parse(url))));
      _selectedTags.addAll(post.tags.map((tag) => tag.id));
    });
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

  void _updatePost() {
    if (_validateForm()) {
      String content = _contentController.text;
      List<File> imageList = _imageList;
      List<Tag> selectedTagObjects =
          _tagsList.where((tag) => _selectedTags.contains(tag.id)).toList();
      postService.updatePost(widget.postId, content, imageList, _selectedTags);
    } else {
      // Show error message or handle validation error
      print("Form validation failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Post'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _selectImages,
                  child: Text('Select Images'),
                ),
                ElevatedButton(
                  onPressed: _selectTags,
                  child: Text('Select Tags'),
                ),
              ],
            ),
            SizedBox(height: 20),
            ImageListWidget(
              images: _imageList,
              onRemoveImage: _removeImage,
            ),
            SizedBox(height: 20),
            SelectedTagsWidget(
              tags: _tagsList
                  .where((tag) => _selectedTags.contains(tag.id))
                  .toList(),
              onTagUnselected: (tagId) {
                setState(() {
                  _selectedTags.remove(tagId);
                });
              },
              selectedTags: [],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updatePost,
              child: Text('Update Post'),
            ),
          ],
        ),
      ),
    );
  }
}
