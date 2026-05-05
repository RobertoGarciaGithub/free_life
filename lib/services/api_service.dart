import 'package:dio/dio.dart';
import 'package:free_life/config/app_config.dart';
import 'package:free_life/services/preferences_service.dart';

class ApiService {
  static const _baseUrl = AppConfig.apiBaseUrl;

  final Dio _dio;
  final PreferencesService _prefs;

  ApiService(this._prefs) : _dio = Dio(_baseOptions()) {
    _dio.interceptors.add(_authInterceptor());
    _dio.interceptors.add(_logInterceptor());
  }

  Dio get client => _dio;

  static BaseOptions _baseOptions() => BaseOptions(
    baseUrl: _baseUrl,
    connectTimeout: const Duration(milliseconds: AppConfig.apiTimeout),
    receiveTimeout: const Duration(milliseconds: AppConfig.apiTimeout),
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
  );

  // Adiciona o token em toda requisição automaticamente
  InterceptorsWrapper _authInterceptor() => InterceptorsWrapper(
    onRequest: (options, handler) {
      final token = _prefs.token;
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    },
    onError: (error, handler) {
      // Token expirado → redireciona para login
      if (error.response?.statusCode == 401) {
        _prefs.clearSession();
      }
      handler.next(error);
    },
  );

  LogInterceptor _logInterceptor() =>
      LogInterceptor(requestBody: true, responseBody: true, error: true);
}
