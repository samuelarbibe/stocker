import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stocker/models/stock.dart';
import 'package:stocker/providers/stock_provider.dart';
import 'package:stocker/screens/home/tabs/discover/stock_lists/stock_list.dart';
import 'package:stocker/utilities/colors.dart';
import 'package:stocker/widgets/stocker_loader.dart';
import 'package:stocker/widgets/tab_header.dart';

class Search extends StatefulWidget {
  Search({
    Key key,
  }) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool loading;
  bool errorLoading;
  List<Stock> results;

  @override
  void initState() {
    super.initState();
    loading = false;
    errorLoading = false;
    results = [];
  }

  void searchStock(query) async {
    try {
      setState(() {
        loading = true;
        errorLoading = false;
      });

      results = await StockProvider.searchStock(query);
      if (results == null || results.length == 0) {
        results = [];
        throw Exception("No results found");
      }
    } catch (err) {
      print(err);
      errorLoading = true;
      results = [];
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 60.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TabHeader(sidePadding: 30, text: 'Search'),
            Container(
              padding: EdgeInsets.all(30),
              child: CupertinoTextField(
                placeholder: "Search by Symbol, Name and more",
                padding: EdgeInsets.all(10),
                autocorrect: false,
                onSubmitted: (query) {
                  if (query != "") searchStock(query);
                },
                prefix: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.search,
                    color: AppleColors.gray1,
                  ),
                ),
              ),
            ),
            Container(
              child: loading
                  ? StockerLoader(
                      withLogo: false,
                    )
                  : StockList(
                      stockList: results,
                      isLoading: loading,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
