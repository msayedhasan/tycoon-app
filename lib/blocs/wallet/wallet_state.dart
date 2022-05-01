part of 'wallet_cubit.dart';

@immutable
abstract class WalletState {}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class GetWalletSuccess extends WalletState {
  final List<Coin> funding;
  final List<Coin> spot;
  GetWalletSuccess(this.funding, this.spot);
}

class GetWalletFailed extends WalletState {}
