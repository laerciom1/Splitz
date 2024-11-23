import 'package:dio/dio.dart';
import 'package:splitz/data/models/splitwise/get_categories/get_categories_response.dart';
import 'package:splitz/data/models/splitwise/get_expenses/get_expenses_response.dart';
import 'package:splitz/data/models/splitwise/get_group/get_group_response.dart';
import 'package:splitz/data/models/splitwise/get_groups/get_groups_response.dart';
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
        ),
      );
    return _dio!;
  }

  static Future<GetExpensesResponse?> getExpenses(String groupId) async {
    try {
      final now = DateTime.now();
      final firstDayOfLastMonth = DateTime(now.year, now.month - 1, 1);
      final dio = await _dioClient;
      final response = await dio.get(
        '/get_expenses?group_id=$groupId&dated_after=${firstDayOfLastMonth.toString()}&limit=100',
      );
      final result = GetExpensesResponse.fromMap(
        response.data as Map<String, dynamic>,
      );
      return result;
    } catch (e, s) {
      LogService.log(
        'SplitwiseRepository.getExpenses',
        error: e,
        stackTrace: s,
      );
      return null;
    }
  }

  static Future<GetGroupResponse?> getGroupInfo(String groupId) async {
    try {
      final dio = await _dioClient;
      final response = await dio.get('/get_group/$groupId');
      final result = GetGroupResponse.fromMap(
        response.data as Map<String, dynamic>,
      );
      return result;
    } catch (e, s) {
      LogService.log(
        'SplitwiseRepository.getGroupInfo',
        error: e,
        stackTrace: s,
      );
      return null;
    }
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
      LogService.log('SplitwiseRepository.getGroups', error: e, stackTrace: s);
      return null;
    }
  }

  static Future<GetCategoriesResponse?> getAvailableCategories() async {
    try {
      final dio = await _dioClient;
      final response = await dio.get('/get_categories');
      final result = GetCategoriesResponse.fromMap(
        response.data as Map<String, dynamic>,
      );
      return result;
    } catch (e, s) {
      LogService.log(
        'SplitwiseRepository.getAvailableCategories',
        error: e,
        stackTrace: s,
      );
      return null;
    }
  }
}
