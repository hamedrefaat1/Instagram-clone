// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CacheImage extends StatelessWidget {
  final String imageUrl;

  const CacheImage({required this.imageUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: imageUrl,
      progressIndicatorBuilder: (context, url, progress) {
        return Center(
          child: CircularProgressIndicator(
            value: progress.progress,
            color: Colors.black,
          ),
        );
      },
      errorWidget: (context, url, error) => Center(
        child: Icon(Icons.error, color: Colors.red, size: 40), // أيقونة خطأ
      ),
    );
  }
}
