import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../blocs/wallet/wallet_cubit.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final RefreshController _spotRefreshController =
      RefreshController(initialRefresh: false);
  final RefreshController _fundingRefreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // _refreshController.refreshCompleted();
    BlocProvider.of<WalletCubit>(context).getWallet();
  }

  void _onLoading() async {
    // _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: BlocBuilder<WalletCubit, WalletState>(
          builder: (context, walletState) {
            if (walletState is GetWalletSuccess) {
              return DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: AppBar(
                    title: const Text('Wallet'),
                    bottom: const TabBar(
                      tabs: [
                        Tab(text: 'Spot'),
                        Tab(text: 'Funding'),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      SmartRefresher(
                        enablePullDown: true,
                        header: const WaterDropHeader(),
                        controller: _spotRefreshController,
                        onRefresh: _onRefresh,
                        onLoading: _onLoading,
                        child: ListView(
                          children: List.generate(
                            walletState.spot.length,
                            (index) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(color: Colors.grey),
                                ],
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 4,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 15,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(walletState.spot[index].asset ?? ''),
                                  Text('${walletState.spot[index].usd ?? ''}'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SmartRefresher(
                        enablePullDown: true,
                        header: const WaterDropHeader(),
                        controller: _fundingRefreshController,
                        onRefresh: _onRefresh,
                        onLoading: _onLoading,
                        child: ListView(
                          children: List.generate(
                            walletState.funding.length,
                            (index) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(color: Colors.grey),
                                ],
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 5,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 10,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(walletState.funding[index].asset ?? ''),
                                  Text(walletState.funding[index].free ?? ''),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (walletState is WalletLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (walletState is GetWalletFailed) {
              return Center(
                child: ElevatedButton(
                  child: const Text('Refresh'),
                  onPressed: () =>
                      BlocProvider.of<WalletCubit>(context).getWallet(),
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
