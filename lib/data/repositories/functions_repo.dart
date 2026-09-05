import 'package:cloud_functions/cloud_functions.dart';

abstract class FunctionsRepository {
  static Future<Map<String, dynamic>> call(
    String functionName, [
    Map<String, dynamic>? parameters,
  ]) async {
    final callable = FirebaseFunctions.instance.httpsCallable(functionName);
    final result = await callable.call(parameters);
    if (result.data != null) return Map<String, dynamic>.from(result.data as Map);
    return {};
  }
}
