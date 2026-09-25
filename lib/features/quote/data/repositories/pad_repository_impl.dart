import 'package:fpdart/fpdart.dart';
import 'package:kuwot/core/data/local/config.dart';
import 'package:kuwot/core/error/failure.dart';
import 'package:kuwot/core/error/reporter.dart';
import 'package:kuwot/features/quote/domain/entities/pad_snapshot.dart';
import 'package:kuwot/features/quote/domain/repositories/pad_repository.dart';

class PadRepositoryImpl implements PadRepository {
  PadRepositoryImpl({
    required this.config,
    this.timeout = const Duration(seconds: 2),
  });

  final Config<PadSnapshot> config;
  final Duration timeout;

  @override
  Future<Either<Failure, PadSnapshot?>> load() async {
    try {
      final snapshot = await config.get().timeout(timeout);
      return right(snapshot);
    } on Object catch (e, st) {
      reportError(error: e, stackTrace: st);
      return left(
        UnknownFailure(
          message: 'Pad storage failed: $e',
          cause: e is Exception ? e : null,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> save(PadSnapshot snapshot) async {
    try {
      await config.set(snapshot).timeout(timeout);
      return right(unit);
    } on Object catch (e, st) {
      reportError(error: e, stackTrace: st);
      return left(
        UnknownFailure(
          message: 'Pad storage failed: $e',
          cause: e is Exception ? e : null,
        ),
      );
    }
  }
}
