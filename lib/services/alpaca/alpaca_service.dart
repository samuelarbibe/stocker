import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'alpaca-dart/lib/alpaca.dart';

// https://alpaca.markets/docs/api-documentation/api-v2/

class AlpacaService {
  AlpacaApi alpacaApi;

  Future<String> connect(
      String keyId, String secretKey, bool paperTrading) async {
    alpacaApi = AlpacaApi(
      keyId: keyId,
      secretKey: secretKey,
      paperTrading: paperTrading,
    );

    final accountResponse = await alpacaApi.getAccount();
    final account = jsonDecode(accountResponse.body);

    return account['id'];
  }

  Future<Map> getAlpacaAccount() async {
    if (alpacaApi == null) return null;
    final accountResponse = await alpacaApi.getAccount();
    return jsonDecode(accountResponse.body);
  }

  void disconnect() {
    alpacaApi = null;
  }

  Future<Response> getPosition(String symbol) async {
    final response = await alpacaApi.getPosition(symbol);
    return response;
  }

  Future<Response> buy(String symbol, int value) async {
    final buyResponse = await alpacaApi.createOrder(
        symbol, value.toString(), 'buy', 'market', 'day');
    return buyResponse;
  }

  Future<List<dynamic>> getPositions() async {
    final positionsResponse = await alpacaApi.getPositions();

    if (positionsResponse.statusCode == 200) {
      return jsonDecode(positionsResponse.body);
    }
    return null;
  }

  Future<dynamic> getWatchlists() async {
    final watchlistResponse = await alpacaApi.getWatchlists();

    if (watchlistResponse.statusCode == 200) {
      return jsonDecode(watchlistResponse.body);
    }
    return null;
  }

  Future<dynamic> getWatchlist(String id) async {
    final watchlistResponse = await alpacaApi.getWatchlist(id);

    if (watchlistResponse.statusCode == 200) {
      return jsonDecode(watchlistResponse.body);
    }
    return null;
  }

  Future<dynamic> getPrimaryWatchlist() async {
    final String watchlistId = (await this.getWatchlists())[0]['id'];
    final watchlistResponse = await alpacaApi.getWatchlist(watchlistId);

    if (watchlistResponse.statusCode == 200) {
      return jsonDecode(watchlistResponse.body);
    }
    return null;
  }

  Future<dynamic> addToPrimaryWatchlist(String symbol) async {
    final String watchlistId = (await this.getWatchlists())[0]['id'];

    return this.addToWatchlist(watchlistId, symbol);
  }

  Future<dynamic> addToWatchlist(String watchlistId, String symbol) async {
    final watchlistResponse =
        await alpacaApi.addToWatchlist(watchlistId, symbol);

    if (watchlistResponse.statusCode == 200) {
      return jsonDecode(watchlistResponse.body);
    }
    return null;
  }

  Future<dynamic> removeFromWatchlist(String watchlistId, String symbol) async {
    final watchlistResponse =
        await alpacaApi.removeFromWatchlist(watchlistId, symbol);

    if (watchlistResponse.statusCode == 200) {
      return jsonDecode(watchlistResponse.body);
    }
    return null;
  }

  Future<Response> sell(String symbol) async {
    final buyResponse = await alpacaApi.closePosition(symbol);
    return buyResponse;
  }

  Future<dynamic> removeFromPrimaryWatchlist(String symbol) async {
    final String watchlistId = (await this.getWatchlists())[0]['id'];

    return this.removeFromWatchlist(watchlistId, symbol);
  }

  Future<bool> isSymbolInPrimaryWatchlist(String symbol) async {
    final dynamic watchlist = await this.getPrimaryWatchlist();

    return watchlist['assets'].any((asset) => asset['symbol'] == symbol);
  }

  Future<dynamic> getPortfolioHistory() async {
    final response = await alpacaApi.getPortfolioHistory();

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }
}
