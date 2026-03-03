import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_hw1/data/datasources/auth_local_datasource.dart';
import 'package:flutter_hw1/data/repositories/auth_repository_impl.dart';

void main() {
  late AuthRepositoryImpl repository;
  late FakeAuthLocalDataSource fakeLocal;

  setUp(() {
    fakeLocal = FakeAuthLocalDataSource();
    repository = AuthRepositoryImpl(fakeLocal);
  });

  group('AuthRepositoryImpl', () {
    test('signUp with empty email throws AuthException', () async {
      expect(
        () => repository.signUp('', 'password1'),
        throwsA(isA<AuthException>().having(
          (e) => e.message,
          'message',
          'Введите email',
        )),
      );
    });

    test('signUp with invalid email throws AuthException', () async {
      expect(
        () => repository.signUp('notanemail', 'password1'),
        throwsA(isA<AuthException>().having(
          (e) => e.message,
          'message',
          'Некорректный email',
        )),
      );
    });

    test('signUp with short password throws AuthException', () async {
      expect(
        () => repository.signUp('a@b.co', '12345'),
        throwsA(isA<AuthException>().having(
          (e) => e.message,
          'message',
          'Пароль должен быть не менее 6 символов',
        )),
      );
    });

    test('signUp then getCurrentUser returns user', () async {
      await repository.signUp('user@test.com', 'password123');
      final user = await repository.getCurrentUser();
      expect(user, isNotNull);
      expect(user!.email, 'user@test.com');
    });

    test('signIn with wrong password throws AuthException', () async {
      await repository.signUp('user@test.com', 'correct1');
      expect(
        () => repository.signIn('user@test.com', 'wrong12'),
        throwsA(isA<AuthException>().having(
          (e) => e.message,
          'message',
          'Неверный email или пароль',
        )),
      );
    });

    test('signIn with correct credentials succeeds', () async {
      await repository.signUp('user@test.com', 'password123');
      await repository.signIn('user@test.com', 'password123');
      final user = await repository.getCurrentUser();
      expect(user, isNotNull);
      expect(user!.email, 'user@test.com');
    });

    test('signOut clears user', () async {
      await repository.signUp('user@test.com', 'password123');
      expect(await repository.getCurrentUser(), isNotNull);
      await repository.signOut();
      expect(await repository.getCurrentUser(), isNull);
    });

    test('getCurrentUser returns null when no credentials', () async {
      expect(await repository.getCurrentUser(), isNull);
    });
  });
}

class FakeAuthLocalDataSource implements AuthLocalDataSource {
  String? _email;
  String? _password;
  String? _userId;

  @override
  Future<void> saveCredentials(String email, String password) async {
    _email = email;
    _password = password;
  }

  @override
  Future<Map<String, String>?> getCredentials() async {
    if (_email != null && _password != null) {
      return {'email': _email!, 'password': _password!};
    }
    return null;
  }

  @override
  Future<void> clearCredentials() async {
    _email = null;
    _password = null;
  }

  @override
  Future<void> setUserId(String id) async {
    _userId = id;
  }

  @override
  Future<String?> getUserId() async {
    return _userId;
  }

  @override
  Future<void> clearUserId() async {
    _userId = null;
  }
}
