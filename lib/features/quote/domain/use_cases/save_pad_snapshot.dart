import 'package:fpdart/fpdart.dart';
import 'package:kuwot/core/domain/use_case.dart';
import 'package:kuwot/core/error/failure.dart';
import 'package:kuwot/features/quote/domain/entities/pad_snapshot.dart';
import 'package:kuwot/features/quote/domain/repositories/pad_repository.dart';

class SavePadSnapshot extends UseCase<Unit, PadSnapshot> {
  SavePadSnapshot(PadRepository repository) : _repository = repository;

  final PadRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(PadSnapshot params) {
    return _repository.save(params);
  }
}
