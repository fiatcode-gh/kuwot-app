/// Exception class for server error
/// Generally, this exception is thrown when the server returns an error response
class ServerException implements Exception {
  const ServerException(this.message);

  final String message;
}

/// Exception class for unauthorized client error
/// this exception is thrown when the client is not authorized
/// to access the resource (server returns 401)
class UnauthorizedException implements Exception {
  const UnauthorizedException(this.message);

  final String message;
}
