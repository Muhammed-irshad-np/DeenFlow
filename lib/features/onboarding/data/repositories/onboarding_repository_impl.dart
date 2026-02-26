import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_local_data_source.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource localDataSource;

  OnboardingRepositoryImpl({required this.localDataSource});

  @override
  Future<void> saveOnboardingStatus(bool isCompleted) async {
    return await localDataSource.saveOnboardingStatus(isCompleted);
  }

  @override
  Future<bool> checkOnboardingStatus() async {
    return await localDataSource.checkOnboardingStatus();
  }
}
