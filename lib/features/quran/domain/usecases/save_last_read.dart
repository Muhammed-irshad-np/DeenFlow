import 'package:dartz/dartz.dart';
import 'package:deenflow/core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/quran_repository.dart';

class SaveLastReadParams {
  final int surahNumber;
  final int ayahNumber;

  SaveLastReadParams({required this.surahNumber, required this.ayahNumber});
}

class SaveLastReadUseCase
    implements UseCase<Either<Failure, void>, SaveLastReadParams> {
  final QuranRepository repository;

  SaveLastReadUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveLastReadParams params) async {
    return await repository.saveLastRead(params.surahNumber, params.ayahNumber);
  }
}
