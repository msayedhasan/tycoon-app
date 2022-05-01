import '../../config/global.dart';
import '../helpers/http_manager.dart';

class TradeApi {
  static Future getOpenTrades() async {
    try {
      final result = await httpManager.get(
        url: Globals.host + "/trade/openTrades",
      );
      return result;
    } catch (err) {
      print(err);
      return err;
    }
  }

  static getTrade(orderId) async {
    try {
      final result = await httpManager.get(
        url: Globals.host + "/trade/orders&id=$orderId",
      );
      return result;
    } catch (err) {
      print('getTrade catch err');
      print(err);
      return err;
    }
  }

  static getTrades() async {
    try {
      final result = await httpManager.get(
        url: Globals.host + "/trade/getTrades",
      );
      return result;
    } catch (err) {
      return err;
    }
  }

  static newTrade(form) async {
    try {
      final result = await httpManager.post(
        url: Globals.host + "/trade/newTrade",
        data: form,
      );
      return result;
    } catch (err) {
      return err;
    }
  }

  static sellTrade(form) async {
    try {
      final result = await httpManager.post(
        url: Globals.host + "/trade/sellTrade",
        data: form,
      );
      return result;
    } catch (err) {
      return err;
    }
  }

  static cancelTrade(form) async {
    try {
      final result = await httpManager.post(
        url: Globals.host + "/trade/cancelTrade",
        data: form,
      );
      return result;
    } catch (err) {
      return err;
    }
  }
}
