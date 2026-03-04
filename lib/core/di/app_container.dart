import '../analytics/app_analytics.dart';
import '../analytics/no_op_analytics.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/cat_remote_datasource.dart';
import '../../data/datasources/onboarding_local_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/cat_repository_impl.dart';
import '../../data/repositories/onboarding_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/cat_repository.dart';
import '../../domain/repositories/onboarding_repository.dart';

class AppContainer {
  AppContainer._();

  static AppAnalytics? _analytics;
  static AuthRepository? _authRepository;
  static OnboardingRepository? _onboardingRepository;
  static CatRepository? _catRepository;

  static set analytics(AppAnalytics value) {
    _analytics = value;
  }

  static AppAnalytics get analytics {
    return _analytics ?? NoOpAnalytics();
  }

  static AuthRepository get authRepository {
    _authRepository ??= AuthRepositoryImpl(AuthLocalDataSourceImpl());
    return _authRepository!;
  }

  static OnboardingRepository get onboardingRepository {
    _onboardingRepository ??=
        OnboardingRepositoryImpl(OnboardingLocalDataSourceImpl());
    return _onboardingRepository!;
  }

  static CatRepository get catRepository {
    _catRepository ??= CatRepositoryImpl(CatRemoteDataSourceImpl());
    return _catRepository!;
  }

  static void reset() {
    _analytics = null;
    _authRepository = null;
    _onboardingRepository = null;
    _catRepository = null;
  }
}
