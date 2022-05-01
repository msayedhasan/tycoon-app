part of 'pairs_cubit.dart';

@immutable
abstract class PairsState {}

class PairsInitial extends PairsState {}

class PairsLoading extends PairsState {}

class GetPairsSuccess extends PairsState {
  final List<Coin> usdtPairs;
  GetPairsSuccess(this.usdtPairs);
}

class GetPairsFailed extends PairsState {}
