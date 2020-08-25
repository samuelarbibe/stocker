import 'package:stocker/models/stock.dart';

class Position {
  final Stock stock;
  final String assetId;
  final int qty;
  final String side;

  Position({this.stock, this.assetId, this.qty, this.side}) : super();

  factory Position.fromData(Stock stock, dynamic position) {
    return Position(
      stock: stock,
      assetId: position['asset_id'],
      qty: int.parse(position['qty']),
      side: position['side'],
    );
  }
}
