import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const _keyBiometricEnabled = 'biometric_enabled';

  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  bool get isBiometricEnabled => _prefs.getBool(_keyBiometricEnabled) ?? false;

  Future<void> setBiometricEnabled(bool value) async {
    await _prefs.setBool(_keyBiometricEnabled, value);
  }
}
