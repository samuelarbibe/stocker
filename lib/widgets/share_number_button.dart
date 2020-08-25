import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stocker/utilities/colors.dart';

class ShareNumberButton extends StatelessWidget {
  final value;
  final selected;
  final bool isOther;
  final Function(int) callback;

  const ShareNumberButton(
      {Key key, this.value, this.callback, this.selected, this.isOther = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: RaisedButton(
          onPressed: () {
            isOther ? callback(-1) : callback(value);
          },
          color: selected == value ? AppleColors.blue : AppleColors.white4,
          shape: CircleBorder(),
          child: Text(
            value.toString(),
            style: TextStyle(
                fontSize: isOther ? 15 : 30,
                fontWeight: FontWeight.bold,
                color:
                    selected == value ? AppleColors.white2 : AppleColors.gray5),
          ),
        ),
      ),
    );
  }
}
