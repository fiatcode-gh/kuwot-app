import 'package:equatable/equatable.dart';

/// Base class for all failures
abstract class Failure extends Equatable {
  /// Default constructor
  const Failure({required this.message, this.cause});

  /// Message of the failure
  final String message;

  /// Cause of the failure
  final Exception? cause;

  @override
  List<Object?> get props => [message, cause];
}

class ClientFailure extends Failure {
  const ClientFailure({required super.message, super.cause});
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.cause});
}

class UnknownFailure extends Failure {
  const UnknownFailure({required super.message, super.cause});
}
