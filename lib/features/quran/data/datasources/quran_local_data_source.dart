import 'package:quran/quran.dart' as quran;
import '../models/ayah_model.dart';
import '../models/surah_model.dart';

abstract class QuranLocalDataSource {
  Future<List<SurahModel>> getSurahs();
  Future<List<AyahModel>> getAyahsBySurah(int surahNumber);
}

class QuranLocalDataSourceImpl implements QuranLocalDataSource {
  @override
  Future<List<SurahModel>> getSurahs() async {
    // Generate a list of Surahs (1 to 114)
    return List.generate(114, (index) {
      final surahNumber = index + 1;
      return SurahModel(
        number: surahNumber,
        nameArabic: quran.getSurahNameArabic(surahNumber),
        nameEnglish: quran.getSurahNameEnglish(surahNumber),
        revelationType: quran.getPlaceOfRevelation(surahNumber),
        numberOfAyahs: quran.getVerseCount(surahNumber),
      );
    });
  }

  @override
  Future<List<AyahModel>> getAyahsBySurah(int surahNumber) async {
    final verseCount = quran.getVerseCount(surahNumber);
    return List.generate(verseCount, (index) {
      final verseNumber = index + 1;
      return AyahModel(
        number: verseNumber,
        surahNumber: surahNumber,
        textArabic: quran.getVerse(
          surahNumber,
          verseNumber,
          verseEndSymbol: true,
        ),
        textEnglish: quran.getVerseTranslation(surahNumber, verseNumber),
      );
    });
  }
}
