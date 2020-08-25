/// Simple pie chart with outside labels example.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:stocker/models/recommendation.dart';

class RecommendationChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  RecommendationChart(this.seriesList, {this.animate = false});

  factory RecommendationChart.fromRecommendations(
      Recommendation recommendation) {
    int sum = recommendation.buy + recommendation.sell + recommendation.hold;

    List<LinearRecommendations> data = [
      LinearRecommendations(
          RecommendedAction.BUY, (recommendation.buy / sum * 100).toInt()),
      LinearRecommendations(
          RecommendedAction.SELL, (recommendation.sell / sum * 100).toInt()),
      LinearRecommendations(
          RecommendedAction.HOLD, (recommendation.hold / sum * 100).toInt()),
    ];

    return RecommendationChart([
      charts.Series<LinearRecommendations, int>(
          id: 'Recommendations',
          domainFn: (LinearRecommendations recs, _) => recs.action.index,
          measureFn: (LinearRecommendations recs, _) => recs.percent,
          data: data,
          colorFn: (LinearRecommendations row, _) {
            switch (row.action) {
              case RecommendedAction.BUY:
                return charts.Color.fromHex(code: '#34c759');
                break;
              case RecommendedAction.SELL:
                return charts.Color.fromHex(code: '#ff3b30');
                break;
              case RecommendedAction.HOLD:
                return charts.Color.fromHex(code: '#ffcc00');
                break;
            }
            return charts.Color.fromHex(code: '#34c759');
          },
          // Set a label accessor to control the text of the arc label.
          labelAccessorFn: (LinearRecommendations row, _) {
            String action = '';

            switch (row.action) {
              case RecommendedAction.BUY:
                action = 'Buy';
                break;
              case RecommendedAction.SELL:
                action = 'Sell';
                break;
              case RecommendedAction.HOLD:
                action = 'Hold';
                break;
            }

            return '$action : ${row.percent}%';
          })
    ]);
  }
  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(
      seriesList,
      animate: animate,
      defaultRenderer: new charts.ArcRendererConfig(
        arcWidth: 60,
        arcRendererDecorators: [charts.ArcLabelDecorator()],
      ),
    );
  }
}

enum RecommendedAction { SELL, BUY, HOLD }

class LinearRecommendations {
  final RecommendedAction action;
  final int percent;

  LinearRecommendations(this.action, this.percent);
}
