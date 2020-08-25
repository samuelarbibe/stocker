import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:stocker/models/portfolio_history.dart';
import 'package:stocker/models/time_span.dart';
import 'package:stocker/models/candles.dart';
import 'package:stocker/widgets/chart/quote_series.dart';

class QuoteChart extends StatefulWidget {
  final List<charts.Series<QuoteSeries, DateTime>> seriesList;
  final TimeSpan timeSpan;
  QuoteChart(this.seriesList, this.timeSpan);

  factory QuoteChart.fromCandles(Candles candles, TimeSpan timeSpan) {
    List<QuoteSeries> quoteList = [];

    candles.closed.asMap().forEach((index, price) {
      quoteList.add(QuoteSeries(
        value: price.toDouble(),
        time: DateTime.fromMillisecondsSinceEpoch(
            candles.timestamp[index] * 1000),
      ));
    });

    return QuoteChart(
      [
        charts.Series<QuoteSeries, DateTime>(
          id: 'Price',
          domainFn: (QuoteSeries quote, _) => quote.time,
          measureFn: (QuoteSeries quote, _) => quote.value,
          data: quoteList,
        ),
      ],
      timeSpan,
    );
  }

  factory QuoteChart.fromPortfolioHistory(List<PortfolioHistory> history) {
    List<QuoteSeries> quoteList = [];

    history.forEach((portflio) {
      quoteList.add(
        QuoteSeries(
          value: portflio.equity,
          time: DateTime.fromMillisecondsSinceEpoch(portflio.timestamp * 1000),
        ),
      );
    });

    return QuoteChart(
      [
        charts.Series<QuoteSeries, DateTime>(
          id: 'Price',
          domainFn: (QuoteSeries quote, _) => quote.time,
          measureFn: (QuoteSeries quote, _) => quote.value,
          data: quoteList,
        ),
      ],
      null,
    );
  }

  @override
  State<StatefulWidget> createState() => SelectionCallbackState();
}

class SelectionCallbackState extends State<QuoteChart> {
  DateTime time;
  num measure;
  double currentSliderValue;

  onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    DateTime time;
    num measure;

    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum.time;
      measure = selectedDatum.first.datum.value;
    }

    setState(() {
      time = time;
      measure = measure;
    });
  }

  @override
  void initState() {
    super.initState();

    currentSliderValue = 100;
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      SizedBox(
        height: 200.0,
        child: charts.TimeSeriesChart(
          widget.seriesList,
          animate: false,
          selectionModels: [
            charts.SelectionModelConfig(
              type: charts.SelectionModelType.info,
              changedListener: onSelectionChanged,
            )
          ],
          primaryMeasureAxis: charts.NumericAxisSpec(
            tickProviderSpec:
                charts.BasicNumericTickProviderSpec(zeroBound: false),
          ),
        ),
      ),
    ];

    if (widget.timeSpan != null) {
      double priceToday = widget.seriesList.last.data.last.value;
      double priceThen = widget.seriesList.first.data.first.value;
      double change = priceToday / priceThen;

      children.add(
        Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "If you were to invest ",
                  ),
                  Text(
                    '${currentSliderValue.toInt()}\$ ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '${widget.timeSpan.asReadableString} ago',
                  ),
                ],
              ),
              Slider(
                value: currentSliderValue,
                min: 0,
                max: 1000,
                divisions: 100,
                label: currentSliderValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    currentSliderValue = value;
                  });
                },
              ),
              Text('you would have '),
              Text(
                '${(currentSliderValue * change).toStringAsFixed(2)}\$ ',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text('left today'),
            ],
          ),
        ),
      );
    }

    return Column(children: children);
  }
}
