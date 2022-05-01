import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/coin.dart';
import '../../api/restful_api/wallet_api.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  WalletCubit() : super(WalletInitial());

  List<Coin> usdtPairs = [];

  getWallet() async {
    try {
      emit(WalletLoading());
      final funding = await WalletApi.funding();
      List<Coin> fundingWallet = [];
      if (funding != null && funding['data'] != null) {
        for (var i = 0; i < funding['data'].length; i++) {
          fundingWallet.add(Coin.fromMap(funding['data'][i]));
        }
      }
      // final listenKey = await WalletApi.listenKey();
      // print('listenKey');
      // print(listenKey);

      final spot = await WalletApi.spot();
      List<Coin> spotWallet = [];
      if (spot != null && spot['data'] != null) {
        for (var i = 0; i < spot['data'].length; i++) {
          spotWallet.add(Coin.fromMap(spot['data'][i]));
        }
      }

      emit(GetWalletSuccess(fundingWallet, spotWallet));
    } catch (err) {
      print(err);
      emit(GetWalletFailed());
    }
  }
}
