import 'package:shared_preferences/shared_preferences.dart';

abstract class OnboardingLocalDataSource {
  Future<void> saveOnboardingStatus(bool isCompleted);
  Future<bool> checkOnboardingStatus();
}

const String onboardingCompletedKey = 'ONBOARDING_COMPLETED';

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  final SharedPreferences sharedPreferences;

  OnboardingLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveOnboardingStatus(bool isCompleted) async {
    await sharedPreferences.setBool(onboardingCompletedKey, isCompleted);
  }

  @override
  Future<bool> checkOnboardingStatus() async {
    return sharedPreferences.getBool(onboardingCompletedKey) ?? false;
  }
}
