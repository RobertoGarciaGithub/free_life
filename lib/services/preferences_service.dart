import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const _keyBiometricEnabled = 'biometric_enabled';
  static const _keyToken = 'auth_token';

  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  // Biometria
  bool get isBiometricEnabled => _prefs.getBool(_keyBiometricEnabled) ?? false;

  Future<void> setBiometricEnabled(bool value) async {
    await _prefs.setBool(_keyBiometricEnabled, value);
  }

  Future<void> clearBiometric() async {
    await _prefs.remove(_keyBiometricEnabled);
  }

  // Token de autenticação
  String? get token => _prefs.getString(_keyToken);

  Future<void> setToken(String token) async {
    await _prefs.setString(_keyToken, token);
  }

  Future<void> clearSession() async {
    await _prefs.remove(_keyToken);
    await _prefs.remove(_keyBiometricEnabled);
  }
}
