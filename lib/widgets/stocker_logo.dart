import 'package:flutter/material.dart';
import 'package:stocker/utilities/colors.dart';

class StockerLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      "STOCKER.",
      style: TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 30,
        color: AppleColors.gray6,
      ),
    );
  }
}
