import 'package:dartz/dartz.dart';
import 'package:deenflow/core/errors/failures.dart';
import '../../domain/entities/ayah.dart';
import '../../domain/entities/surah.dart';
import '../../domain/repositories/quran_repository.dart';
import '../datasources/quran_local_data_source.dart';
import '../datasources/quran_local_prefs.dart';

class QuranRepositoryImpl implements QuranRepository {
  final QuranLocalDataSource localDataSource;
  final QuranLocalPrefs localPrefs;

  QuranRepositoryImpl({
    required this.localDataSource,
    required this.localPrefs,
  });

  @override
  Future<Either<Failure, List<Surah>>> getSurahs() async {
    try {
      final surahModels = await localDataSource.getSurahs();
      return Right(surahModels);
    } catch (e) {
      return const Left(CacheFailure('Failed to load Surahs'));
    }
  }

  @override
  Future<Either<Failure, List<Ayah>>> getAyahsBySurah(int surahNumber) async {
    try {
      final ayahModels = await localDataSource.getAyahsBySurah(surahNumber);
      return Right(ayahModels);
    } catch (e) {
      return const Left(CacheFailure('Failed to load Ayahs'));
    }
  }

  @override
  Future<Either<Failure, void>> saveLastRead(
    int surahNumber,
    int ayahNumber,
  ) async {
    try {
      await localPrefs.saveLastRead(surahNumber, ayahNumber);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('Failed to save last read position'));
    }
  }

  @override
  Future<Either<Failure, Map<String, int>?>> getLastRead() async {
    try {
      final result = await localPrefs.getLastRead();
      return Right(result);
    } catch (e) {
      return const Left(CacheFailure('Failed to load last read position'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getBookmarks() async {
    try {
      final result = await localPrefs.getBookmarks();
      return Right(result);
    } catch (e) {
      return const Left(CacheFailure('Failed to load bookmarks'));
    }
  }

  @override
  Future<Either<Failure, void>> addBookmark(
    int surahNumber,
    int ayahNumber,
  ) async {
    try {
      await localPrefs.addBookmark(surahNumber, ayahNumber);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('Failed to add bookmark'));
    }
  }

  @override
  Future<Either<Failure, void>> removeBookmark(
    int surahNumber,
    int ayahNumber,
  ) async {
    try {
      await localPrefs.removeBookmark(surahNumber, ayahNumber);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('Failed to remove bookmark'));
    }
  }
}
