// post_screen.dart
import 'dart:io';

import 'package:app_project/domain/tag.dart';
import 'package:app_project/services/postService.dart';
import 'package:app_project/services/tagService.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostScreen extends StatefulWidget {
  @override
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
    } else {
      // Show error message or handle validation error
      print("Form validation failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ImageListWidget(
              images: _imageList,
              onRemoveImage: _removeImage,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectImages,
              child: Text('Choose Images'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectTags,
              child: Text('Select Tags'),
            ),
            SizedBox(height: 20),
            SelectedTagsWidget(
              selectedTags: _selectedTags,
              tags: _tagsList,
            ),
            SizedBox(height: 20),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createPost,
              child: Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
}

// image_list_widget.dart
class ImageListWidget extends StatelessWidget {
  final List<File> images;
  final void Function(int) onRemoveImage;

  const ImageListWidget({
    required this.images,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    return images.isNotEmpty
        ? Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: FileImage(images[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => onRemoveImage(index),
                      ),
                    ),
                  ],
                );
              },
            ),
          )
        : Container();
  }
}

// tag_selection_dialog.dart
class TagSelectionDialog extends StatefulWidget {
  final List<Tag> tags;
  final List<String> selectedTags;
  final void Function(String) onTagSelected;
  final void Function(String) onTagUnselected;

  const TagSelectionDialog({
    required this.tags,
    required this.selectedTags,
    required this.onTagSelected,
    required this.onTagUnselected,
  });

  @override
  _TagSelectionDialogState createState() => _TagSelectionDialogState();
}

class _TagSelectionDialogState extends State<TagSelectionDialog> {
  late final _selectedTags = Set<String>.from(widget.selectedTags);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Select Tags"),
      content: SingleChildScrollView(
        child: Column(
          children: widget.tags.map((tag) {
            return CheckboxListTile(
              title: Text(tag.tagName),
              value: _selectedTags.contains(tag.id),
              onChanged: (bool? value) {
                setState(() {
                  if (value != null) {
                    if (value) {
                      _selectedTags.add(tag.id);
                      widget.onTagSelected(tag.id);
                    } else {
                      _selectedTags.remove(tag.id);
                      widget.onTagUnselected(tag.id);
                    }
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Done"),
        ),
      ],
    );
  }
}

// selected_tags_widget.dart
class SelectedTagsWidget extends StatelessWidget {
  final List<String> selectedTags;
  final List<Tag> tags;

  const SelectedTagsWidget({
    required this.selectedTags,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: selectedTags.map((tagId) {
        final tag = tags.firstWhere((t) => t.id == tagId);
        return Chip(
          label: Text(tag.tagName),
          onDeleted: () {
            // TODO: Remove tag from selectedTags
          },
        );
      }).toList(),
    );
  }
}
