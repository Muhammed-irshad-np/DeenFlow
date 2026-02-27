import 'package:deenflow/core/errors/failures.dart';

import '../entities/ayah.dart';
import '../entities/surah.dart';
import 'package:dartz/dartz.dart';

abstract class QuranRepository {
  Future<Either<Failure, List<Surah>>> getSurahs();
  Future<Either<Failure, List<Ayah>>> getAyahsBySurah(int surahNumber);
  Future<Either<Failure, void>> saveLastRead(int surahNumber, int ayahNumber);
  Future<Either<Failure, Map<String, int>?>> getLastRead();
}
