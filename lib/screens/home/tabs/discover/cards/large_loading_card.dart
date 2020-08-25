import 'package:content_placeholder/content_placeholder.dart';
import 'package:flutter/material.dart';

class LargeLoadingCard extends StatelessWidget {
  final EdgeInsets margin = EdgeInsets.symmetric(horizontal: 5);
  final double borderRadius = 7;

  final double height;

  LargeLoadingCard({
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin,
      child: ContentPlaceholder(
        height: height,
        borderRadius: borderRadius,
        bgColor: Colors.grey[100],
        spacing: EdgeInsets.all(0),
      ),
    );
  }
}
