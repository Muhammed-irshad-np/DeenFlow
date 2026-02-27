import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/prayer_settings.dart';

abstract class SettingsLocalDataSource {
  Future<PrayerSettings> getSettings();
  Future<void> saveSettings(PrayerSettings settings);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences sharedPreferences;

  SettingsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<PrayerSettings> getSettings() async {
    final lat = sharedPreferences.getDouble('prayer_lat');
    final lng = sharedPreferences.getDouble('prayer_lng');
    final locName = sharedPreferences.getString('prayer_loc_name');
    final methodStr = sharedPreferences.getString('prayer_method') ?? 'auto';
    final madhabStr = sharedPreferences.getString('prayer_madhab') ?? 'shafi';

    CalculationMethodType method = CalculationMethodType.values.firstWhere(
      (e) => e.name == methodStr,
      orElse: () => CalculationMethodType.auto,
    );
    MadhabType madhab = MadhabType.values.firstWhere(
      (e) => e.name == madhabStr,
      orElse: () => MadhabType.shafi,
    );

    return PrayerSettings(
      latitude: lat,
      longitude: lng,
      locationName: locName,
      calculationMethod: method,
      madhab: madhab,
    );
  }

  @override
  Future<void> saveSettings(PrayerSettings settings) async {
    if (settings.latitude != null) {
      await sharedPreferences.setDouble('prayer_lat', settings.latitude!);
    }
    if (settings.longitude != null) {
      await sharedPreferences.setDouble('prayer_lng', settings.longitude!);
    }
    if (settings.locationName != null) {
      await sharedPreferences.setString(
        'prayer_loc_name',
        settings.locationName!,
      );
    }
    await sharedPreferences.setString(
      'prayer_method',
      settings.calculationMethod.name,
    );
    await sharedPreferences.setString('prayer_madhab', settings.madhab.name);
  }
}
