abstract class OnboardingRepository {
  Future<void> saveOnboardingStatus(bool isCompleted);
  Future<bool> checkOnboardingStatus();
}
