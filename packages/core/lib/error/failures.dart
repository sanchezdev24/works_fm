abstract class Failure implements Exception {
  final String code;
  final String? message;
  final Map<String, dynamic>? meta;
  const Failure({required this.code, this.message, this.meta});
}

class ServerFailure extends Failure {
  const ServerFailure({required super.code, super.message, super.meta});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.code, super.message, super.meta});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.code, super.message, super.meta});
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({required super.code, super.message, super.meta});
}
