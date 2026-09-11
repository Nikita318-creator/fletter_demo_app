sealed class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);
}

class ServerException extends NetworkException {
  const ServerException([super.message = 'Server Error']);
}

class NoInternetException extends NetworkException {
  const NoInternetException([super.message = 'No Internet Connection']);
}

class TimeoutException extends NetworkException {
  const TimeoutException([super.message = 'Request Timeout']);
}
