import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/blocs.dart';
import '../../models/coin.dart';
import '../../models/trade.dart';

import '../../components/secodary_button.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<OrderScreen> {
  String _price = "";
  int _scale = 1;
  String _type = 'LIMIT';
  String _side = 'BUY';
  final _priceController = TextEditingController();
  final _scaleController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

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
            child: BlocConsumer<TradesCubit, TradesState>(
              listener: (context, ordersState) {
                if (ordersState is GettingTradesFailed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        ordersState.message,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, ordersState) {
                if (ordersState is TradeLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Column(
                  children: [
                    BlocBuilder<PairsCubit, PairsState>(
                      builder: (context, pairsState) {
                        if (pairsState is PairsLoading) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: LinearProgressIndicator(),
                          );
                        } else if (pairsState is GetPairsSuccess) {
                          if (pairsState.usdtPairs.isNotEmpty) {
                            return OutlinedButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  constraints: BoxConstraints(
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                              0.8),
                                  context: context,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  backgroundColor: Colors.white,
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: PairsModalSheet(
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
                                  // selectedCoin.price != null
                                  //     ? Column(
                                  //         children: [
                                  //           Text(
                                  //             selectedCoin.price!
                                  //                 .replaceAll(removeZeros, ''),
                                  //             style: const TextStyle(
                                  //               fontWeight: FontWeight.bold,
                                  //               color: Colors.green,
                                  //             ),
                                  //           ),
                                  //         ],
                                  //       )
                                  //     : Container(),
                                ],
                              ),
                            );
                          } else {
                            return TextButton(
                              onPressed: () {
                                BlocProvider.of<PairsCubit>(context)
                                    .getUsdtPairs();
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
                          'Type',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 100,
                          child: DropdownButton<String>(
                            value: _type,
                            items:
                                <String>['LIMIT', 'MARKET'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            isExpanded: true,
                            onChanged: (value) {
                              if (mounted) {
                                setState(() {
                                  _type = value!;
                                });
                              }
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
                          'Side',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 100,
                          child: DropdownButton<String>(
                            value: _side,
                            items: <String>['BUY', 'SELL'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            isExpanded: true,
                            onChanged: (value) {
                              if (mounted) {
                                setState(() {
                                  _side = value!;
                                });
                              }
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
                          'Price',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 100,
                          child: TextField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Order at',
                              hintText: 'Order at',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            onChanged: (String value) {
                              _price = value;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _side == 'BUY'
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Scale',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 100,
                                child: TextField(
                                  controller: _scaleController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'scale',
                                    hintText: 'scale',
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                  ),
                                  onChanged: (String value) {
                                    _scale = int.tryParse(value)!;
                                  },
                                ),
                              ),
                            ],
                          )
                        : const Text('Sell All quantity'),
                    const SizedBox(height: 20),
                    BlocBuilder<TradesCubit, TradesState>(
                        builder: (context, orderState) {
                      return SecondaryButton(
                        title: 'submit',
                        onTap: () {
                          if (_price.isEmpty || selectedCoin.symbol == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Enter ticker and price'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          if (_side == 'BUY') {
                            BlocProvider.of<TradesCubit>(context).newTrade(
                              selectedCoin.symbol!,
                              _type,
                              _side,
                              _price,
                              _scale,
                              selectedCoin.lotSizeMinQty!,
                              selectedCoin.lotSizeMaxQty!,
                              selectedCoin.lotSizeStepSize!,
                            );
                          } else {
                            double qty = 0;
                            if (kDebugMode) {
                              print('sell');
                            }
                            if (ordersState is GettingTradesDone) {
                              var x = ordersState.trades.firstWhere(
                                  (trade) =>
                                      trade.active == true &&
                                      trade.ticker == selectedCoin.symbol,
                                  orElse: () => Trade());

                              for (var i = 0; i < x.orders!.length; i++) {
                                if (!x.orders![i].canceled!) {
                                  qty += double.tryParse(x.orders![i].qty!)!;
                                }
                              }
                              if (x.ticker != null) {
                                BlocProvider.of<TradesCubit>(context).sellTrade(
                                  selectedCoin.symbol!,
                                  _type,
                                  _side,
                                  _price,
                                  qty,
                                  selectedCoin.lotSizeMinQty!,
                                  selectedCoin.lotSizeMaxQty!,
                                  selectedCoin.lotSizeStepSize!,
                                );
                              }
                            }
                          }

                          _type = 'LIMIT';
                          _side = 'BUY';
                          _price = '';
                          _scale = 1;
                          _priceController.clear();
                        },
                        // rounded: true,
                        verticalPadding: 8,
                        borderSize: 1,
                      );
                    }),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Active orders',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: () {
                              BlocProvider.of<TradesCubit>(context).getTrades();
                            },
                            icon: const Icon(Icons.refresh),
                          ),
                        ],
                      ),
                    ),
                    BlocBuilder<TradesCubit, TradesState>(
                      builder: (context, orderState) {
                        if (orderState is GettingTradesDone) {
                          if (orderState.trades
                              .where((trade) => trade.active == true)
                              .isEmpty) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('No trades'),
                                ElevatedButton(
                                  onPressed: () {
                                    BlocProvider.of<TradesCubit>(context)
                                        .getTrades();
                                  },
                                  child: const Text('Refresh'),
                                ),
                              ],
                            );
                          }
                          List<Trade> activeTrades = orderState.trades
                              .where((trade) => trade.active!)
                              .toList();
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: SingleChildScrollView(
                              child: Column(
                                children: List.generate(
                                  activeTrades.length,
                                  (index) {
                                    Trade trade = activeTrades[index];
                                    return GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                          constraints: BoxConstraints(
                                              maxHeight: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.6),
                                          context: context,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          backgroundColor: Colors.white,
                                          builder: (BuildContext context) {
                                            return Padding(
                                              padding: const EdgeInsets.all(15),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    Text(trade.ticker!),
                                                    const SizedBox(height: 15),
                                                    Column(
                                                      children: List.generate(
                                                        trade.orders!.length,
                                                        (orderIndex) {
                                                          Order order =
                                                              trade.orders![
                                                                  orderIndex];
                                                          return SizedBox(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(order
                                                                    .side!),
                                                                Text(
                                                                  order.active!
                                                                      ? 'Active'
                                                                      : order.canceled!
                                                                          ? 'Canceled'
                                                                          : '',
                                                                  style: order
                                                                          .active!
                                                                      ? const TextStyle(
                                                                          color:
                                                                              Colors.green)
                                                                      : order.canceled!
                                                                          ? const TextStyle(color: Colors.red)
                                                                          : null,
                                                                ),
                                                                Text(
                                                                    'at ${order.price!.replaceAll(removeZeros, '')}'),
                                                                Text(
                                                                  '${(double.tryParse(order.price!)! * double.tryParse(order.qty!)!).toStringAsFixed(6).replaceAll(removeZeros, '')} USDT',
                                                                ),
                                                                // order.active!
                                                                //     ?
                                                                IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    BlocProvider.of<TradesCubit>(
                                                                            context)
                                                                        .cancelTrade(
                                                                      order
                                                                          .ticker!,
                                                                      order
                                                                          .orderId!,
                                                                      order
                                                                          .createdAt!,
                                                                    );
                                                                    setState(
                                                                        () {});
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  icon: const Icon(
                                                                      Icons
                                                                          .close),
                                                                )
                                                                // : Container()
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 10,
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.white,
                                          boxShadow: const [
                                            BoxShadow(color: Colors.black),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              trade.ticker!
                                                  .split('USDT')
                                                  .join('/USDT'),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            trade.canceled!
                                                ? const Text(
                                                    'Canceled',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  )
                                                : const Text(
                                                    'Active',
                                                    style: TextStyle(
                                                        color: Colors.green),
                                                  )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        } else if (orderState is TradeLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Center(
                          child: ElevatedButton(
                            onPressed: () {
                              BlocProvider.of<TradesCubit>(context).getTrades();
                            },
                            child: const Text('Refresh'),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class PairsModalSheet extends StatefulWidget {
  final List<Coin> usdtPairs;
  final Function handler;

  PairsModalSheet({required this.usdtPairs, required this.handler});
  @override
  _PairsModalSheetState createState() => _PairsModalSheetState();
}

class _PairsModalSheetState extends State<PairsModalSheet>
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
