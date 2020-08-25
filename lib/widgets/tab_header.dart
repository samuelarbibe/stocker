import 'package:flutter/material.dart';

class TabHeader extends StatelessWidget {
  const TabHeader({
    Key key,
    @required double sidePadding,
    @required this.text,
    this.imageUrl = "",
  })  : sidePadding = sidePadding,
        super(key: key);

  final double sidePadding;
  final String text;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        sidePadding,
        0,
        sidePadding,
        imageUrl != "" ? 20 : 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            text,
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          imageUrl != "" ? buildProfilePic() : Container(),
        ],
      ),
    );
  }

  Container buildProfilePic() {
    return Container(
      height: 40,
      width: 40,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
