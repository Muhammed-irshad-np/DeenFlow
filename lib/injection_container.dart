import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'features/onboarding/domain/repositories/onboarding_repository.dart';
import 'features/onboarding/domain/usecases/onboarding_usecases.dart';
import 'features/onboarding/presentation/providers/onboarding_provider.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Onboarding
  // Provider
  sl.registerFactory(
    () => OnboardingProvider(saveOnboardingStatusUseCase: sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => SaveOnboardingStatusUseCase(sl()));
  sl.registerLazySingleton(() => CheckOnboardingStatusUseCase(sl()));

  // Repository
  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(localDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<OnboardingLocalDataSource>(
    () => OnboardingLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Features - MainNavigation (To be added later)

  //! Core

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
