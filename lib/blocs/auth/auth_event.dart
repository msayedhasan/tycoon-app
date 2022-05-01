part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class CheckAuth extends AuthEvent {}

class Login extends AuthEvent {
  final Map<String, String> form;
  Login(this.form);
}

class Logout extends AuthEvent {}

class GetProfile extends AuthEvent {}

class OnAppleAuth extends AuthEvent {
  final Map<String, String> form;
  OnAppleAuth(this.form);
}

class SyncApple extends AuthEvent {
  final Map<String, String> form;
  SyncApple(this.form);
}

class OnGoogleAuth extends AuthEvent {
  final Map<String, String> form;
  OnGoogleAuth(this.form);
}

class SyncGoogle extends AuthEvent {
  final Map<String, String> form;
  SyncGoogle(this.form);
}

class OnFacebookAuth extends AuthEvent {
  final Map<String, String> form;
  OnFacebookAuth(this.form);
}

class SyncFacebook extends AuthEvent {
  final Map<String, String> form;
  SyncFacebook(this.form);
}

class UpdateUserData extends AuthEvent {
  final String? name;
  final String? apiKey;
  final String? apiSecret;
  final int? budget;
  UpdateUserData({
    this.name,
    this.apiKey,
    this.apiSecret,
    this.budget,
  });
}
