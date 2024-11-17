import 'package:dio/dio.dart';
import 'package:splitz/data/models/splitwise/get_current_user_response.dart';
import 'package:splitz/presentation/widgets/snackbar.dart';
import 'package:splitz/services/auth.dart';
import 'package:splitz/services/log.dart';

const _splitwiseBaseUrl = String.fromEnvironment('SW_BASE_URL');

abstract class Splitwise {
  static Dio? _dio;
  static Future<Dio> get _dioClient async {
    if (_dio != null) return _dio!;
    final splitwiseToken = await Auth.splitwiseToken;
    _dio = Dio(BaseOptions(baseUrl: _splitwiseBaseUrl))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            options.headers['Authorization'] = 'Bearer $splitwiseToken';
            return handler.next(options);
          },
          onError: (e, handler) async {
            showToast('Splitwise.dio.onError: ${e.response?.statusCode}');
            handler.next(e);
          },
        ),
      );
    return _dio!;
  }

  static Future<void> test() async {
    try {
      final dio = await _dioClient;
      final response = await dio.get('/get_current_user');
      final result = GetCurrentUserResponse.fromMap(
        response.data as Map<String, dynamic>,
      );
      return;
    } catch (e, s) {
      Log.that('Splitwise.test', error: e, stackTrace: s);
      return;
    }
  }
}
