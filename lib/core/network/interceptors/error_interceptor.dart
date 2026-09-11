import 'package:dio/dio.dart';
import '../network_exception.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    ServerException exception;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        exception = NetworkException('Network timeout or no connection');
        break;
      case DioExceptionType.badResponse:
        exception = ServerException(
          'Server response error: ${err.response?.statusCode}',
        );
        break;
      default:
        exception = ServerException('Unexpected network error');
    }

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: exception,
        type: err.type,
      ),
    );
  }
}
