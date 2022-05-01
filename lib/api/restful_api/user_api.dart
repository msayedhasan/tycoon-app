import '../../config/config.dart';

import '../helpers/http_manager.dart';

class UserApi {
  static Future<dynamic> getAll() async {
    final result = await httpManager.get(url: Globals.host + '/user');
    return result;
  }

  static Future<dynamic> updateUser(form) async {
    final result = await httpManager.put(
      url: Globals.host + '/user',
      data: form,
    );
    return result;
  }
}
