part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class UnAuthenticated extends AuthState {}

class AuthChecking extends AuthState {}

class SameScreenChecking extends AuthState {}

class Authenticated extends AuthState {
  final User? user;
  Authenticated({this.user});
}

class AuthFail extends AuthState {
  final String message;
  AuthFail(this.message);
}
