import 'dart:convert';
import 'package:http/http.dart';

import 'eod_config.dart';

// https://eodhistoricaldata.com/knowledgebase/search-api-for-stocks-etfs-mutual-funds-and-indices/

class EodService {
  final EodWrapper eodWrapper = EodWrapper();

  Future<List<dynamic>> searchStocks(String query) async {
    final response = await eodWrapper.searchStocks(query);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data.where((item) => item["ISIN"] != null).toList();
    } else {
      throw new Exception('Could not load results for query $query');
    }
  }
}

class EodWrapper {
  Future<Response> searchStocks(String query) async {
    return get(
        'https://eodhistoricaldata.com/api/search/$query?api_token=$EOD_API_KEY&limit=$EOD_RESULT_LIMIT');
  }
}
