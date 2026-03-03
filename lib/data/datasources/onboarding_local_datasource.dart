import 'package:shared_preferences/shared_preferences.dart';

abstract class OnboardingLocalDataSource {
  Future<bool> isCompleted();
  Future<void> setCompleted();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  OnboardingLocalDataSourceImpl([SharedPreferences? prefs]) : _prefs = prefs;

  final SharedPreferences? _prefs;
  static const _key = 'onboarding_completed';

  @override
  Future<bool> isCompleted() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  @override
  Future<void> setCompleted() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
  }
}
