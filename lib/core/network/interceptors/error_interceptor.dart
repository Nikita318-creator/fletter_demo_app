import 'package:dio/dio.dart';
import '../network_exception.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    NetworkException exception;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        exception = const TimeoutException();
        break;
      case DioExceptionType.connectionError:
        exception = const NoInternetException();
        break;
      case DioExceptionType.badResponse:
        exception = ServerException(
          'Server returned ${err.response?.statusCode}',
        );
        break;
      default:
        exception = const ServerException();
    }

    // Пробрасываем кастомное исключение дальше через DioException.error
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: exception,
        type: err.type,
      ),
    );
  }
}
