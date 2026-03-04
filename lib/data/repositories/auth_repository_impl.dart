import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._local);

  final AuthLocalDataSource _local;

  @override
  Future<AuthUser?> getCurrentUser() async {
    final userId = await _local.getUserId();
    final creds = await _local.getCredentials();
    if (userId != null && creds != null) {
      final email = creds['email'];
      if (email != null) return AuthUser(email: email, id: userId);
    }
    return null;
  }

  @override
  Future<void> signUp(String email, String password) async {
    _validateEmail(email);
    _validatePassword(password);
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    await _local.saveCredentials(email, password);
    await _local.setUserId(id);
  }

  @override
  Future<void> signIn(String email, String password) async {
    _validateEmail(email);
    _validatePassword(password);
    final creds = await _local.getCredentials();
    if (creds == null) {
      throw AuthException('Пользователь не найден. Зарегистрируйтесь.');
    }
    if (creds['email'] != email || creds['password'] != password) {
      throw AuthException('Неверный email или пароль');
    }
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    await _local.setUserId(id);
  }

  @override
  Future<void> signOut() async {
    await _local.clearUserId();
  }

  void _validateEmail(String email) {
    if (email.isEmpty) throw AuthException('Введите email');
    if (!email.contains('@') || !email.contains('.')) {
      throw AuthException('Некорректный email');
    }
  }

  void _validatePassword(String password) {
    if (password.isEmpty) throw AuthException('Введите пароль');
    if (password.length < 6) {
      throw AuthException('Пароль должен быть не менее 6 символов');
    }
  }
}

class AuthException implements Exception {
  AuthException(this.message);
  final String message;
}
