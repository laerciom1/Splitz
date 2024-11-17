import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class StorageService {
  static const _storage = FlutterSecureStorage();

  static Future<String?> read(String key) async =>
      await _storage.read(key: key);

  static Future<void> save(String key, String value) async =>
      await _storage.write(key: key, value: value);

  static Future<void> clear(String key) async =>
      await _storage.delete(key: key);

  static Future<void> clearAll() async => await _storage.deleteAll();
}
