import '../../../../core/usecases/usecase.dart';
import '../repositories/onboarding_repository.dart';

class SaveOnboardingStatusUseCase implements UseCase<void, bool> {
  final OnboardingRepository repository;

  SaveOnboardingStatusUseCase(this.repository);

  @override
  Future<void> call(bool isCompleted) async {
    return await repository.saveOnboardingStatus(isCompleted);
  }
}

class CheckOnboardingStatusUseCase implements UseCase<bool, NoParams> {
  final OnboardingRepository repository;

  CheckOnboardingStatusUseCase(this.repository);

  @override
  Future<bool> call(NoParams params) async {
    return await repository.checkOnboardingStatus();
  }
}
