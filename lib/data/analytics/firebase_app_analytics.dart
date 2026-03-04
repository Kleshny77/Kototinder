import 'package:firebase_analytics/firebase_analytics.dart';

import '../../core/analytics/app_analytics.dart';

class FirebaseAppAnalytics implements AppAnalytics {
  FirebaseAppAnalytics(this._analytics);

  final FirebaseAnalytics _analytics;

  static const _maxParamLength = 100;

  @override
  void logLoginSuccess() {
    _analytics.logLogin(loginMethod: 'email');
  }

  @override
  void logLoginError(String reason) {
    _analytics.logEvent(
      name: 'login_error',
      parameters: {'reason': _truncate(reason)},
    );
  }

  @override
  void logSignUpSuccess() {
    _analytics.logSignUp(signUpMethod: 'email');
  }

  @override
  void logSignUpError(String reason) {
    _analytics.logEvent(
      name: 'sign_up_error',
      parameters: {'reason': _truncate(reason)},
    );
  }

  @override
  void logLogout() {
    _analytics.logEvent(name: 'logout');
  }

  @override
  void logOnboardingComplete() {
    _analytics.logEvent(name: 'onboarding_complete');
  }

  @override
  void logCatLike() {
    _analytics.logEvent(name: 'cat_like');
  }

  @override
  void logCatDislike() {
    _analytics.logEvent(name: 'cat_dislike');
  }

  @override
  void logBreedDetailView(String breedName) {
    _analytics.logEvent(
      name: 'view_breed_detail',
      parameters: {'breed_name': _truncate(breedName)},
    );
  }

  String _truncate(String s) {
    if (s.length <= _maxParamLength) return s;
    return '${s.substring(0, _maxParamLength)}…';
  }
}
