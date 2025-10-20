import 'package:fpdart/fpdart.dart';
import 'package:kuwot/core/error/failure.dart';

/// [TReturnType] is the return type of a successful use case call.
/// [TParams] are the parameters that are required to call the use case.
abstract class UseCase<TReturnType, TParams> {
  /// Execute the use case
  Future<Either<Failure, TReturnType>> call(TParams params);
}
