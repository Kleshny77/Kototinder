import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_hw1/domain/entities/auth_user.dart';
import 'package:flutter_hw1/domain/repositories/auth_repository.dart';
import 'package:flutter_hw1/data/repositories/auth_repository_impl.dart';
import 'package:flutter_hw1/presentation/screens/login_screen.dart';
import 'package:flutter_hw1/presentation/screens/signup_screen.dart';

void main() {
  group('LoginScreen', () {
    testWidgets('shows error on invalid email when tapping login', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LoginScreen(
            onSuccess: () async {},
            onGoToSignUp: () {},
            authRepository: _FakeAuthRepository(),
          ),
        ),
      );

      await tester.enterText(find.byKey(const Key('login_email')), 'bad');
      await tester.enterText(find.byKey(const Key('login_password')), 'password123');
      await tester.tap(find.text('Войти'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Некорректный email'), findsOneWidget);
    });

    testWidgets('calls onSuccess when sign in succeeds', (tester) async {
      var successCalled = false;
      final fakeRepo = _FakeAuthRepository()..signInSucceeds = true;

      await tester.pumpWidget(
        MaterialApp(
          home: LoginScreen(
            onSuccess: () async {
              successCalled = true;
            },
            onGoToSignUp: () {},
            authRepository: fakeRepo,
          ),
        ),
      );

      await tester.enterText(find.byKey(const Key('login_email')), 'user@test.com');
      await tester.enterText(find.byKey(const Key('login_password')), 'password123');
      await tester.tap(find.text('Войти'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(successCalled, isTrue);
    });
  });

  group('SignUpScreen', () {
    testWidgets('shows error when passwords do not match', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SignUpScreen(
            onSuccess: () async {},
            onGoToLogin: () {},
            authRepository: _FakeAuthRepository(),
          ),
        ),
      );

      await tester.enterText(find.byKey(const Key('signup_email')), 'user@test.com');
      await tester.enterText(find.byKey(const Key('signup_password')), 'password123');
      await tester.enterText(find.byKey(const Key('signup_confirm')), 'other456');
      await tester.tap(find.text('Зарегистрироваться'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Пароли не совпадают'), findsOneWidget);
    });

    testWidgets('calls onSuccess when sign up succeeds', (tester) async {
      var successCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: SignUpScreen(
            onSuccess: () async {
              successCalled = true;
            },
            onGoToLogin: () {},
            authRepository: _FakeAuthRepository(),
          ),
        ),
      );

      await tester.enterText(find.byKey(const Key('signup_email')), 'new@test.com');
      await tester.enterText(find.byKey(const Key('signup_password')), 'password123');
      await tester.enterText(find.byKey(const Key('signup_confirm')), 'password123');
      await tester.tap(find.text('Зарегистрироваться'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(successCalled, isTrue);
    });
  });
}

class _FakeAuthRepository implements AuthRepository {
  bool signInSucceeds = false;

  @override
  Future<AuthUser?> getCurrentUser() async => null;

  @override
  Future<void> signUp(String email, String password) async {}

  @override
  Future<void> signIn(String email, String password) async {
    if (!signInSucceeds) {
      throw AuthException('Неверный email или пароль');
    }
  }

  @override
  Future<void> signOut() async {}
}
