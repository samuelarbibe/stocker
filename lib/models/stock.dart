import 'package:stocker/models/profile.dart';
import 'package:stocker/models/quote.dart';
import 'package:stocker/models/recommendation.dart';
import 'package:stocker/models/stock_model.dart';

class Stock {
  final String name;
  final String description;
  final String symbol;
  final String webUrl;
  final String logo;
  final String image;
  final String industry;
  final Quote quote;
  final Recommendation recommendation;

  Stock({
    this.recommendation,
    this.name,
    this.description,
    this.symbol,
    this.webUrl,
    this.logo,
    this.image,
    this.industry,
    this.quote,
  });

  factory Stock.fromOther(Stock other) {
    return Stock(
      recommendation: other.recommendation,
      name: other.name,
      description: other.description,
      symbol: other.symbol,
      webUrl: other.webUrl,
      logo: other.logo,
      image: other.image,
      industry: other.industry,
      quote: other.quote,
    );
  }

  factory Stock.fromData(
      StockModel dbData, Profile profile, Quote quote, Recommendation rec) {
    return Stock(
      name: dbData.name ?? profile.name,
      description:
          dbData.description ?? 'This company does not have a description.',
      symbol: dbData.symbol ?? profile.symbol,
      webUrl: profile.webUrl,
      logo: dbData.logo ?? profile.logo,
      image: dbData.image ??
          'https://images.unsplash.com/photo-1559534814-505934bddaad?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1395&q=80',
      industry: profile.industry,
      quote: quote,
      recommendation: rec ?? [],
    );
  }
}
