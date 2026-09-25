import 'package:fpdart/fpdart.dart';
import 'package:kuwot/core/domain/no_params.dart';
import 'package:kuwot/core/domain/use_case.dart';
import 'package:kuwot/core/error/failure.dart';
import 'package:kuwot/features/quote/domain/entities/pad_snapshot.dart';
import 'package:kuwot/features/quote/domain/repositories/pad_repository.dart';

class LoadPadSnapshot extends UseCase<PadSnapshot?, NoParams> {
  LoadPadSnapshot(PadRepository repository) : _repository = repository;

  final PadRepository _repository;

  @override
  Future<Either<Failure, PadSnapshot?>> call(NoParams params) {
    return _repository.load();
  }
}
