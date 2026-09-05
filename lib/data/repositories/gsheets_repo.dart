import 'package:splitz/data/repositories/functions_repo.dart';

abstract class GSheetsRepository {
  static Future<void> recreate(String groupId, List<List<String>> rows) async {
    await FunctionsRepository.call('recreateGoogleSheet', {
      'groupId': groupId,
      'rows': rows,
    });
  }
}
