import 'package:cloud_firestore/cloud_firestore.dart';

class StockModel {
  final String name;
  final String description;
  final String symbol;
  final String image;
  final String logo;

  StockModel({this.logo, this.name, this.description, this.symbol, this.image});

  factory StockModel.fromSnapshot(DocumentSnapshot snapshot) {
    return StockModel(
      name: snapshot.data['name'],
      description: snapshot.data['description'],
      symbol: snapshot.data['symbol'],
      image: snapshot.data['image'],
      logo: snapshot.data['logo'],
    );
  }

  factory StockModel.fromPositionMap(dynamic position) {
    return StockModel(
      name: null,
      description: null,
      symbol: position['symbol'],
      image: null,
      logo: null,
    );
  }

  static StockModel fromAssetMap(dynamic asset) {
    return StockModel(
      name: null,
      description: null,
      symbol: asset['symbol'],
      image: null,
      logo: null,
    );
  }

  static StockModel fromSearchResult(dynamic result) {
    return StockModel(
      name: null,
      description: null,
      symbol: result['Code'],
      image: null,
      logo: null,
    );
  }
}
