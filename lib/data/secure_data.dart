import 'package:flutter_secure_storage/flutter_secure_storage.dart';


abstract class SecureData{
  Future<String?> getSessionId(String key);
  Future<void> setSessionId({required String value,required String key});
  Future<void> deleteSessionId(String key);

}

class SecureDataProvider implements SecureData{
  static const _secureStorage = FlutterSecureStorage();

  @override
  Future<String?> getSessionId(String key) => _secureStorage.read(key: key);

  @override
  Future<void> setSessionId({required String value,required String key}) {
    return _secureStorage.write(key: key, value: value);
  }

  @override
  Future<void> deleteSessionId(String key) {
    return _secureStorage.delete(key: key);
  }

}