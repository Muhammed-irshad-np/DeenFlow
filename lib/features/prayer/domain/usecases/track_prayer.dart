import '../../../../core/usecases/usecase.dart';
import '../entities/prayer_time_record.dart';
import '../repositories/prayer_repository.dart';

class TrackPrayer implements UseCase<void, PrayerTimeRecord> {
  final PrayerRepository repository;

  TrackPrayer(this.repository);

  @override
  Future<void> call(PrayerTimeRecord params) async {
    return await repository.trackPrayer(params);
  }
}
