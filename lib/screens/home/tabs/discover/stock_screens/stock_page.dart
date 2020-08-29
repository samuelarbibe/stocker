import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_show_more/flutter_show_more.dart';
import 'package:stocker/models/position.dart';
import 'package:stocker/models/time_span.dart';
import 'package:stocker/models/candles.dart';
import 'package:stocker/models/stock.dart';
import 'package:stocker/screens/home/tabs/discover/stock_screens/buy_stock_page.dart';
import 'package:stocker/screens/home/tabs/discover/stock_screens/sell_stock_page.dart';
import 'package:stocker/screens/home/tabs/discover/stock_screens/stock_page_card.dart';
import 'package:stocker/services/finhub/finhub_service.dart';
import 'package:stocker/services/service_handler.dart';
import 'package:stocker/utilities/colors.dart';
import 'package:stocker/utilities/exceptions/no_data_exception.dart';
import 'package:stocker/widgets/chart/quote_chart.dart';
import 'package:stocker/widgets/connection_failed.dart';
import 'package:stocker/widgets/daily_change.dart';
import 'package:stocker/widgets/recommendations/recommendation_chart.dart';
import 'package:stocker/widgets/stocker_loader.dart';

class StockScreen extends StatefulWidget {
  final Stock stock;

  const StockScreen({Key key, this.stock}) : super(key: key);

  @override
  StockScreenState createState() => StockScreenState();
}

class StockScreenState extends State<StockScreen>
    with TickerProviderStateMixin {
  final double imageHeight = 300;
  final DateTime toDate = DateTime.now().toUtc().subtract(Duration(hours: 1));
  DateTime fromDate;
  String resolution;
  TimeSpan timeSpan;
  Candles candles;
  bool loadingCandles;
  bool errorLoading;
  bool noData;
  Position position;

  int quoteSelectedIndex;

  @override
  void initState() {
    super.initState();

    relaodQuoteChart();
    checkIsPosition();
  }

  void checkIsPosition() async {
    try {
      final response =
          await ServiceHandler.getAlpaca().getPosition(widget.stock.symbol);
      if (response.statusCode == 200) {
        position = Position.fromData(widget.stock, jsonDecode(response.body));
      }
    } catch (err) {
      position = null;
    }
  }

  Map<int, Widget> createSegmentChildren() {
    return TimeSpan.timeSpans
        .map((curr) => Text(curr.shortname))
        .toList()
        .asMap();
  }

  void relaodQuoteChart([int value = 1]) {
    quoteSelectedIndex = value;
    timeSpan = TimeSpan.timeSpans[value];

    fromDate = toDate.subtract(Duration(days: timeSpan.days));
    resolution = timeSpan.resolution;

    loadCandles();
  }

  Future<void> loadCandles() async {
    loadingCandles = true;
    errorLoading = false;
    noData = false;
    try {
      candles = await FinhubService(widget.stock.symbol).getCandles(
        fromDate,
        toDate,
        resolution,
      );
    } on DataException {
      print('Error: no data for given timeframe');
      noData = true;
    } on Exception {
      print('Error: could not load candles for ${widget.stock.symbol}');
      errorLoading = true;
    } finally {
      setState(() {
        loadingCandles = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppleColors.white1,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            StockPageSmallCard(
              stock: widget.stock,
            ),
            buildInfo(),
            buildDescription(),
            buildChart(),
            buildRecommendations(),
            Container(
              padding: EdgeInsets.all(30),
              child: RaisedButton(
                padding: EdgeInsets.all(20),
                color: AppleColors.blue,
                child: Text(
                  "BUY",
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                onPressed: () => {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return BuyScreen(stock: widget.stock);
                  }))
                },
              ),
            ),
            position != null
                ? Container(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
                    child: RaisedButton(
                      padding: EdgeInsets.all(20),
                      color: AppleColors.red,
                      child: Text(
                        "SELL",
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () => {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return SellScreen(position: position);
                        }))
                      },
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget buildRecommendations() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 30),
          alignment: Alignment.topLeft,
          child: Text(
            'Analyst Recommendations',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          height: 300,
          padding: EdgeInsets.symmetric(vertical: 30),
          child: RecommendationChart.fromRecommendations(
              widget.stock.recommendation),
        ),
      ],
    );
  }

  Container buildChart() {
    List<Widget> children = [];

    children.add(
      Container(
        child: CupertinoSegmentedControl(
          onValueChanged: relaodQuoteChart,
          children: createSegmentChildren(),
          selectedColor: AppleColors.blue,
          groupValue: quoteSelectedIndex,
        ),
      ),
    );

    if (errorLoading) {
      children.add(
        Container(
          child: ConnectionFailed(
            retryCallback: relaodQuoteChart,
          ),
        ),
      );
    } else if (loadingCandles) {
      children.add(
        Container(
          child: StockerLoader(
            withLogo: false,
          ),
        ),
      );
    } else if (noData) {
      children.add(
        Center(child: Text('No data for the selected timeframe.')),
      );
    } else {
      children.add(buildQuoteChart());
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children,
      ),
    );
  }

  Container buildInfo() {
    return Container(
        margin: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Text(
                    '${widget.stock.quote.currentPrice.toString()} \$',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: AppleColors.gray3,
                    ),
                  ),
                  Text(
                    'Current share price',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppleColors.gray1,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  DailyChange(
                    percentage: widget.stock.quote.change,
                    fontSize: 30,
                    iconSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                  Text(
                    'Daily change',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppleColors.gray1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Container buildQuoteChart() {
    return Container(
      child: loadingCandles
          ? StockerLoader(
              withLogo: false,
            )
          : QuoteChart.fromCandles(candles, timeSpan),
    );
  }

  Container buildDescription() {
    return Container(
      padding: EdgeInsets.all(30),
      child: AnimatedSize(
        duration: Duration(milliseconds: 100),
        vsync: this,
        alignment: Alignment.topCenter,
        child: ShowMoreText(
          widget.stock.description,
          maxLength: 110,
          style: TextStyle(
            fontSize: 17,
            color: AppleColors.gray4,
            height: 1.3,
          ),
          showMoreText: 'more',
          showMoreStyle: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppleColors.blue,
          ),
          shouldShowLessText: true,
          showLessText: 'less',
        ),
      ),
    );
  }

  Stack buildHeader(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: imageHeight,
          width: double.infinity,
          child: Hero(
            tag: widget.stock.image,
            child: Image.network(
              widget.stock.image,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(0, 40, 25, 0),
          alignment: Alignment.topRight,
          child: ClipOval(
            child: Container(
              width: 30,
              height: 30,
              color: Color.fromRGBO(240, 240, 240, 0.8),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ),
        Container(
          height: imageHeight,
          padding: EdgeInsets.all(20),
          alignment: Alignment.bottomLeft,
          // color: AppleColors.blue,
          child: Text(
            widget.stock.name,
            style: TextStyle(
                fontSize: 36.0,
                letterSpacing: 0.9,
                fontWeight: FontWeight.w800,
                color: AppleColors.white2),
          ),
        )
      ],
    );
  }
}
