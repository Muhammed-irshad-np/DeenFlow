import 'package:shared_preferences/shared_preferences.dart';

abstract class QuranLocalPrefs {
  Future<void> saveLastRead(int surahNumber, int ayahNumber);
  Future<Map<String, int>?> getLastRead();
}

class QuranLocalPrefsImpl implements QuranLocalPrefs {
  final SharedPreferences sharedPreferences;

  QuranLocalPrefsImpl({required this.sharedPreferences});

  static const String _lastReadSurahKey = 'last_read_surah';
  static const String _lastReadAyahKey = 'last_read_ayah';

  @override
  Future<void> saveLastRead(int surahNumber, int ayahNumber) async {
    await sharedPreferences.setInt(_lastReadSurahKey, surahNumber);
    await sharedPreferences.setInt(_lastReadAyahKey, ayahNumber);
  }

  @override
  Future<Map<String, int>?> getLastRead() async {
    final surahNumber = sharedPreferences.getInt(_lastReadSurahKey);
    final ayahNumber = sharedPreferences.getInt(_lastReadAyahKey);

    if (surahNumber != null && ayahNumber != null) {
      return {'surah': surahNumber, 'ayah': ayahNumber};
    }
    return null;
  }
}
