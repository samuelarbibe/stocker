import 'package:flutter/material.dart';
import 'package:stocker/utilities/colors.dart';

class Button extends StatefulWidget {
  final VoidCallback callback;
  final String text;

  Button({Key key, this.callback, this.text}) : super(key: key);

  @override
  ButtonState createState() => ButtonState();
}

class ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
      color: AppleColors.gray5,
      onPressed: widget.callback,
      child: Text(
        widget.text,
        style: TextStyle(
            fontWeight: FontWeight.w700, color: Colors.white70, fontSize: 15),
      ),
    );
  }
}
