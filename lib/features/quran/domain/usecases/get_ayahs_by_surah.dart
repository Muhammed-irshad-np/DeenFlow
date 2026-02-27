import 'package:dartz/dartz.dart';
import 'package:deenflow/core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/ayah.dart';
import '../repositories/quran_repository.dart';

class GetAyahsBySurahUseCase
    implements UseCase<Either<Failure, List<Ayah>>, int> {
  final QuranRepository repository;

  GetAyahsBySurahUseCase(this.repository);

  @override
  Future<Either<Failure, List<Ayah>>> call(int params) async {
    return await repository.getAyahsBySurah(params);
  }
}
