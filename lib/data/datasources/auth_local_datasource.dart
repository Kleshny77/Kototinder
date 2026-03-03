import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> saveCredentials(String email, String password);
  Future<Map<String, String>?> getCredentials();
  Future<void> clearCredentials();
  Future<void> setUserId(String id);
  Future<String?> getUserId();
  Future<void> clearUserId();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl({
    FlutterSecureStorage? secureStorage,
    SharedPreferences? prefs,
  })  : _storage = secureStorage ?? const FlutterSecureStorage(),
        _prefs = prefs;

  final FlutterSecureStorage _storage;
  final SharedPreferences? _prefs;

  static const _keyEmail = 'auth_email';
  static const _keyPassword = 'auth_password';
  static const _keyUserId = 'auth_user_id';

  @override
  Future<void> saveCredentials(String email, String password) async {
    await _storage.write(key: _keyEmail, value: email);
    await _storage.write(key: _keyPassword, value: password);
  }

  @override
  Future<Map<String, String>?> getCredentials() async {
    final email = await _storage.read(key: _keyEmail);
    final password = await _storage.read(key: _keyPassword);
    if (email != null && password != null) {
      return {'email': email, 'password': password};
    }
    return null;
  }

  @override
  Future<void> clearCredentials() async {
    await _storage.delete(key: _keyEmail);
    await _storage.delete(key: _keyPassword);
  }

  @override
  Future<void> setUserId(String id) async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, id);
  }

  @override
  Future<String?> getUserId() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }

  @override
  Future<void> clearUserId() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
  }
}
