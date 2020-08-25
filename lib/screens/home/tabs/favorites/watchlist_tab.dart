import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stocker/models/stock.dart';
import 'package:stocker/providers/stock_provider.dart';
import 'package:stocker/screens/home/tabs/discover/stock_lists/stock_list.dart';
import 'package:stocker/widgets/connection_failed.dart';
import 'package:stocker/widgets/stocker_loader.dart';
import 'package:stocker/widgets/tab_header.dart';

class WatchList extends StatefulWidget {
  WatchList({
    Key key,
  }) : super(key: key);

  @override
  _WatchListState createState() => _WatchListState();
}

class _WatchListState extends State<WatchList> {
  bool loading;
  bool errorLoading;
  List<Stock> watchlist;

  @override
  void initState() {
    super.initState();

    loadAssets();
  }

  void loadAssets() async {
    try {
      setState(() {
        loading = true;
        errorLoading = false;
      });

      watchlist = await StockProvider.getWatchlist();
    } catch (err) {
      print(err);
      errorLoading = true;
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (errorLoading) {
      return ConnectionFailed(
        retryCallback: loadAssets,
      );
    }

    if (loading) {
      return StockerLoader(
        withLogo: false,
      );
    }

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 60.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TabHeader(sidePadding: 30, text: 'Favorites'),
            Container(
              child: errorLoading
                  ? Center(
                      child: ConnectionFailed(
                        retryCallback: loadAssets,
                      ),
                    )
                  : StockList(
                      stockList: watchlist,
                      isLoading: loading,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
