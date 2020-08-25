import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:stocker/models/stock.dart';
import 'package:stocker/screens/home/tabs/discover/stock_screens/buy_stock_page.dart';
import 'package:stocker/services/service_handler.dart';
import 'package:stocker/utilities/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class StockPageSmallCard extends StatefulWidget {
  final Stock stock;

  const StockPageSmallCard({this.stock});

  @override
  StockPageSmallCardState createState() => StockPageSmallCardState();
}

class StockPageSmallCardState extends State<StockPageSmallCard> {
  final double cardHeight = 160;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();

    checkIsFavorite();
  }

  Future<void> launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  void checkIsFavorite() async {
    isFavorite = false;
    try {
      final favorite = await ServiceHandler.getAlpaca()
          .isSymbolInPrimaryWatchlist(widget.stock.symbol);
      if (favorite) {
        setState(() {
          isFavorite = true;
        });
      }
    } catch (err) {
      setState(() {
        isFavorite = true;
      });
    }
  }

  Future<void> addToWatchlist() async {
    try {
      dynamic response = ServiceHandler.getAlpaca()
          .addToPrimaryWatchlist(this.widget.stock.symbol);

      if (response != null) {
        setState(() {
          isFavorite = true;
        });
      }
    } catch (err) {
      print('Could not add to watchlist');
      setState(() {
        isFavorite = false;
      });
    }
  }

  Future<void> removeFromWatchlist() async {
    try {
      dynamic response = ServiceHandler.getAlpaca()
          .removeFromPrimaryWatchlist(this.widget.stock.symbol);

      if (response != null) {
        setState(() {
          isFavorite = false;
        });
      }
    } catch (err) {
      print('Could not remove from watchlist');
      setState(() {
        isFavorite = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: cardHeight,
      padding: EdgeInsets.fromLTRB(25, 30, 25, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                buildStockIcon(),
                buildStockDescription(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDailyChange(double percentage, {double fontSize}) {
    final Color accentColor =
        percentage.isNegative ? AppleColors.red : AppleColors.green;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        percentage.isNegative
            ? Icon(
                Icons.arrow_drop_down,
                color: accentColor,
                size: 20,
              )
            : Icon(
                Icons.arrow_drop_up,
                color: accentColor,
                size: 20,
              ),
        Text(
          '${percentage.toStringAsPrecision(2)}%',
          style: TextStyle(
            color: accentColor,
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }

  Widget buildBuyButton(BuildContext context) {
    return Container(
      height: 28,
      width: 70,
      child: FlatButton(
        color: AppleColors.blue,
        onPressed: () => {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return BuyScreen(stock: widget.stock);
          }))
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Text(
          'Buy',
          style: TextStyle(
              color: Colors.grey[200],
              fontSize: 15,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget buildStockDescription(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                buildStockName(),
                buildStockInfo(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                buildBuyButton(context),
                IconButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  alignment: Alignment.bottomRight,
                  padding: EdgeInsets.all(0),
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    size: 40,
                  ),
                  color: isFavorite ? Colors.red[400] : Colors.red[400],
                  onPressed: () {
                    isFavorite ? removeFromWatchlist() : addToWatchlist();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container buildStockName() {
    return Container(
      child: Text(
        widget.stock.name,
        style: TextStyle(
            color: AppleColors.gray5,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            height: 1.5),
      ),
    );
  }

  Container buildStockInfo() {
    return Container(
      child: Row(
        children: <Widget>[
          Text(
            '${widget.stock.symbol} | ${widget.stock.quote.currentPrice} | ',
            style: TextStyle(
              color: AppleColors.gray1,
              fontSize: 13,
              height: 1.0,
            ),
          ),
          buildDailyChange(widget.stock.quote.change, fontSize: 13)
        ],
      ),
    );
  }

  Widget buildStockIcon() {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
          width: double.infinity,
          child: Image(
            image: AdvancedNetworkImage(
              widget.stock.logo,
              fallbackAssetImage: 'assets/images/no_image.png',
              useDiskCache: true,
            ),
            fit: BoxFit.scaleDown,
          )),
    );
  }
}
