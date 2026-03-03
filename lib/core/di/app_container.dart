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

  static AuthRepository? _authRepository;
  static OnboardingRepository? _onboardingRepository;
  static CatRepository? _catRepository;

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
    _authRepository = null;
    _onboardingRepository = null;
    _catRepository = null;
  }
}
