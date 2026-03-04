abstract class AppAnalytics {
  void logLoginSuccess();
  void logLoginError(String reason);
  void logSignUpSuccess();
  void logSignUpError(String reason);
  void logLogout();
  void logOnboardingComplete();
  void logCatLike();
  void logCatDislike();
  void logBreedDetailView(String breedName);
}
