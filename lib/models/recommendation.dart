class Recommendation {
  final int buy;
  final int hold;
  final String period;
  final int sell;
  final String symbol;

  Recommendation({
    this.buy,
    this.hold,
    this.period,
    this.sell,
    this.symbol,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      buy: json['buy'],
      hold: json['hold'],
      period: json['period'],
      sell: json['sell'],
      symbol: json['symbol'],
    );
  }
}
