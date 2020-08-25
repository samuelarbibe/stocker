class Quote {
  final double openPrice;
  final double highPrice;
  final double lowPrice;
  final double currentPrice;
  final double prevClosePrice;

  Quote(
      {this.openPrice,
      this.highPrice,
      this.lowPrice,
      this.currentPrice,
      this.prevClosePrice});

  get change => (currentPrice - prevClosePrice) / prevClosePrice * 100;

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      openPrice: json['o'].toDouble(),
      highPrice: json['h'].toDouble(),
      lowPrice: json['l'].toDouble(),
      currentPrice: json['c'].toDouble(),
      prevClosePrice: json['pc'].toDouble(),
    );
  }
}
