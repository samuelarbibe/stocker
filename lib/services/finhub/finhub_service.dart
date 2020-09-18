import 'dart:convert';

import 'package:http/http.dart';
import 'package:stocker/models/candles.dart';
import 'package:stocker/models/profile.dart';
import 'package:stocker/models/quote.dart';
import 'package:stocker/models/recommendation.dart';
import 'package:stocker/services/finhub/finhub_config.dart';
import 'package:stocker/utilities/exceptions/no_data_exception.dart';

// https://finnhub.io/docs/api

class FinhubService {
  final FinhubWrapper finhubWrapper = FinhubWrapper();
  final String symbol;

  FinhubService(this.symbol);

  Future<Profile> getProfile() async {
    final response = await finhubWrapper.fetchProfile(symbol);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return Profile.fromJson(data);
    } else {
      throw new Exception('Could not load profile for symbol $symbol');
    }
  }

  Future<Quote> getQuote() async {
    final response = await finhubWrapper.fetchQuote(symbol);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return Quote.fromJson(data);
    } else {
      throw Exception('Could not load Quote for $symbol');
    }
  }

  Future<Recommendation> getRecommendation() async {
    final response = await finhubWrapper.fetchRecommendation(symbol);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data.length > 0) {
        return Recommendation.fromJson(data[0]);
      }
    } else {
      throw new Exception('Could not load recommendation for symbol $symbol');
    }
  }

  Future<Candles> getCandles(
      DateTime from, DateTime to, String resolution) async {
    final fromUnix = (from.millisecondsSinceEpoch / 1000).floor().toString();
    final toUnix = (to.millisecondsSinceEpoch / 1000).floor().toString();

    final response =
        await finhubWrapper.fetchCandles(symbol, fromUnix, toUnix, resolution);

    var data = json.decode(response.body);
    if (data['s'] == 'no_data') {
      throw new DataException(
          'No data for the given timestamp for symbol $symbol');
    } else if (data['c'] == null) {
      throw Exception('Could not load candles for symbol $symbol');
    } else if (response.statusCode == 200) {
      return Candles.fromJson(json.decode(response.body));
    } else {
      throw Exception('Unknown Error');
    }
  }
}

class FinhubWrapper {
  Future<Response> fetchProfile(String symbol) {
    return get(
        'https://finnhub.io/api/v1/stock/profile2?symbol=$symbol&token=$FINHUB_API_KEY');
  }

  Future<Response> fetchQuote(String symbol) async {
    return get(
        'https://finnhub.io/api/v1/quote?symbol=$symbol&token=$FINHUB_API_KEY');
  }

  Future<Response> fetchRecommendation(String symbol) async {
    return get(
        'https://finnhub.io/api/v1/stock/recommendation?symbol=$symbol&token=$FINHUB_API_KEY');
  }

  Future<Response> fetchCandles(
      String symbol, String from, String to, dynamic resolution) async {
    return get(
        'https://finnhub.io/api/v1/stock/candle?symbol=$symbol&resolution=$resolution&from=$from&to=$to&token=$FINHUB_API_KEY');
  }
}
