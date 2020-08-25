import 'package:stocker/models/portfolio_history.dart';
import 'package:stocker/models/position.dart';
import 'package:stocker/models/stock.dart';
import 'package:stocker/models/stock_model.dart';
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
    List<StockModel> stockList = await StockDatabaseService().allStocksData;

    return Future.wait(stockList.map(getStock));
  }

  static Future<List<Position>> getAllPositionStocks() async {
    List<dynamic> positions = await ServiceHandler.getAlpaca().getPositions();
    List<StockModel> stockModels = [];

    positions.forEach((e) {
      stockModels.add(StockModel.fromPositionMap(e));
    });

    List<Stock> stocks =
        await Future.wait(stockModels.map(getStock)).then((value) => value);

    List<Position> stockPositions = [];

    for (int i = 0; i < stocks.length; i++) {
      stockPositions.add(Position.fromData(stocks[i], positions[i]));
    }

    return stockPositions;
  }

  static Future<List<Stock>> getWatchlist() async {
    dynamic watchlistsJson = await ServiceHandler.getAlpaca().getWatchlists();
    dynamic watchlistJson =
        await ServiceHandler.getAlpaca().getWatchlist(watchlistsJson[0]['id']);

    List<dynamic> watchlist = watchlistJson['assets'] as List<dynamic> ?? [];

    List<StockModel> stockModels = [];

    watchlist.forEach((e) {
      stockModels.add(StockModel.fromAssetMap(e));
    });

    return Future.wait(stockModels.map(getStock));
  }

  static Future<List<PortfolioHistory>> getPotfolioHistory() async {
    dynamic watchlistsJson =
        await ServiceHandler.getAlpaca().getPortfolioHistory();

    List<PortfolioHistory> history = [];

    int length = watchlistsJson['timestamp'].length;

    for (int i = 0; i < length; i++) {
      history.add(
        PortfolioHistory(
          timestamp: watchlistsJson['timestamp'][i],
          equity: watchlistsJson['equity'][i].toDouble(),
          profitLoss: watchlistsJson['profit_loss'][i].toDouble(),
          profitLossPct: watchlistsJson['profit_loss_pct'][i].toDouble(),
        ),
      );
    }

    return history;
  }
}
