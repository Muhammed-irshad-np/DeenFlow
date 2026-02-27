import 'package:flutter/material.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/ayah.dart';
import '../../domain/entities/surah.dart';
import '../../domain/usecases/get_ayahs_by_surah.dart';
import '../../domain/usecases/get_surahs.dart';
import '../../domain/usecases/get_bookmarks.dart';
import '../../domain/usecases/toggle_bookmark.dart';
import '../../domain/usecases/get_last_read.dart';
import '../../domain/usecases/save_last_read.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran/quran.dart' as quran;

class QuranProvider extends ChangeNotifier {
  final GetSurahsUseCase getSurahsUseCase;
  final GetAyahsBySurahUseCase getAyahsBySurahUseCase;
  final GetLastReadUseCase getLastReadUseCase;
  final SaveLastReadUseCase saveLastReadUseCase;
  final GetBookmarksUseCase getBookmarksUseCase;
  final ToggleBookmarkUseCase toggleBookmarkUseCase;

  late final AudioPlayer audioPlayer;

  QuranProvider({
    required this.getSurahsUseCase,
    required this.getAyahsBySurahUseCase,
    required this.getLastReadUseCase,
    required this.saveLastReadUseCase,
    required this.getBookmarksUseCase,
    required this.toggleBookmarkUseCase,
  }) {
    audioPlayer = AudioPlayer();
    _initBookmarks();
  }

  List<String> _bookmarkedAyahs = [];
  List<String> get bookmarkedAyahs => _bookmarkedAyahs;

  bool _isAudioPlaying = false;
  bool get isAudioPlaying => _isAudioPlaying;

  String? _currentlyPlayingAyah; // "surah_ayah" format
  String? get currentlyPlayingAyah => _currentlyPlayingAyah;

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

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

  Future<void> _initBookmarks() async {
    final result = await getBookmarksUseCase(const NoParams());
    result.fold(
      (failure) {}, // Handle error if needed
      (bookmarks) {
        _bookmarkedAyahs = bookmarks;
        notifyListeners();
      },
    );

    // Also listen to audio player state
    audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _isAudioPlaying = false;
        _currentlyPlayingAyah = null;
        notifyListeners();
      }
    });
  }

  bool isBookmarked(int surahNumber, int ayahNumber) {
    return _bookmarkedAyahs.contains('${surahNumber}_$ayahNumber');
  }

  Future<void> toggleBookmark(int surahNumber, int ayahNumber) async {
    final isCurrentlyBookmarked = isBookmarked(surahNumber, ayahNumber);
    final bookmarkId = '${surahNumber}_$ayahNumber';

    // Optimistic UI update
    if (isCurrentlyBookmarked) {
      _bookmarkedAyahs.remove(bookmarkId);
    } else {
      _bookmarkedAyahs.add(bookmarkId);
    }
    notifyListeners();

    final result = await toggleBookmarkUseCase(
      ToggleBookmarkParams(
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
        isBookmarked: isCurrentlyBookmarked,
      ),
    );

    result.fold((failure) {
      // Revert on failure
      if (isCurrentlyBookmarked) {
        _bookmarkedAyahs.add(bookmarkId);
      } else {
        _bookmarkedAyahs.remove(bookmarkId);
      }
      notifyListeners();
    }, (_) {});
  }

  Future<void> playAudio(int surahNumber, int ayahNumber) async {
    try {
      final String ayahKey = '${surahNumber}_$ayahNumber';
      if (_currentlyPlayingAyah == ayahKey && _isAudioPlaying) {
        await stopAudio();
        return;
      }

      _currentlyPlayingAyah = ayahKey;
      _isAudioPlaying = true;
      notifyListeners();

      final url = quran.getAudioURLByVerse(surahNumber, ayahNumber);
      await audioPlayer.setUrl(url);
      await audioPlayer.play();
    } catch (e) {
      _isAudioPlaying = false;
      _currentlyPlayingAyah = null;
      notifyListeners();
    }
  }

  Future<void> stopAudio() async {
    await audioPlayer.stop();
    _isAudioPlaying = false;
    _currentlyPlayingAyah = null;
    notifyListeners();
  }
}
