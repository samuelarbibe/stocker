import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stocker/utilities/colors.dart';

class MediumStockCard extends StatefulWidget {
  final String imgDir;
  final String name;
  final String description;
  final double height;
  final bool isCurrent;

  MediumStockCard(
      {this.imgDir,
      this.name,
      this.description,
      this.height = 300,
      this.isCurrent = true});

  @override
  MediumStockCardState createState() => MediumStockCardState();
}

class MediumStockCardState extends State<MediumStockCard> {
  final double margin = 7;
  final double borderRadius = 5;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.widget.height,
      margin: EdgeInsets.fromLTRB(margin, 0, margin, margin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          AnimatedOpacity(
            opacity: this.widget.isCurrent ? 1.0 : 0.0,
            duration: Duration(milliseconds: 500),
            child: buildCardHeader(),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: NetworkImage(this.widget.imgDir),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCardHeader() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              child: Text(
                this.widget.name,
                style: TextStyle(
                    color: AppleColors.gray6,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    height: 1.5),
              ),
            ),
            Container(
              child: Text(
                this.widget.description,
                style: TextStyle(
                  color: AppleColors.gray1,
                  fontSize: 16,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
