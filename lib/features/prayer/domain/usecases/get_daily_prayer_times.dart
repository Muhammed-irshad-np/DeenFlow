import '../../../../core/usecases/usecase.dart';
import '../entities/prayer_settings.dart';
import '../entities/prayer_time_record.dart';
import '../repositories/prayer_repository.dart';

class GetDailyPrayerTimesParams {
  final DateTime date;
  final PrayerSettings settings;

  const GetDailyPrayerTimesParams({required this.date, required this.settings});
}

class GetDailyPrayerTimes
    implements UseCase<List<PrayerTimeRecord>, GetDailyPrayerTimesParams> {
  final PrayerRepository repository;

  GetDailyPrayerTimes(this.repository);

  @override
  Future<List<PrayerTimeRecord>> call(GetDailyPrayerTimesParams params) async {
    return await repository.getDailyPrayerTimes(params.date, params.settings);
  }
}
