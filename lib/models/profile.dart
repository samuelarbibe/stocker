import 'package:stocker/models/stock.dart';

class Profile extends Stock {
  final String name;
  final String symbol;
  final String webUrl;
  final String logo;
  final String industry;

  Profile({this.name, this.symbol, this.webUrl, this.logo, this.industry})
      : super();

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'].toString().isEmpty ? 'Name' : json['name'],
      symbol: json['ticker'].toString().isEmpty ? 'SYMBOL' : json['ticker'],
      webUrl: json['weburl'].toString().isEmpty
          ? 'http://notFound.com'
          : json['weburl'],
      logo: json['logo'].toString().isEmpty
          ? 'https://www.florensia-online.com/assets/camaleon_cms/image-not-found-4a963b95bf081c3ea02923dceaeb3f8085e1a654fc54840aac61a57a60903fef.png'
          : json['logo'],
      industry: json['finnhubIndustry'].toString().isEmpty
          ? 'Industry'
          : json['finnhubIndustry'],
    );
  }
}
