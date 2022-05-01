import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../config/notifications/firebase_notification.dart';

import '../../api/api.dart';
import '../../models/user.dart';

import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(UnAuthenticated()) {
    const storage = FlutterSecureStorage();
    updateToken(newToken) async {
      try {
        var token = await storage.read(key: 'token');
        if (token != null) {
          await storage.delete(key: 'token');
        }
        await storage.write(key: 'token', value: newToken);
      } catch (err) {
        print(err);
      }
    }

    on<CheckAuth>(
      (event, emit) async {
        try {
          emit(AuthChecking());
          emit(SameScreenChecking());
          final token = await storage.read(key: 'token');
          if (token != null) {
            httpManager.baseOptions.headers["Authorization"] =
                "Bearer " + token;

            // validate token and get user data //
            final getProfile = await AuthApi.getProfile();
            if (getProfile['data'] != null) {
              var user = User.fromMap(getProfile['data']);

              String fcmToken = await FirebaseNotification.getFcmToken();
              if (user.fcmToken == fcmToken) {
                if (kDebugMode) {
                  print('fcm token same as stored in DB');
                }
              }
              if (user.fcmToken == null ||
                  user.fcmToken == '' ||
                  fcmToken != user.fcmToken) {
                if (fcmToken != '') {
                  user.fcmToken = fcmToken;
                  await UserApi.updateUser(user.toJson());
                  final getProfile = await AuthApi.getProfile();
                  if (getProfile['data'] != null) {
                    user = User.fromMap(getProfile['data']);
                  } else {
                    emit(UnAuthenticated());
                  }
                }
              }

              emit(Authenticated(user: user));
            } else {
              await storage.delete(key: 'token');
              emit(UnAuthenticated());
            }
          } else {
            emit(UnAuthenticated());
          }
        } catch (err) {
          print(err);
          emit(UnAuthenticated());
        }
      },
    );

    on<Login>(
      (event, emit) async {
        try {
          emit(SameScreenChecking());

          String fcmToken = await FirebaseNotification.getFcmToken();

          final login = await AuthApi.login({
            ...event.form,
            'fcmToken': fcmToken,
          });

          if (login['token'] != null) {
            final token = login['token'];
            await updateToken(token);
            httpManager.baseOptions.headers["Authorization"] =
                "Bearer " + token;

            final getProfile = await AuthApi.getProfile();
            final user = User.fromMap(getProfile['data']);

            emit(Authenticated(user: user));
          } else {
            emit(AuthFail(login['message']));
            emit(UnAuthenticated());
          }
        } catch (err) {
          print(err);
          emit(UnAuthenticated());
        }
      },
    );

    on<Logout>(
      (event, emit) async {
        try {
          print('logout');
          var token = await storage.read(key: 'token');
          if (token != null) {
            await storage.delete(key: 'token');
          }
          emit(UnAuthenticated());
        } catch (err) {
          print(err);
          emit(UnAuthenticated());
        }
      },
    );

    on<GetProfile>(
      (event, emit) async {
        try {
          final getProfile = await AuthApi.getProfile();
          if (getProfile['data'] != null) {
            final user = User.fromMap(getProfile['data']);

            return emit(Authenticated(user: user));
          } else {
            await storage.delete(key: 'token');
            return emit(UnAuthenticated());
          }
        } catch (err) {
          print(err);
          return emit(UnAuthenticated());
        }
      },
    );

    on<OnAppleAuth>(
      (event, emit) async {
        try {
          emit(AuthChecking());
          String fcmToken = await FirebaseNotification.getFcmToken();

          final result = await AuthApi.apple({
            ...event.form,
            'fcmToken': fcmToken,
          });
          if (result['token'] != null) {
            final token = result['token'];
            print('update token');
            await updateToken(token);
            httpManager.baseOptions.headers["Authorization"] =
                "Bearer " + token;

            final getProfile = await AuthApi.getProfile();
            final user = User.fromMap(getProfile['data']);

            emit(Authenticated(user: user));
          } else {
            print('fail');
            emit(AuthFail(result['message']));
            emit(UnAuthenticated());
          }
        } catch (err) {
          print(err);
          // emit( AuthFail(err));
          emit(UnAuthenticated());
        }
      },
    );

    on<SyncApple>(
      (event, emit) async {
        try {
          final result = await AuthApi.syncApple(event.form);

          if (result['data'] != null) {
            final user = User.fromMap(result['data']);

            emit(Authenticated(user: user));
          } else {
            print('fail');
            emit(AuthFail(result['message']));
            emit(UnAuthenticated());
          }
        } catch (err) {
          print(err);
        }
      },
    );

    on<OnGoogleAuth>(
      (event, emit) async {
        try {
          emit(AuthChecking());
          String fcmToken = await FirebaseNotification.getFcmToken();

          final result = await AuthApi.google({
            ...event.form,
            'fcmToken': fcmToken,
          });
          if (result['token'] != null) {
            final token = result['token'];
            await updateToken(token);
            httpManager.baseOptions.headers["Authorization"] =
                "Bearer " + token;

            final getProfile = await AuthApi.getProfile();
            final user = User.fromMap(getProfile['data']);

            emit(Authenticated(user: user));
          } else {
            print('fail');
            emit(AuthFail(result['message']));
            emit(UnAuthenticated());
          }
        } catch (err) {
          print(err);
          emit(UnAuthenticated());
        }
      },
    );

    on<SyncGoogle>(
      (event, emit) async {
        try {
          final result = await AuthApi.syncGoogle(event.form);

          if (result['data'] != null) {
            final user = User.fromMap(result['data']);

            emit(Authenticated(user: user));
          } else {
            print('fail');
            emit(AuthFail(result['message']));
            emit(UnAuthenticated());
          }
        } catch (err) {
          print(err);
        }
      },
    );

    on<OnFacebookAuth>(
      (event, emit) async {
        try {
          emit(AuthChecking());
          String fcmToken = await FirebaseNotification.getFcmToken();

          final result = await AuthApi.facebook({
            ...event.form,
            'fcmToken': fcmToken,
          });
          print(result);
          if (result['token'] != null) {
            final token = result['token'];
            print('update token');
            await updateToken(token);
            httpManager.baseOptions.headers["Authorization"] =
                "Bearer " + token;

            final getProfile = await AuthApi.getProfile();
            final user = User.fromMap(getProfile['data']);

            emit(Authenticated(user: user));
          } else {
            print('fail');
            emit(AuthFail(result['message']));
            emit(UnAuthenticated());
          }
        } catch (err) {
          print(err);
          emit(UnAuthenticated());
        }
      },
    );

    on<SyncFacebook>(
      (event, emit) async {
        try {
          final result = await AuthApi.syncFacebook(event.form);

          if (result['data'] != null) {
            final user = User.fromMap(result['data']);

            emit(Authenticated(user: user));
          } else {
            print('fail');
            emit(AuthFail(result['message']));
            emit(UnAuthenticated());
          }
        } catch (err) {
          print(err);
        }
      },
    );

    on<UpdateUserData>(
      (event, emit) async {
        var user = User();
        user.name = event.name;
        user.budget = event.budget;
        user.apiKey = event.apiKey;
        user.apiSecret = event.apiSecret;

        String fcmToken = await FirebaseNotification.getFcmToken();
        user.fcmToken = fcmToken;

        try {
          await UserApi.updateUser(user.toJson());
          final getProfile = await AuthApi.getProfile();
          if (getProfile['data'] != null) {
            final user = User.fromMap(getProfile['data']);
            emit(Authenticated(user: user));
          } else {
            emit(UnAuthenticated());
          }
        } catch (err) {
          print(err);
          emit(UnAuthenticated());
        }
      },
    );
  }
}
