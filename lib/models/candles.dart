class Candles {
  final List<dynamic> open;
  final List<dynamic> high;
  final List<dynamic> low;
  final List<dynamic> closed;
  final List<dynamic> timestamp;

  Candles({this.open, this.high, this.low, this.closed, this.timestamp});

  factory Candles.fromJson(Map<String, dynamic> json) {
    return Candles(
      open: json['o'],
      high: json['h'],
      low: json['l'],
      closed: json['c'],
      timestamp: json['t'],
    );
  }
}
