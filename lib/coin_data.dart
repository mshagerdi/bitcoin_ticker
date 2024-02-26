import 'dart:convert';

import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const coinURL = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = '691A445C-CC09-4CDF-ACC0-BEF50106F4F3';

class CoinData {
  CoinData({required this.crypto, required this.currency});
  String crypto;
  String currency;
  Future getCoinData() async {
    final response =
        await http.get(Uri.parse('$coinURL/$crypto/$currency?apikey=$apiKey'));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      print('ERROR');
    }
  }
}
