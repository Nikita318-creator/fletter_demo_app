import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Подготовка под заголовки / токен
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';
    super.onRequest(options, handler);
  }
}
