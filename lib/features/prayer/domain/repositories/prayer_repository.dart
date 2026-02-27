import '../entities/prayer_settings.dart';
import '../entities/prayer_time_record.dart';

abstract class PrayerRepository {
  Future<List<PrayerTimeRecord>> getDailyPrayerTimes(
    DateTime date,
    PrayerSettings settings,
  );
  Future<List<PrayerTimeRecord>> getTrackedPrayers(
    DateTime startDate,
    DateTime endDate,
  );
  Future<List<PrayerTimeRecord>> getTrackedPrayersForDate(DateTime date);
  Future<PrayerSettings> getSettings();
  Future<void> saveSettings(PrayerSettings settings);
  Future<void> trackPrayer(PrayerTimeRecord record);
}
