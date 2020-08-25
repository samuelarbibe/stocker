import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:stocker/utilities/colors.dart';

class SuccessScreen extends StatefulWidget {
  final int loadingTimer;
  final int successTimer;

  final VoidCallback successCallback;

  SuccessScreen(
      {this.loadingTimer = 2000,
      this.successTimer = 2000,
      this.successCallback});

  @override
  SuccessScreenState createState() => SuccessScreenState();
}

class SuccessScreenState extends State<SuccessScreen> {
  bool loading = true;
  bool success = false;

  @override
  void initState() {
    super.initState();

    loadingTimer();
  }

  void loadingTimer() async {
    Timer(Duration(milliseconds: widget.loadingTimer), () {
      finishedTimer();
    });
  }

  void finishedTimer() async {
    setState(() {
      success = true;
      loading = false;
    });
    Timer(Duration(milliseconds: widget.successTimer), () {
      widget.successCallback();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppleColors.white1,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          loading
              ? Container(
                  height: 30,
                  alignment: Alignment.bottomCenter,
                  child: SpinKitThreeBounce(
                    color: AppleColors.gray6,
                    size: 30.0,
                  ),
                )
              : Container(
                  height: 30,
                  alignment: Alignment.bottomCenter,
                  child: Icon(
                    Icons.check,
                    size: 60,
                    color: AppleColors.blue,
                  ),
                ),
        ],
      ),
    );
  }
}
