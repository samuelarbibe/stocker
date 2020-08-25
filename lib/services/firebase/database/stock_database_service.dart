import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stocker/models/stock_model.dart';

class StockDatabaseService {
  final String symbol;

  StockDatabaseService({this.symbol = ''});

  final CollectionReference stockCollection =
      Firestore.instance.collection('stocks');

  Future<DocumentSnapshot> getStockData(String symbol) async {
    return await stockCollection.document(symbol).get();
  }

  Future<List<StockModel>> get allStocksData async {
    QuerySnapshot querySnapshot = await stockCollection.getDocuments();

    return querySnapshot.documents.map((snapshot) {
      return StockModel.fromSnapshot(snapshot);
    }).toList();
  }
}
