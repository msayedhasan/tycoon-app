part of 'trades_cubit.dart';

@immutable
abstract class TradesState {}

class TradesInitial extends TradesState {}

class TradeLoading extends TradesState {}

class GettingTradesDone extends TradesState {
  final List<Trade> trades;
  GettingTradesDone(this.trades);
}

class GettingTradesFailed extends TradesState {
  final String message;
  GettingTradesFailed(this.message);
}
