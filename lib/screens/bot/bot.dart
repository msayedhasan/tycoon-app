import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/trades/trades_cubit.dart';
import '../../components/secodary_button.dart';
import '../../models/trade.dart';

class BotScreen extends StatefulWidget {
  const BotScreen({Key? key}) : super(key: key);

  @override
  State<BotScreen> createState() => _BotScreenState();
}

class _BotScreenState extends State<BotScreen> {
  late int? budget = 0;
  RegExp removeZeros = RegExp(r"([.]*0+)(?!.*\d)");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bot')),
      body: Column(
        children: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              if (authState is Authenticated) {
                return GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.6),
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: Colors.white,
                      builder: (BuildContext context) {
                        return Padding(
                          padding: const EdgeInsets.all(15),
                          child: BudgetModal(
                            authState.user!.budget ?? 0,
                            (int usage) {
                              if (mounted) {
                                setState(() {
                                  budget = usage;
                                });
                              }
                            },
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    padding:
                        const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(color: Colors.black),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Bot budget',
                          style: TextStyle(
                            color: authState.user!.budget == 0
                                ? Colors.red
                                : Colors.black,
                          ),
                        ),
                        Text(
                          authState.user!.budget.toString() + '  USDT',
                          style: TextStyle(
                            color: authState.user!.budget == 0
                                ? Colors.red
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Center(
                  child: ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<AuthBloc>(context).add(GetProfile());
                    },
                    child: const Text('Refresh'),
                  ),
                );
              }
            },
          ),
          Expanded(
            child: BlocBuilder<TradesCubit, TradesState>(
              builder: (context, orderState) {
                if (orderState is GettingTradesDone) {
                  if (orderState.trades.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('No trades'),
                        ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<TradesCubit>(context).getTrades();
                          },
                          child: const Text('Refresh'),
                        ),
                      ],
                    );
                  }
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(
                          orderState.trades.length,
                          (index) {
                            Trade trade = orderState.trades[index];
                            return GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  constraints: BoxConstraints(
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                              0.6),
                                  context: context,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  backgroundColor: Colors.white,
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        children: [
                                          Text(trade.ticker!),
                                          const SizedBox(height: 15),
                                          Column(
                                            children: List.generate(
                                              trade.orders!.length,
                                              (orderIndex) => Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    trade.orders![orderIndex]
                                                        .side!,
                                                  ),
                                                  Text(
                                                    trade.orders![orderIndex]
                                                        .qty!
                                                        .replaceAll(
                                                            removeZeros, ''),
                                                  ),
                                                  Text(
                                                    trade.orders![orderIndex]
                                                        .price!
                                                        .replaceAll(
                                                            removeZeros, ''),
                                                  ),
                                                  trade.orders![orderIndex]
                                                                  .canceled !=
                                                              null &&
                                                          orderState
                                                              .trades[
                                                                  orderIndex]
                                                              .canceled!
                                                      ? const Text(
                                                          'canceled',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
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
                                      orderState.trades[index].ticker!
                                          .split('USDT')
                                          .join('/USDT'),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    orderState.trades[index].canceled != null &&
                                            orderState.trades[index].canceled!
                                        ? const Text(
                                            'canceled',
                                            style: TextStyle(color: Colors.red),
                                          )
                                        : Container(),
                                    // IconButton(
                                    //   onPressed: () {
                                    //     BlocProvider.of<TradesCubit>(context)
                                    //         .cancelTrade(
                                    //       orderState.trades[index].ticker!,
                                    //       orderState.trades[index].orderId!,
                                    //       orderState.trades[index].createdAt!,
                                    //     );
                                    //   },
                                    //   icon: const Icon(Icons.close),
                                    // )
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
          )
        ],
      ),
    );
  }
}

class BudgetModal extends StatefulWidget {
  final int usage;
  final Function handler;

  BudgetModal(this.usage, this.handler);
  @override
  _BudgetModalState createState() => _BudgetModalState();
}

class _BudgetModalState extends State<BudgetModal>
    with SingleTickerProviderStateMixin {
  int? usage;
  @override
  void initState() {
    super.initState();

    usage = widget.usage;
  }

  RegExp removeZeros = RegExp(r"([.]*0+)(?!.*\d)");

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: TextField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              // WhitelistingTextInputFormatter.digitsOnly
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
            ],
            decoration: const InputDecoration(
              labelText: 'Amount',
              hintText: 'Amount',
              border: OutlineInputBorder(),
            ),
            onChanged: (String value) {
              usage = int.tryParse(value);
            },
          ),
        ),
        const SizedBox(height: 10),
        SecondaryButton(
          title: 'submit',
          onTap: () {
            if (usage! < 100) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Budget must be > 100'),
                  backgroundColor: Colors.red,
                ),
              );
              return Navigator.of(context).pop();
            }
            widget.handler(usage);
            BlocProvider.of<AuthBloc>(context).add(
              UpdateUserData(budget: usage),
            );
            return Navigator.of(context).pop();
          },
          // rounded: true,
          verticalPadding: 8,
          borderSize: 1,
        ),
      ],
    );
  }
}
