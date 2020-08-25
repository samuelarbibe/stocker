import 'package:flutter/material.dart';
import 'package:content_placeholder/content_placeholder.dart';

class SmallLoadingCard extends StatelessWidget {
  final double borderRadius = 8;
  final double cardHeight = 80;

  final double horizontalPadding;
  final double verticalMargin;

  const SmallLoadingCard(
      {Key key, this.horizontalPadding = 10, this.verticalMargin = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding, vertical: verticalMargin),
      child: ContentPlaceholder(
        height: cardHeight,
        borderRadius: borderRadius,
        bgColor: Colors.grey[100],
        spacing: EdgeInsets.all(0),
      ),
    );
  }
}
