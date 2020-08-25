import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stocker/models/stock.dart';
import 'package:stocker/models/user.dart';
import 'package:stocker/providers/stock_provider.dart';
import 'package:stocker/screens/home/tabs/discover/stock_lists/card_list.dart';
import 'package:stocker/screens/home/tabs/discover/stock_lists/stock_list.dart';
import 'package:stocker/widgets/connection_failed.dart';
import 'package:stocker/widgets/tab_header.dart';

class Discover extends StatefulWidget {
  final User user;

  const Discover({Key key, this.user}) : super(key: key);

  @override
  DiscoverState createState() => DiscoverState();
}

class DiscoverState extends State<Discover> {
  final double sidePadding = 20.0;
  List<Stock> stockList = [];
  bool isStockListLoading;
  bool isCardListLoading;
  bool errorLoading;

  @override
  void initState() {
    super.initState();

    isStockListLoading = true;
    isCardListLoading = true;
    errorLoading = false;

    loadStocks();
  }

  void loadStocks() async {
    try {
      final stockResponse = await StockProvider.getAllStocksFromDb();
      if (stockResponse == null || stockResponse.length == 0) {
        throw Error();
      }
      stockList = stockResponse;

      setState(() {
        isStockListLoading = false;
        isCardListLoading = false;
      });
    } catch (e) {
      print("Error: " + e.toString());
      setState(() {
        errorLoading = true;
      });
    }
  }

  void callBack() {
    isStockListLoading = true;
    isCardListLoading = true;
    errorLoading = false;
    setState(() {
      loadStocks();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (errorLoading)
      return Center(
        child: ConnectionFailed(
          retryCallback: callBack,
        ),
      );

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 60.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TabHeader(
                sidePadding: sidePadding,
                text: 'Discover',
                imageUrl: widget.user.image),
            CardList(
              stockList: stockList,
              isLoading: isCardListLoading,
            ),
            StockList(
              stockList: stockList,
              isLoading: isStockListLoading,
            )
          ],
        ),
      ),
    );
  }
}
