sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

final class Failure<T> extends Result<T> {
  final AppFailure failure;
  const Failure(this.failure);
}

sealed class AppFailure {
  final String message;
  const AppFailure(this.message);
}

class ServerFailure extends AppFailure {
  const ServerFailure([super.message = 'Server Error']);
}

class CacheFailure extends AppFailure {
  const CacheFailure([super.message = 'Cache Error']);
}

class NetworkFailure extends AppFailure {
  const NetworkFailure([super.message = 'No Internet Connection']);
}
