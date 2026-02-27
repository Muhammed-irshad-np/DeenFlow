import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'features/onboarding/domain/repositories/onboarding_repository.dart';
import 'features/onboarding/domain/usecases/onboarding_usecases.dart';
import 'features/onboarding/presentation/providers/onboarding_provider.dart';

import 'core/utils/database_helper.dart';

import 'features/prayer/data/datasources/settings_local_data_source.dart';
import 'features/prayer/data/datasources/tracker_local_data_source.dart';
import 'features/prayer/data/repositories/prayer_repository_impl.dart';
import 'features/prayer/domain/repositories/prayer_repository.dart';
import 'features/prayer/domain/usecases/get_daily_prayer_times.dart';
import 'features/prayer/domain/usecases/get_prayer_records.dart';
import 'features/prayer/domain/usecases/track_prayer.dart';
import 'features/prayer/domain/usecases/update_prayer_settings.dart';
import 'features/prayer/presentation/providers/prayer_provider.dart';

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

  //! Features - Prayer
  // Provider
  sl.registerFactory(
    () => PrayerProvider(
      getDailyPrayerTimes: sl(),
      getPrayerSettings: sl(),
      updatePrayerSettings: sl(),
      trackPrayer: sl(),
    ),
  );

  // UseCases
  sl.registerLazySingleton(() => GetDailyPrayerTimes(sl()));
  sl.registerLazySingleton(() => GetPrayerSettings(sl()));
  sl.registerLazySingleton(() => UpdatePrayerSettings(sl()));
  sl.registerLazySingleton(() => TrackPrayer(sl()));
  sl.registerLazySingleton(() => GetPrayerRecords(sl()));
  sl.registerLazySingleton(() => GetPrayerRecordsForDate(sl()));

  // Repository
  sl.registerLazySingleton<PrayerRepository>(
    () =>
        PrayerRepositoryImpl(settingsDataSource: sl(), trackerDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<TrackerLocalDataSource>(
    () => TrackerLocalDataSourceImpl(sl()),
  );

  //! Core
  sl.registerLazySingleton(() => DatabaseHelper.instance);

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
