import 'dart:io';

import 'package:flutter/material.dart';

class OldImageListWidget extends StatelessWidget {
  final List<String> imageUrls;
  final Function(int) onRemoveImage;

  const OldImageListWidget({
    required this.imageUrls,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    return imageUrls.isNotEmpty
        ? Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(imageUrls[index]),
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
