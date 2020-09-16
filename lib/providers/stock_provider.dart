import 'package:stocker/models/portfolio_history.dart';
import 'package:stocker/models/position.dart';
import 'package:stocker/models/stock.dart';
import 'package:stocker/models/stock_model.dart';
import 'package:stocker/services/eod/eod_service.dart';
import 'package:stocker/services/finhub/finhub_service.dart';
import 'package:stocker/services/firebase/database/stock_database_service.dart';
import 'package:stocker/services/service_handler.dart';

const MARKET_PRICE = "regularMarketPrice";
const CHANGE = "regularMarketChangePercent";
const SHORT_NAME = "shortName";

class StockProvider {
  static Future<Stock> getStock(StockModel stockModel) async {
    FinhubService finhubService = FinhubService(stockModel.symbol);

    return await Future.wait([
      finhubService.getProfile(),
      finhubService.getQuote(),
      finhubService.getRecommendation()
    ]).then((values) {
      return Stock.fromData(stockModel, values[0], values[1], values[2]);
    });
  }

  static Future<List<Stock>> getAllStocksFromDb() async {
    return StockDatabaseService()
        .allStocksData
        .then((value) => Future.wait(value.map(getStock)))
        .catchError((err) =>
            throw Exception('Could not load all stocks from db: $err'));
  }

  static Future<List<Position>> getAllPositionStocks() async {
    return ServiceHandler.getAlpaca().getPositions().then((positions) async {
      List<StockModel> stockModels =
          positions.map((pos) => StockModel.fromPositionMap(pos)).toList();

      return Future.wait(stockModels.map(getStock)).then((stocks) {
        List<Position> stockPositions = [];

        for (int i = 0; i < stocks.length; i++) {
          stockPositions.add(Position.fromData(stocks[i], positions[i]));
        }

        return stockPositions;
      });
    }).catchError((err) =>
        throw Exception('Could not load all stocks from positions: $err'));
  }

  static Future<List<Stock>> getWatchlist() async {
    return ServiceHandler.getAlpaca().getWatchlists().then((watchlists) {
      if (watchlists.length == 0) {
        throw Error();
      }
      return ServiceHandler.getAlpaca()
          .getWatchlist(watchlists[0]['id'])
          .then((watchlist) {
        List<dynamic> watchlistAssets =
            watchlist['assets'] as List<dynamic> ?? [];

        List<StockModel> stockModels = watchlistAssets
            .map((asset) => StockModel.fromAssetMap(asset))
            .toList();

        return Future.wait(stockModels.map(getStock));
      });
    }).catchError((err) => throw Exception('Could not load watchlist: $err'));
  }

  static Future<List<PortfolioHistory>> getPotfolioHistory() async {
    return ServiceHandler.getAlpaca()
        .getPortfolioHistory()
        .then((portfolioHistory) {
      List<PortfolioHistory> history = [];

      int length = portfolioHistory['timestamp'].length;

      for (int i = 0; i < length; i++) {
        history.add(
          PortfolioHistory(
            timestamp: portfolioHistory['timestamp'][i],
            equity: portfolioHistory['equity'][i].toDouble(),
            profitLoss: portfolioHistory['profit_loss'][i].toDouble(),
            profitLossPct: portfolioHistory['profit_loss_pct'][i].toDouble(),
          ),
        );
      }

      return history;
    }).catchError(
            (err) => throw Exception('Could not load portfolio history: $err'));
  }

  static Future<List<Stock>> searchStock(String query) async {
    return EodService().searchStocks(query).then((results) {
      if (results.length > 0) {
        List<StockModel> stockModels = results
            .map((result) => StockModel.fromSearchResult(result))
            .toList();

        return Future.wait(stockModels.map(getStock));
      }
      return [];
    }).catchError(throw Exception('Could not load Query results'));
  }
}
