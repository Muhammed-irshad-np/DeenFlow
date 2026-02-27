import 'package:dartz/dartz.dart';
import 'package:deenflow/core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/quran_repository.dart';

class GetLastReadUseCase
    implements UseCase<Either<Failure, Map<String, int>?>, NoParams> {
  final QuranRepository repository;

  GetLastReadUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, int>?>> call(NoParams params) async {
    return await repository.getLastRead();
  }
}
