import 'package:app_project/domain/tag.dart';
import 'package:flutter/material.dart';

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
    required Null Function(dynamic tagId) onTagUnselected,
    required Null Function(dynamic selectedTags) onTagChanged,
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
