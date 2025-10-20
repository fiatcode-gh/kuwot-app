import 'package:fpdart/fpdart.dart';

typedef Function1<T, R> = R Function(T t);

extension EitherFutureX<L, R1> on Future<Either<L, R1>> {
  Future<Either<L, R2>> chain<R2>(
    Function1<R1, Future<Either<L, R2>>> f,
  ) async {
    return (await this).fold(left, f);
  }
}
