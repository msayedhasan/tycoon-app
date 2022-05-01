import '../../config/config.dart';

import '../helpers/http_manager.dart';

class CoinApi {
  static Future<dynamic> usdtPairs() async {
    try {
      final result = await httpManager.get(
        url: Globals.host + '/market/exchangeInfo',
      );
      return result;
    } catch (err) {
      print(err);
      return err;
    }
  }
}
