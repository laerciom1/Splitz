import 'package:dio/dio.dart';
import 'package:splitz/services/auth.dart';
import 'package:splitz/services/log.dart';

const _url = String.fromEnvironment('SETTLE_UP_URL');

abstract class SettleUp {
  static Future<void> test() async {
    try {
      final userId = await Auth.settleUpUserId;
      final path = '/userGroups/$userId';

      final dio = Dio(BaseOptions(baseUrl: _url));
      final token = await Auth.settleUpIdToken;
      final response =
          await dio.get('$path.json', queryParameters: {'auth': token});

      Log.that('asdsad');
      return;
    } catch (e, s) {
      Log.that('asd', error: e, stackTrace: s);
      return;
    }
  }
}
