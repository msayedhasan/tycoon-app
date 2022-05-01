import '../../config/config.dart';

import '../helpers/http_manager.dart';

class AuthApi {
  static Future<dynamic> signup(form) async {
    try {
      // await Future.delayed(Duration(seconds: 1));
      // return DummyData.login;
      final result = await httpManager.post(
        url: Globals.host + '/auth/signup',
        data: form,
      );
      return result;
    } catch (err) {
      print(err);
      return err;
    }
  }

  static Future<dynamic> login(form) async {
    try {
      // await Future.delayed(Duration(seconds: 1));
      // return DummyData.login;
      final result = await httpManager.post(
        url: Globals.host + '/auth/login',
        data: form,
      );
      return result;
    } catch (err) {
      print(err);
      return err;
    }
  }

  static Future<dynamic> resetPassword(form) async {
    try {
      // await Future.delayed(Duration(seconds: 1));
      // return DummyData.login;
      final result = await httpManager.post(
        url: Globals.host + '/auth/resetPassword',
        data: form,
      );
      return result;
    } catch (err) {
      print(err);
      return err;
    }
  }

  static Future<dynamic> verifyOtp(form) async {
    try {
      // await Future.delayed(Duration(seconds: 1));
      // return DummyData.login;
      final result = await httpManager.post(
        url: Globals.host + '/auth/verifyOtp',
        data: form,
      );
      return result;
    } catch (err) {
      print(err);
      return err;
    }
  }

  static Future<dynamic> resendOtp(form) async {
    try {
      // await Future.delayed(Duration(seconds: 1));
      // return DummyData.login;
      final result = await httpManager.post(
        url: Globals.host + '/auth/resendOtp',
        data: form,
      );
      return result;
    } catch (err) {
      print(err);
      return err;
    }
  }

  static Future<dynamic> updatePassword(form) async {
    try {
      // await Future.delayed(Duration(seconds: 1));
      // return DummyData.login;
      final result = await httpManager.post(
        url: Globals.host + '/auth/updatePassword',
        data: form,
      );
      return result;
    } catch (err) {
      print(err);
      return err;
    }
  }

  static Future<dynamic> apple(form) async {
    final res = await httpManager.post(
      url: Globals.host + "/auth/apple",
      data: form,
    );
    return res;
  }

  static Future<dynamic> syncApple(form) async {
    final res = await httpManager.post(
      url: Globals.host + "/auth/syncApple",
      data: form,
    );
    return res;
  }

  static Future<dynamic> google(form) async {
    final res = await httpManager.post(
      url: Globals.host + "/auth/google",
      data: form,
    );
    return res;
  }

  static Future<dynamic> syncGoogle(form) async {
    final res = await httpManager.post(
      url: Globals.host + "/auth/syncGoogle",
      data: form,
    );
    return res;
  }

  static Future<dynamic> facebook(form) async {
    final res = await httpManager.post(
      url: Globals.host + "/auth/facebook",
      data: form,
    );
    return res;
  }

  static Future<dynamic> syncFacebook(form) async {
    final res = await httpManager.post(
      url: Globals.host + "/auth/syncFacebook",
      data: form,
    );
    return res;
  }

  static Future<dynamic> oauthGoogle(form) async {
    final res = await httpManager.post(
      url: Globals.host + "/auth/oauth/google",
      data: form,
    );
    return res;
  }

  static Future<dynamic> oauthFacebook(form) async {
    try {
      return await httpManager.post(
        url: Globals.host + "/auth/oauth/facebook",
        data: form,
      );
    } catch (err) {
      print(err);
      return err;
    }
  }

  static Future<dynamic> getProfile() async {
    // try {
      // await Future.delayed(Duration(seconds: 2));
      // return DummyData.profile;
      final result = await httpManager.get(
        url: Globals.host + '/auth/me',
      );
      return result;
    // } catch (err) {
    //   print(err);
    //   return err;
    // }
  }
}
