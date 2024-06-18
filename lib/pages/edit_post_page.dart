import 'dart:io';

import 'package:app_project/domain/tag.dart';
import 'package:app_project/navigation_example.dart';
import 'package:app_project/services/postService.dart';
import 'package:app_project/services/tagService.dart';
import 'package:app_project/widgets/image_widget.dart';
import 'package:app_project/widgets/tag_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditPostScreen extends StatefulWidget {
  final String postId;

  const EditPostScreen({super.key, required this.postId});

  @override
  // ignore: library_private_types_in_public_api
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  late final _contentController = TextEditingController();
  late final _imageNewList = <File>[];
  late final _imageOldUrlList = <String>[];
  late var _tagsList = <Tag>[];
  late var _selectedTags = <String>[];
  late final postService = PostService();
  late final tagService = TagService();

  @override
  void initState() {
    super.initState();
    _fetchTags();
    _fetchPostDetails();
  }

  Future<void> _fetchTags() async {
    final tags = await tagService.getAllTags();
    setState(() {
      _tagsList = tags;
    });
  }

  Future<void> _fetchPostDetails() async {
    try {
      final post = await postService.getPostById(widget.postId);
      setState(() {
        _contentController.text = post.content;
        _imageOldUrlList.addAll(post.imageUrl.map((url) => url));
        _selectedTags.addAll(post.tags.map((tag) => tag.id));
      });
    } catch (e) {
      // Handle exceptions here
      print('Error fetching post details: $e');
    }
  }

  Future<void> _selectImages() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imageNewList.add(File(pickedImage.path));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imageOldUrlList.removeAt(index);
    });
  }

  void _removeNewImage(int index) {
    setState(() {
      _imageNewList.removeAt(index);
    });
  }

  Future<void> _savePost() async {
    try {
      await postService.updatePost(widget.postId, _contentController.text,
          _imageNewList, _imageOldUrlList, _selectedTags);
      // ignore: use_build_context_synchronously
      _showPopup(context, "Chỉnh sửa thành công!");
    } catch (e) {
      // Handle exceptions here
      print('Error saving post: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                _imageOldUrlList.isNotEmpty
                    ? Expanded(
                        child: OldImageListWidget(
                          imageUrls: _imageOldUrlList,
                          onRemoveImage: _removeImage,
                        ),
                      )
                    : Container(),
                const SizedBox(width: 8.0),
                _imageNewList.isNotEmpty
                    ? Expanded(
                        child: ImageListWidget(
                          images: _imageNewList,
                          onRemoveImage: _removeNewImage,
                        ),
                      )
                    : const Text('No images selected'),
              ],
            ),
            SelectedTagsWidget(
              tags: _tagsList,
              selectedTags: _selectedTags,
              onTagChanged: (selectedTags) {
                setState(() {
                  _selectedTags = selectedTags;
                });
              },
              onTagUnselected: (tagId) {},
            ),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: _selectImages,
              child: const Text('Add Images'),
            ),
            ElevatedButton(
              onPressed: _savePost,
              child: const Text('Save'),
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
