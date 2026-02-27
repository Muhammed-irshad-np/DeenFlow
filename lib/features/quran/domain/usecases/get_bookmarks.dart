import 'package:dartz/dartz.dart';
import 'package:deenflow/core/errors/failures.dart';
import 'package:deenflow/core/usecases/usecase.dart';
import '../repositories/quran_repository.dart';

class GetBookmarksUseCase
    implements UseCase<Either<Failure, List<String>>, NoParams> {
  final QuranRepository repository;

  GetBookmarksUseCase(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) async {
    return await repository.getBookmarks();
  }
}
