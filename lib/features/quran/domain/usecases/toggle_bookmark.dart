import 'package:dartz/dartz.dart';
import 'package:deenflow/core/errors/failures.dart';
import 'package:deenflow/core/usecases/usecase.dart';
import '../repositories/quran_repository.dart';

class ToggleBookmarkParams {
  final int surahNumber;
  final int ayahNumber;
  final bool isBookmarked;

  ToggleBookmarkParams({
    required this.surahNumber,
    required this.ayahNumber,
    required this.isBookmarked,
  });
}

class ToggleBookmarkUseCase
    implements UseCase<Either<Failure, void>, ToggleBookmarkParams> {
  final QuranRepository repository;

  ToggleBookmarkUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ToggleBookmarkParams params) async {
    if (params.isBookmarked) {
      return await repository.removeBookmark(
        params.surahNumber,
        params.ayahNumber,
      );
    } else {
      return await repository.addBookmark(
        params.surahNumber,
        params.ayahNumber,
      );
    }
  }
}
