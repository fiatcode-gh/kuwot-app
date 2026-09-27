import 'package:fpdart/fpdart.dart';
import 'package:kuwot/core/error/failure.dart';
import 'package:kuwot/features/quote/domain/entities/pad_snapshot.dart';

abstract class PadRepository {
  Future<Either<Failure, PadSnapshot?>> load();
  Future<Either<Failure, Unit>> save(PadSnapshot snapshot);
}
