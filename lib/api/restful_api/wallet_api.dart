import '../../config/config.dart';

import '../helpers/http_manager.dart';

class WalletApi {
  static Future<dynamic> funding() async {
    try {
      final result = await httpManager.get(
        url: Globals.host + '/wallet/funding',
      );
      return result;
    } catch (err) {
      print(err);
      return err;
    }
  }

  static Future<dynamic> spot() async {
    try {
      final result = await httpManager.get(
        url: Globals.host + '/wallet/account',
      );
      return result;
    } catch (err) {
      print(err);
      return err;
    }
  }

  static Future<dynamic> listenKey() async {
    try {
      final result = await httpManager.get(
        url: Globals.host + '/wallet/listenKey',
      );
      return result;
    } catch (err) {
      print(err);
      return err;
    }
  }
}
