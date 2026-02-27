import 'package:flutter/material.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/ayah.dart';
import '../../domain/entities/surah.dart';
import '../../domain/usecases/get_ayahs_by_surah.dart';
import '../../domain/usecases/get_surahs.dart';
import '../../domain/usecases/get_last_read.dart';
import '../../domain/usecases/save_last_read.dart';

class QuranProvider extends ChangeNotifier {
  final GetSurahsUseCase getSurahsUseCase;
  final GetAyahsBySurahUseCase getAyahsBySurahUseCase;
  final GetLastReadUseCase getLastReadUseCase;
  final SaveLastReadUseCase saveLastReadUseCase;

  QuranProvider({
    required this.getSurahsUseCase,
    required this.getAyahsBySurahUseCase,
    required this.getLastReadUseCase,
    required this.saveLastReadUseCase,
  });

  List<Surah> _surahs = [];
  List<Surah> get surahs => _surahs;

  bool _isLoadingSurahs = false;
  bool get isLoadingSurahs => _isLoadingSurahs;

  String? _surahsErrorMessage;
  String? get surahsErrorMessage => _surahsErrorMessage;

  List<Ayah> _currentAyahs = [];
  List<Ayah> get currentAyahs => _currentAyahs;

  bool _isLoadingAyahs = false;
  bool get isLoadingAyahs => _isLoadingAyahs;

  String? _ayahsErrorMessage;
  String? get ayahsErrorMessage => _ayahsErrorMessage;

  int? _lastReadSurah;
  int? get lastReadSurah => _lastReadSurah;

  int? _lastReadAyah;
  int? get lastReadAyah => _lastReadAyah;

  Future<void> loadSurahs() async {
    _isLoadingSurahs = true;
    _surahsErrorMessage = null;
    notifyListeners();

    final result = await getSurahsUseCase(const NoParams());

    result.fold(
      (failure) {
        _surahsErrorMessage = failure.message;
        _isLoadingSurahs = false;
        notifyListeners();
      },
      (surahs) {
        _surahs = surahs;
        _isLoadingSurahs = false;
        notifyListeners();
      },
    );
  }

  Future<void> loadAyahs(int surahNumber) async {
    _isLoadingAyahs = true;
    _ayahsErrorMessage = null;
    _currentAyahs = [];
    notifyListeners();

    final result = await getAyahsBySurahUseCase(surahNumber);

    result.fold(
      (failure) {
        _ayahsErrorMessage = failure.message;
        _isLoadingAyahs = false;
        notifyListeners();
      },
      (ayahs) {
        _currentAyahs = ayahs;
        _isLoadingAyahs = false;
        notifyListeners();
      },
    );
  }

  Future<void> loadLastRead() async {
    final result = await getLastReadUseCase(const NoParams());
    result.fold(
      (failure) {
        // Silently fail or log error
      },
      (data) {
        if (data != null) {
          _lastReadSurah = data['surah'];
          _lastReadAyah = data['ayah'];
          notifyListeners();
        }
      },
    );
  }

  Future<void> saveLastRead(int surahNumber, int ayahNumber) async {
    _lastReadSurah = surahNumber;
    _lastReadAyah = ayahNumber;
    notifyListeners();

    await saveLastReadUseCase(
      SaveLastReadParams(surahNumber: surahNumber, ayahNumber: ayahNumber),
    );
  }
}
