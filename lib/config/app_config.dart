class AppConfig {
  AppConfig._();

  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api/v1',
  );

  static const apiTimeout = int.fromEnvironment(
    'API_TIMEOUT',
    defaultValue: 10000,
  );
}
