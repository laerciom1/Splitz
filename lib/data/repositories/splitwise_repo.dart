import 'package:dio/dio.dart';
import 'package:splitz/data/models/splitwise/get_expenses/get_expenses_response.dart';
import 'package:splitz/data/models/splitwise/get_groups/get_groups_response.dart';
import 'package:splitz/presentation/widgets/snackbar.dart';
import 'package:splitz/services/auth_service.dart';
import 'package:splitz/services/log_service.dart';

const _splitwiseBaseUrl = String.fromEnvironment('SW_BASE_URL');

abstract class SplitwiseRepository {
  static Dio? _dio;
  static Future<Dio> get _dioClient async {
    if (_dio != null) return _dio!;
    final splitwiseToken = await AuthService.splitwiseToken;
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

  static Future<GetGroupsResponse?> getGroups() async {
    try {
      final dio = await _dioClient;
      final response = await dio.get('/get_groups');
      final result = GetGroupsResponse.fromMap(
        response.data as Map<String, dynamic>,
      );
      return result;
    } catch (e, s) {
      LogService.log('Splitwise.test', error: e, stackTrace: s);
      return null;
    }
  }

  static Future<GetExpensesResponse?> getExpenses() async {
    try {
      final dio = await _dioClient;
      final response = await dio.get('/get_expenses');
      final result = GetExpensesResponse.fromMap(
        response.data as Map<String, dynamic>,
      );
      return result;
    } catch (e, s) {
      LogService.log('Splitwise.test', error: e, stackTrace: s);
      return null;
    }
  }
}
