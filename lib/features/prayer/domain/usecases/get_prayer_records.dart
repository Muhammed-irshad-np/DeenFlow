import '../../../../core/usecases/usecase.dart';
import '../entities/prayer_time_record.dart';
import '../repositories/prayer_repository.dart';

class GetPrayerRecordsParams {
  final DateTime startDate;
  final DateTime endDate;

  const GetPrayerRecordsParams({
    required this.startDate,
    required this.endDate,
  });
}

class GetPrayerRecords
    implements UseCase<List<PrayerTimeRecord>, GetPrayerRecordsParams> {
  final PrayerRepository repository;

  GetPrayerRecords(this.repository);

  @override
  Future<List<PrayerTimeRecord>> call(GetPrayerRecordsParams params) async {
    return await repository.getTrackedPrayers(params.startDate, params.endDate);
  }
}

class GetPrayerRecordsForDate
    implements UseCase<List<PrayerTimeRecord>, DateTime> {
  final PrayerRepository repository;

  GetPrayerRecordsForDate(this.repository);

  @override
  Future<List<PrayerTimeRecord>> call(DateTime params) async {
    return await repository.getTrackedPrayersForDate(params);
  }
}
