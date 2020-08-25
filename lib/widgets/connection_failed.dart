import 'package:flutter/material.dart';
import 'package:stocker/utilities/colors.dart';
import 'package:stocker/widgets/button.dart';

class ConnectionFailed extends StatefulWidget {
  final VoidCallback retryCallback;

  ConnectionFailed({Key key, this.retryCallback}) : super(key: key);

  @override
  ConnectionFailedState createState() => ConnectionFailedState();
}

class ConnectionFailedState extends State<ConnectionFailed> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Connection Failed',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: AppleColors.gray6),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              'Please check your internet connection, and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppleColors.gray2),
            ),
          ),
          Container(
            child: Button(
              callback: widget.retryCallback,
              text: 'Reconnect',
            ),
          ),
        ],
      ),
    );
  }
}
