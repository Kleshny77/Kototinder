import 'app_analytics.dart';

class NoOpAnalytics implements AppAnalytics {
  @override
  void logLoginSuccess() {}

  @override
  void logLoginError(String reason) {}

  @override
  void logSignUpSuccess() {}

  @override
  void logSignUpError(String reason) {}

  @override
  void logLogout() {}

  @override
  void logOnboardingComplete() {}

  @override
  void logCatLike() {}

  @override
  void logCatDislike() {}

  @override
  void logBreedDetailView(String breedName) {}
}
