abstract class Failure {
  final String message;

  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = "Server Error"]);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = "Cache Error"]);
}
