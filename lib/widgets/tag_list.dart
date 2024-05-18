import 'package:app_project/services/tagService.dart';
import 'package:flutter/material.dart';
import 'package:app_project/domain/tag.dart';

typedef OnTagSelected = void Function(Tag tag);

class TagList extends StatefulWidget {
  final OnTagSelected onTagSelected;

  TagList({required this.onTagSelected});

  @override
  _TagListState createState() => _TagListState();
}

class _TagListState extends State<TagList> {
  final TagService _tagService = TagService();
  List<Tag> _tags = []; // List of tags
  ValueNotifier<Tag?> _selectedTag =
      ValueNotifier<Tag?>(null); // Currently selected tag

  @override
  void initState() {
    super.initState();
    _loadTags();
  }

  Future<void> _loadTags() async {
    final tags = await _tagService.getAllTags();
    setState(() {
      _tags = tags;
    });
  }

  void _onTagSelected(Tag tag) {
    _selectedTag.value = tag; // Update the selected tag
    widget.onTagSelected(tag); // Call the onTagSelected callback
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _selectedTag,
      builder: (context, selectedTag, child) {
        return Container(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _tags.length,
            itemBuilder: (context, index) {
              final tag = _tags[index];
              final isSelected = tag == selectedTag;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      _onTagSelected(tag);
                    },
                    child: Chip(
                      label: Center(
                        child: Text(tag.tagName),
                      ),
                      backgroundColor:
                          isSelected ? Colors.blue : Colors.grey.shade200,
                      labelStyle: TextStyle(
                        fontSize: 16,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
