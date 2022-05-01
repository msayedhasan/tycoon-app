import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tycoon/blocs/pairs/pairs_cubit.dart';
import 'package:tycoon/config/config.dart';
import 'package:tycoon/models/coin.dart';

import '../../api/restful_api/coin_api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _firstBuyPrice = "";
  String _firstBuyUsdt = "";
  String _firstSellPrice = "";
  String _firstSellProfit = "";
  String _firstUsdtOut = "";

  String _secondBuyPrice = "";
  String _secondBuyUsdt = "";
  String _secondSellPrice = "";
  String _secondSellProfit = "";
  String _secondUsdtOut = "";

  String _thirdBuyPrice = "";
  String _thirdBuyUsdt = "";
  String _thirdSellPrice = "";
  String _thirdSellProfit = "";
  String _thirdUsdtOut = "";

  String _twoBuysEnter = "";
  String _twoBuysUsdt = '';
  String _threeBuysEnter = "";
  String _threeBuysUsdt = '';

  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  calculateFirstBuyProfit() {
    if (_firstBuyPrice.isNotEmpty && _firstSellPrice.isNotEmpty) {
      _firstSellProfit = (((double.tryParse(_firstSellPrice)! -
                          double.tryParse(_firstBuyPrice)!) /
                      double.tryParse(_firstBuyPrice)!) *
                  100)
              .toStringAsFixed(2)
              .replaceAll(removeZeros, '') +
          '%';
    } else {
      _firstSellProfit = '';
    }
    if (_firstBuyUsdt.isNotEmpty && _firstSellProfit.isNotEmpty) {
      _firstUsdtOut = (double.tryParse(_firstBuyUsdt)! *
              (1 +
                  double.tryParse(_firstSellProfit.replaceAll('%', ''))! / 100))
          .toStringAsFixed(2)
          .replaceAll(removeZeros, '');
    } else {
      _firstUsdtOut = '';
    }
  }

  calculateTwoBuysPrice() {
    if (_firstBuyPrice.isNotEmpty &&
        _firstBuyUsdt.isNotEmpty &&
        _secondBuyPrice.isNotEmpty &&
        _secondBuyUsdt.isNotEmpty) {
      _twoBuysEnter = (double.tryParse(_secondBuyPrice)! *
              ((double.tryParse(_firstBuyUsdt)! +
                      double.tryParse(_secondBuyUsdt)!) /
                  (double.tryParse(_secondBuyUsdt)! +
                      (double.tryParse(_firstBuyUsdt)! *
                          double.tryParse(_secondBuyPrice)! /
                          double.tryParse(_firstBuyPrice)!))))
          .toStringAsFixed(5)
          .replaceAll(removeZeros, '');
    } else {
      _twoBuysEnter = '';
    }

    if (_firstBuyUsdt.isNotEmpty && _secondBuyUsdt.isNotEmpty) {
      _twoBuysUsdt =
          (double.tryParse(_firstBuyUsdt)! + double.tryParse(_secondBuyUsdt)!)
              .toStringAsFixed(2);
    } else {
      _twoBuysUsdt = '';
    }
  }

  calculateSecondBuyProfit() {
    if (_secondSellPrice.isNotEmpty && _twoBuysEnter.isNotEmpty) {
      _secondSellProfit = (((double.tryParse(_secondSellPrice)! -
                          double.tryParse(_twoBuysEnter)!) /
                      double.tryParse(_twoBuysEnter)!) *
                  100)
              .toStringAsFixed(2) +
          '%';
    } else {
      _secondSellProfit = '';
    }

    if (_twoBuysEnter.isNotEmpty && _secondSellProfit.isNotEmpty) {
      _secondUsdtOut = (double.tryParse(_twoBuysEnter)! *
              (1 +
                  double.tryParse(_secondSellProfit.replaceAll('%', ''))! /
                      100))
          .toStringAsFixed(2);
    } else {
      _secondUsdtOut = '';
    }
  }

  calculateThreeBuysPrice() {
    if (_firstBuyPrice.isNotEmpty &&
        _firstBuyUsdt.isNotEmpty &&
        _secondBuyPrice.isNotEmpty &&
        _secondBuyUsdt.isNotEmpty &&
        _thirdBuyPrice.isNotEmpty &&
        _thirdBuyUsdt.isNotEmpty) {
      _threeBuysEnter = (double.tryParse(_thirdBuyPrice)! *
              ((double.tryParse(_firstBuyUsdt)! +
                      double.tryParse(_secondBuyUsdt)! +
                      double.tryParse(_thirdBuyUsdt)!) /
                  (double.tryParse(_thirdBuyUsdt)! +
                      (double.tryParse(_secondBuyUsdt)! *
                          double.tryParse(_thirdBuyPrice)! /
                          double.tryParse(_secondBuyPrice)!) +
                      (double.tryParse(_firstBuyUsdt)! *
                          double.tryParse(_thirdBuyPrice)! /
                          double.tryParse(_firstBuyPrice)!))))
          .toStringAsFixed(5);
    } else {
      _threeBuysEnter = '';
    }

    if (_firstBuyUsdt.isNotEmpty &&
        _secondBuyUsdt.isNotEmpty &&
        _threeBuysUsdt.isNotEmpty) {
      _threeBuysUsdt = (double.tryParse(_firstBuyUsdt)! +
              double.tryParse(_secondBuyUsdt)! +
              double.tryParse(_thirdBuyUsdt)!)
          .toStringAsFixed(2)
          .replaceAll(removeZeros, '');
    } else {
      _threeBuysUsdt = '';
    }
  }

  calculateThirdBuyProfit() {
    if (_thirdSellPrice.isNotEmpty && _threeBuysEnter.isNotEmpty) {
      _thirdSellProfit = (((double.tryParse(_thirdSellPrice)! -
                          double.tryParse(_threeBuysEnter)!) /
                      double.tryParse(_threeBuysEnter)!) *
                  100)
              .toStringAsFixed(2) +
          '%';
    } else {
      _thirdSellProfit = '';
    }

    if (_threeBuysEnter.isNotEmpty && _thirdSellProfit.isNotEmpty) {
      _thirdUsdtOut = (double.tryParse(_threeBuysEnter)! *
              (1 +
                  double.tryParse(_thirdSellProfit.replaceAll('%', ''))! / 100))
          .toStringAsFixed(2);
    } else {
      _thirdUsdtOut = '';
    }
  }

  calculate() {
    calculateFirstBuyProfit();

    calculateTwoBuysPrice();
    calculateSecondBuyProfit();

    calculateThreeBuysPrice();
    calculateThirdBuyProfit();
  }

  Coin selectedCoin = Coin();

  RegExp removeZeros = RegExp(r"([.]*0+)(?!.*\d)");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              children: [
                BlocBuilder<PairsCubit, PairsState>(
                  builder: (context, pairsState) {
                    if (pairsState is PairsLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (pairsState is GetPairsSuccess) {
                      if (pairsState.usdtPairs.isNotEmpty) {
                        return OutlinedButton(
                          onPressed: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.8),
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              backgroundColor: Colors.white,
                              builder: (BuildContext context) {
                                return Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: StatefulModalSheet(
                                    usdtPairs: pairsState.usdtPairs,
                                    handler: (Coin coin) {
                                      if (mounted) {
                                        setState(() {
                                          selectedCoin = coin;
                                        });
                                      }
                                    },
                                  ),
                                );
                              },
                            );
                          },
                          child: Column(
                            children: [
                              Text(
                                selectedCoin.symbol != null
                                    ? selectedCoin.symbol!
                                        .split('USDT')
                                        .join('/USDT')
                                    : 'Select coin',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              selectedCoin.price != null
                                  ? Text(
                                      selectedCoin.price!
                                          .replaceAll(removeZeros, ''),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        );
                      } else {
                        return TextButton(
                          onPressed: () {
                            BlocProvider.of<PairsCubit>(context).getUsdtPairs();
                          },
                          child: const Text(
                            'get coins',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        );
                      }
                    }
                    return TextButton(
                      onPressed: () {
                        BlocProvider.of<PairsCubit>(context).getUsdtPairs();
                      },
                      child: const Text(
                        'get coins',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'First buy',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 100,
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: Translate.of(context).translate('usdt'),
                          hintText: Translate.of(context).translate('usdt'),
                          border: const OutlineInputBorder(),
                          isDense: true,
                        ),
                        onChanged: (String value) {
                          _firstBuyUsdt = value;
                          calculate();

                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: Translate.of(context).translate('price'),
                          border: const OutlineInputBorder(),
                          isDense: true,
                        ),
                        onChanged: (String value) {
                          _firstBuyPrice = value;
                          calculate();

                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'First sell',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(_firstSellProfit),
                    SizedBox(
                      width: 100,
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: Translate.of(context).translate('price'),
                          hintText: Translate.of(context).translate('price'),
                          border: const OutlineInputBorder(),
                          isDense: true,
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (String value) {
                          _firstSellPrice = value;
                          calculate();

                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: SizedBox(child: Divider(thickness: 2)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Second buy',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 100,
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: Translate.of(context).translate('usdt'),
                          hintText: Translate.of(context).translate('usdt'),
                          border: const OutlineInputBorder(),
                          isDense: true,
                        ),
                        onChanged: (String value) {
                          _secondBuyUsdt = value;
                          calculate();

                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: Translate.of(context).translate('price'),
                          border: const OutlineInputBorder(),
                          isDense: true,
                        ),
                        onChanged: (String value) {
                          _secondBuyPrice = value;
                          calculate();

                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Second sell',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(_secondSellProfit),
                    SizedBox(
                      width: 100,
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: Translate.of(context).translate('price'),
                          hintText: Translate.of(context).translate('price'),
                          border: const OutlineInputBorder(),
                          isDense: true,
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (String value) {
                          _secondSellPrice = value;
                          calculate();

                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: SizedBox(child: Divider(thickness: 2)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Third buy',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 100,
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: Translate.of(context).translate('usdt'),
                          hintText: Translate.of(context).translate('usdt'),
                          border: const OutlineInputBorder(),
                          isDense: true,
                        ),
                        onChanged: (String value) {
                          _thirdBuyUsdt = value;
                          calculate();

                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: Translate.of(context).translate('price'),
                          border: const OutlineInputBorder(),
                          isDense: true,
                        ),
                        onChanged: (String value) {
                          _thirdBuyPrice = value;
                          calculate();

                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Third sell',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(_thirdSellProfit),
                    SizedBox(
                      width: 100,
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: Translate.of(context).translate('price'),
                          hintText: Translate.of(context).translate('price'),
                          border: const OutlineInputBorder(),
                          isDense: true,
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (String value) {
                          _thirdSellPrice = value;

                          calculate();

                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: SizedBox(child: Divider(thickness: 2)),
                ),
                Container(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: DataTable(
                        columnSpacing: 10,
                        horizontalMargin: 5,
                        columns: [
                          DataColumn(
                            label: Globals.tableHeader(
                              '',
                            ),
                          ),
                          DataColumn(
                            label: Globals.tableHeader('Price'),
                          ),
                          DataColumn(
                            label: Globals.tableHeader('Profit'),
                          ),
                          DataColumn(
                            label: Globals.tableHeader('In'),
                          ),
                          DataColumn(
                            label: Globals.tableHeader('Out'),
                          ),
                        ],
                        rows: [
                          DataRow(
                            cells: [
                              const DataCell(Text('First buy')),
                              DataCell(Center(child: Text(_firstBuyPrice))),
                              DataCell(Center(child: Text(_firstSellProfit))),
                              DataCell(Center(child: Text(_firstBuyUsdt))),
                              DataCell(Center(child: Text(_firstUsdtOut))),
                            ],
                          ),
                          DataRow(
                            cells: [
                              const DataCell(Text('Two buys')),
                              DataCell(Center(child: Text(_twoBuysEnter))),
                              DataCell(Center(child: Text(_secondSellProfit))),
                              DataCell(Center(child: Text(_twoBuysUsdt))),
                              DataCell(Center(child: Text(_secondUsdtOut))),
                            ],
                          ),
                          DataRow(
                            cells: [
                              const DataCell(Text('Three buys')),
                              DataCell(Center(child: Text(_threeBuysEnter))),
                              DataCell(Center(child: Text(_thirdSellProfit))),
                              DataCell(Center(child: Text(_threeBuysUsdt))),
                              DataCell(Center(child: Text(_thirdUsdtOut))),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StatefulModalSheet extends StatefulWidget {
  final List<Coin> usdtPairs;
  final Function handler;

  StatefulModalSheet({required this.usdtPairs, required this.handler});
  @override
  _StatefulModalSheetState createState() => new _StatefulModalSheetState();
}

class _StatefulModalSheetState extends State<StatefulModalSheet>
    with SingleTickerProviderStateMixin {
  List<Coin> filteredUsdtPairs = [];
  @override
  void initState() {
    super.initState();

    filteredUsdtPairs = widget.usdtPairs;
  }

  RegExp removeZeros = RegExp(r"([.]*0+)(?!.*\d)");

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Coin',
              hintText: 'Coin',
              border: OutlineInputBorder(),
            ),
            onChanged: (String value) {
              filteredUsdtPairs = widget.usdtPairs
                  .where((element) =>
                      element.symbol!.toLowerCase().contains(value))
                  .toList();
              setState(() {});
            },
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView(
            children: List.generate(
              filteredUsdtPairs.length,
              (index) => OutlinedButton(
                onPressed: () {
                  widget.handler(filteredUsdtPairs[index]);
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      filteredUsdtPairs[index]
                          .symbol!
                          .split('USDT')
                          .join('/USDT'),
                    ),
                    Text(
                      filteredUsdtPairs[index]
                          .price!
                          .replaceAll(removeZeros, ''),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
