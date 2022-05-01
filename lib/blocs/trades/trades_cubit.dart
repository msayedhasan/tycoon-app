import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import '../../api/restful_api/trade_api.dart';
import '../../models/trade.dart';

part 'trades_state.dart';

class TradesCubit extends Cubit<TradesState> {
  TradesCubit() : super(TradesInitial());

  newTrade(
    ticker,
    type,
    side,
    price,
    scale,
    lotSizeMinQty,
    lotSizeMaxQty,
    lotSizeStepSize,
  ) async {
    try {
      emit(TradeLoading());
      final res = await TradeApi.newTrade(
        {
          'ticker': ticker,
          'type': type,
          'side': side,
          'price': price,
          'scale': scale,
          'lotSizeMinQty': lotSizeMinQty,
          'lotSizeMaxQty': lotSizeMaxQty,
          'lotSizeStepSize': lotSizeStepSize,
        },
      );
      if (res != null && res['data'] != null) {
        emit(TradesInitial());
        getTrades();
      } else {
        emit(GettingTradesFailed(res['message']));
      }
    } catch (err) {
      print('err');
      print(err);
      emit(GettingTradesFailed(''));
    }
  }

  getTrades() async {
    try {
      emit(TradeLoading());
      final List<Trade> trades = [];
      final res = await TradeApi.getTrades();
      if (res['data'] != null) {
        if (res['data'] is Iterable) {
          for (var i = 0; i < res['data'].length; i++) {
            trades.add(Trade.fromMap(res['data'][i]));
          }
          emit(GettingTradesDone(trades));
        } else {
          emit(GettingTradesFailed(''));
        }
      } else {
        emit(GettingTradesFailed(res['message']));
      }
    } catch (err) {
      emit(TradesInitial());
      emit(GettingTradesFailed('Failed to load orders'));
    }
  }

  cancelTrade(ticker, orderId, createdAt) async {
    try {
      emit(TradeLoading());
      final res = await TradeApi.cancelTrade(
        {
          'ticker': ticker,
          'orderId': orderId,
          'createdAt': createdAt,
        },
      );
      if (res != null && res['data'] != null) {
        emit(TradesInitial());
        getTrades();
      } else {
        emit(GettingTradesFailed(res['message']));
      }
      emit(TradesInitial());
    } catch (err) {
      print(err);
      emit(GettingTradesFailed(''));
    }
  }

  sellTrade(
    ticker,
    type,
    side,
    price,
    qty,
    lotSizeMinQty,
    lotSizeMaxQty,
    lotSizeStepSize,
  ) async {
    try {
      emit(TradeLoading());
      final res = await TradeApi.sellTrade(
        {
          'ticker': ticker,
          'type': type,
          'side': side,
          'price': price,
          'qty': qty,
          'lotSizeMinQty': lotSizeMinQty,
          'lotSizeMaxQty': lotSizeMaxQty,
          'lotSizeStepSize': lotSizeStepSize,
        },
      );
      if (res != null && res['data'] != null) {
        emit(TradesInitial());
        getTrades();
      } else {
        emit(GettingTradesFailed(res['message']));
      }
    } catch (err) {
      if (kDebugMode) {
        print('err');
        print(err);
      }
      emit(GettingTradesFailed(''));
    }
  }
}
