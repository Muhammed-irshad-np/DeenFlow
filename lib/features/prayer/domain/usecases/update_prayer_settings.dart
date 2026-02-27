import '../../../../core/usecases/usecase.dart';
import '../entities/prayer_settings.dart';
import '../repositories/prayer_repository.dart';

class UpdatePrayerSettings implements UseCase<void, PrayerSettings> {
  final PrayerRepository repository;

  UpdatePrayerSettings(this.repository);

  @override
  Future<void> call(PrayerSettings params) async {
    return await repository.saveSettings(params);
  }
}

class GetPrayerSettings implements UseCase<PrayerSettings, NoParams> {
  final PrayerRepository repository;

  GetPrayerSettings(this.repository);

  @override
  Future<PrayerSettings> call(NoParams params) async {
    return await repository.getSettings();
  }
}
