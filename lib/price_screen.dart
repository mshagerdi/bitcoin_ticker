import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bitcoin_ticker/coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  double selectedCurrencyRate = 0.0;
  bool isLoading = true;
  String selectedCurrencyValue = 'USD';
  Map<String, double> cryptoCurrency = {};

  @override
  void initState() {
    super.initState();
    getData(selectedCurrencyValue);
  }

  void getData(String selectedCurrency) async {
    for (String crypto in cryptoList) {
      var coinData = await CoinData(crypto: crypto, currency: selectedCurrency)
          .getCoinData();
      cryptoCurrency[crypto] = coinData['rate'];
    }

    // var coinData =
    //     await CoinData(crypto: 'BTC', currency: selectedCurrency).getCoinData();
    // selectedCurrencyRate = coinData['rate'];
    setState(() {
      isLoading = false;
    });
  }

  DropdownButton androidDropdown() {
    List<DropdownMenuItem<dynamic>> dropDownItems = [];

    for (String currency in currenciesList) {
      dropDownItems.add(
        DropdownMenuItem(
          child: Text(currency),
          value: currency,
        ),
      );
    }
    return DropdownButton(
      value: selectedCurrencyValue,
      items: dropDownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrencyValue = value!;
          isLoading = true;
          getData(selectedCurrencyValue);
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      itemExtent: 33,
      onSelectedItemChanged: (value) {
        selectedCurrencyValue = currenciesList[value];
        isLoading = true;
        getData(selectedCurrencyValue);
      },
      children: pickerItems,
    );
  }

  List<Widget> showCards() {
    List<Widget> cardList = [];
    for (String crypto in cryptoList) {
      cardList.add(
        Padding(
          padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
          child: Card(
            color: Colors.lightBlueAccent,
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
              child: Text(
                '1 $crypto = ${isLoading ? '?' : cryptoCurrency[crypto]!.toStringAsFixed(2)} $selectedCurrencyValue',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return cardList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: showCards(),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
