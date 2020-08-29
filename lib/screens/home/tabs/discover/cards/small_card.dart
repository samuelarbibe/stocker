import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stocker/models/stock.dart';
import 'package:stocker/screens/home/tabs/discover/stock_screens/stock_page.dart';
import 'package:stocker/utilities/colors.dart';
import 'package:stocker/widgets/daily_change.dart';

class SmallCard extends StatelessWidget {
  final double topMargin = 10;
  final double borderRadius = 8;
  final double cardHeight = 80;

  final Stock stock;
  final double horizontalPadding;

  const SmallCard({this.stock, this.horizontalPadding = 10});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: cardHeight,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.fromLTRB(
          horizontalPadding, topMargin, horizontalPadding, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                buildStockIcon(),
                buildStockDescription(this.stock.quote.change),
              ],
            ),
          ),
          buildViewButton(context)
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppleColors.gray1.withOpacity(0.2),
            blurRadius: 15,
          ),
        ],
      ),
    );
  }

  Widget buildViewButton(BuildContext context) {
    return Container(
      height: 28,
      width: 70,
      child: FlatButton(
        color: Colors.grey[200],
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
    );
  }

  Widget buildStockDescription(double percentage) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    this.stock.name,
                    style: TextStyle(
                        color: AppleColors.gray5,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1.5),
                  ),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${this.stock.symbol} | ${this.stock.quote.currentPrice} | ',
                        style: TextStyle(
                          color: AppleColors.gray1,
                          fontSize: 13,
                          height: 1.0,
                        ),
                      ),
                      DailyChange(
                          percentage: this.stock.quote.change, fontSize: 13),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStockIcon() {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        width: double.infinity,
        child: Image.network(
          stock.logo,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
