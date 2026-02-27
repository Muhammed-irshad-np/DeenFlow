import 'package:adhan/adhan.dart';
import '../../domain/entities/prayer_settings.dart';
import '../../domain/entities/prayer_time_record.dart';
import '../../domain/repositories/prayer_repository.dart';
import '../datasources/settings_local_data_source.dart';
import '../datasources/tracker_local_data_source.dart';
import '../models/prayer_time_record_model.dart';

class PrayerRepositoryImpl implements PrayerRepository {
  final SettingsLocalDataSource settingsDataSource;
  final TrackerLocalDataSource trackerDataSource;

  PrayerRepositoryImpl({
    required this.settingsDataSource,
    required this.trackerDataSource,
  });

  @override
  Future<List<PrayerTimeRecord>> getDailyPrayerTimes(
    DateTime date,
    PrayerSettings settings,
  ) async {
    if (settings.latitude == null || settings.longitude == null) {
      return [];
    }

    final coordinates = Coordinates(settings.latitude!, settings.longitude!);
    final dateComponents = DateComponents(date.year, date.month, date.day);

    CalculationParameters params = _getCalculationParameters(
      settings.calculationMethod,
      settings.madhab,
    );
    final prayerTimes = PrayerTimes(coordinates, dateComponents, params);

    final tomorrowDate = date.add(const Duration(days: 1));
    final tomorrowComponents = DateComponents(
      tomorrowDate.year,
      tomorrowDate.month,
      tomorrowDate.day,
    );
    final tomorrowPrayerTimes = PrayerTimes(
      coordinates,
      tomorrowComponents,
      params,
    );

    PrayerTimeRecord createRecord(
      String name,
      DateTime time,
      DateTime endTime,
    ) {
      return PrayerTimeRecord(
        name: name,
        time: time.toLocal(),
        endTime: endTime.toLocal(),
      );
    }

    final fajrEndTime = prayerTimes.sunrise;
    final dhuhrEndTime = prayerTimes.asr;
    final asrEndTime = prayerTimes.maghrib;
    final maghribEndTime = prayerTimes.isha;

    // Islamic midnight: halfway between sunset and tomorrow's fajr
    final sunset = prayerTimes.maghrib;
    final nextFajr = tomorrowPrayerTimes.fajr;
    final differenceToNextFajr = nextFajr.difference(sunset).inMinutes;
    final ishaEndTime = sunset.add(
      Duration(minutes: differenceToNextFajr ~/ 2),
    );

    final prayers = [
      createRecord('Fajr', prayerTimes.fajr, fajrEndTime),
      createRecord('Dhuhr', prayerTimes.dhuhr, dhuhrEndTime),
      createRecord('Asr', prayerTimes.asr, asrEndTime),
      createRecord('Maghrib', prayerTimes.maghrib, maghribEndTime),
      createRecord('Isha', prayerTimes.isha, ishaEndTime),
    ];

    final trackedPrayers = await trackerDataSource.getPrayerRecordsForDate(
      date,
    );

    // Merge calculated times with tracked status
    return prayers.map((calculated) {
      final tracked = trackedPrayers
          .where((t) => t.name == calculated.name)
          .toList();
      if (tracked.isNotEmpty) {
        return calculated.copyWith(isPrayed: tracked.first.isPrayed);
      }
      return calculated;
    }).toList();
  }

  @override
  Future<List<PrayerTimeRecord>> getTrackedPrayers(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await trackerDataSource.getPrayerRecords(startDate, endDate);
  }

  @override
  Future<List<PrayerTimeRecord>> getTrackedPrayersForDate(DateTime date) async {
    return await trackerDataSource.getPrayerRecordsForDate(date);
  }

  @override
  Future<PrayerSettings> getSettings() async {
    return await settingsDataSource.getSettings();
  }

  @override
  Future<void> saveSettings(PrayerSettings settings) async {
    await settingsDataSource.saveSettings(settings);
  }

  @override
  Future<void> trackPrayer(PrayerTimeRecord record) async {
    await trackerDataSource.savePrayerRecord(
      PrayerTimeRecordModel.fromEntity(record),
    );
  }

  CalculationParameters _getCalculationParameters(
    CalculationMethodType method,
    MadhabType madhab,
  ) {
    CalculationParameters params;

    switch (method) {
      case CalculationMethodType.mwl:
        params = CalculationMethod.muslim_world_league.getParameters();
      case CalculationMethodType.isna:
        params = CalculationMethod.north_america.getParameters();
      case CalculationMethodType.egypt:
        params = CalculationMethod.egyptian.getParameters();
      case CalculationMethodType.makkah:
        params = CalculationMethod.umm_al_qura.getParameters();
      case CalculationMethodType.karachi:
        params = CalculationMethod.karachi.getParameters();
      case CalculationMethodType.tehran:
        params = CalculationMethod.tehran.getParameters();
      case CalculationMethodType.singapore:
        params = CalculationMethod.singapore.getParameters();
      case CalculationMethodType.turkey:
        params = CalculationMethod.turkey.getParameters();
      case CalculationMethodType.kuwait:
        params = CalculationMethod.kuwait.getParameters();
      case CalculationMethodType.qatar:
        params = CalculationMethod.qatar.getParameters();
      case CalculationMethodType.gulf:
        params = CalculationMethod.dubai.getParameters();
      case CalculationMethodType.auto:
      default:
        params = CalculationMethod.muslim_world_league
            .getParameters(); // A reasonable default
    }

    if (madhab == MadhabType.hanafi) {
      params.madhab = Madhab.hanafi;
    } else {
      params.madhab = Madhab.shafi;
    }

    return params;
  }
}
