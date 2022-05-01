import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/coin.dart';
import '../../api/restful_api/coin_api.dart';

part 'pairs_state.dart';

class PairsCubit extends Cubit<PairsState> {
  PairsCubit() : super(PairsInitial());

  getUsdtPairs() async {
    try {
      emit(PairsLoading());

      List<Coin> usdtPairs = [];
      final res = await CoinApi.usdtPairs();
      if (res['data'] != null) {
        for (var i = 0; i < res['data'].length; i++) {
          usdtPairs.add(Coin.fromMap(res['data'][i]));
        }
      }

      emit(GetPairsSuccess(usdtPairs));
    } catch (err) {
      print(err);
      emit(GetPairsFailed());
    }
  }
}
