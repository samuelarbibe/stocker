import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:stocker/utilities/colors.dart';

class StockerLoader extends StatelessWidget {
  final bool withLogo;

  const StockerLoader({Key key, this.withLogo = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          withLogo
              ? Text(
                  'S',
                  style: TextStyle(
                    height: 0.45,
                    fontSize: 90,
                    fontWeight: FontWeight.w900,
                    color: AppleColors.gray6,
                  ),
                )
              : Container(),
          Container(
            height: 30,
            alignment: Alignment.bottomCenter,
            child: SpinKitThreeBounce(
              color: AppleColors.gray6,
              size: 30.0,
            ),
          ),
        ],
      ),
    );
  }
}
