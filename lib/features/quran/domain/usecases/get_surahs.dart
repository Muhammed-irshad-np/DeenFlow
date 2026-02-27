import 'package:dartz/dartz.dart';
import 'package:deenflow/core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/surah.dart';
import '../repositories/quran_repository.dart';

class GetSurahsUseCase
    implements UseCase<Either<Failure, List<Surah>>, NoParams> {
  final QuranRepository repository;

  GetSurahsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Surah>>> call(NoParams params) async {
    return await repository.getSurahs();
  }
}
