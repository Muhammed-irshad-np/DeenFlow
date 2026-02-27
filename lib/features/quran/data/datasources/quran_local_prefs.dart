import 'package:shared_preferences/shared_preferences.dart';

abstract class QuranLocalPrefs {
  Future<void> saveLastRead(int surahNumber, int ayahNumber);
  Future<Map<String, int>?> getLastRead();
  Future<List<String>> getBookmarks();
  Future<void> addBookmark(int surahNumber, int ayahNumber);
  Future<void> removeBookmark(int surahNumber, int ayahNumber);
}

class QuranLocalPrefsImpl implements QuranLocalPrefs {
  final SharedPreferences sharedPreferences;

  QuranLocalPrefsImpl({required this.sharedPreferences});

  static const String _lastReadSurahKey = 'last_read_surah';
  static const String _lastReadAyahKey = 'last_read_ayah';
  static const String _bookmarksKey = 'bookmarks_list';

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

  @override
  Future<List<String>> getBookmarks() async {
    return sharedPreferences.getStringList(_bookmarksKey) ?? [];
  }

  @override
  Future<void> addBookmark(int surahNumber, int ayahNumber) async {
    final bookmarks = await getBookmarks();
    final bookmarkId = '${surahNumber}_$ayahNumber';
    if (!bookmarks.contains(bookmarkId)) {
      bookmarks.add(bookmarkId);
      await sharedPreferences.setStringList(_bookmarksKey, bookmarks);
    }
  }

  @override
  Future<void> removeBookmark(int surahNumber, int ayahNumber) async {
    final bookmarks = await getBookmarks();
    final bookmarkId = '${surahNumber}_$ayahNumber';
    if (bookmarks.contains(bookmarkId)) {
      bookmarks.remove(bookmarkId);
      await sharedPreferences.setStringList(_bookmarksKey, bookmarks);
    }
  }
}
