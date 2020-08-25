import 'package:flutter/material.dart';
import 'package:stocker/utilities/colors.dart';

class DailyChange extends StatelessWidget {
  const DailyChange({
    Key key,
    @required this.percentage,
    @required this.fontSize,
    this.iconSize = 20,
    this.fontWeight = FontWeight.normal,
  }) : super(key: key);

  final double percentage;
  final double fontSize;
  final FontWeight fontWeight;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final Color accentColor =
        percentage > 0 ? AppleColors.red : AppleColors.green;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        percentage > 0
            ? Icon(
                Icons.arrow_drop_down,
                color: accentColor,
                size: iconSize,
              )
            : Icon(
                Icons.arrow_drop_up,
                color: accentColor,
                size: iconSize,
              ),
        Text(
          '${percentage.toStringAsFixed(2)}%',
          style: TextStyle(
            color: accentColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
      ],
    );
  }
}
