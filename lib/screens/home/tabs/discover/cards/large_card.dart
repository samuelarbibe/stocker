import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:stocker/models/stock.dart';
import 'package:stocker/screens/home/tabs/discover/stock_screens/stock_page.dart';
import 'package:stocker/utilities/colors.dart';

class LargeStockCard extends StatelessWidget {
  final EdgeInsets margin = EdgeInsets.symmetric(horizontal: 5);
  final double borderRadius = 7;

  final Stock stock;
  final double height;

  LargeStockCard({
    this.stock,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Container(
              height: height,
              child: Hero(
                tag: stock.image,
                child: Image(
                  image: AdvancedNetworkImage(
                    stock.image,
                    useDiskCache: true,
                    fallbackAssetImage: 'assets/images/no_image.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            buildBottomBar(context)
          ],
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  Widget buildBottomBar(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: AppleColors.gray4.withOpacity(0.5),
          ),
          child: SizedBox(
            height: 80,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        buildStockIcon(),
                        buildStockDescription(),
                      ],
                    ),
                  ),
                  buildViewButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildViewButton(BuildContext context) {
    return Container(
      child: ButtonTheme(
        height: 28,
        minWidth: 70,
        child: RaisedButton(
          color: Colors.white,
          onPressed: () => {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return StockScreen(stock: this.stock);
            }))
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Text(
            'View',
            style: TextStyle(
                color: AppleColors.blue,
                fontSize: 15,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget buildStockDescription() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                this.stock.name,
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    height: 1.5),
              ),
            ),
            Container(
              child: Text(
                this.stock.symbol,
                style: TextStyle(
                  color: AppleColors.gray1,
                  fontSize: 13,
                  height: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStockIcon() {
    return Container(
        child: Hero(
      tag: this.stock.logo,
      child: Image.network(
        this.stock.logo,
      ),
    ));
  }
}
