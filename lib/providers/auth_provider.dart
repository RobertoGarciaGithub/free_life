import 'package:flutter/material.dart';
import 'package:free_life/models/user.dart';
import 'package:free_life/repositories/auth_repository.dart';
import 'package:free_life/services/preferences_service.dart';

enum AuthState { idle, loading, success, error }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;
  final PreferencesService _prefs;

  AuthProvider(this._repository, this._prefs);

  AuthState _state = AuthState.idle;
  User? _user;
  String? _errorMessage;

  AuthState get state => _state;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == AuthState.loading;

  Future<bool> signIn({required String email, required String password}) async {
    _setState(AuthState.loading);

    try {
      _user = await _repository.signIn(email: email, password: password);

      // Salva o token recebido da API
      if (_user?.token != null) {
        await _prefs.setToken(_user!.token!);
      }

      _setState(AuthState.success);
      return true;
    } catch (e) {
      _errorMessage = _parseError(e);
      _setState(AuthState.error);
      return false;
    }
  }

  Future<bool> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String document,
    required String password,
    required String passwordConfirmation,
  }) async {
    _setState(AuthState.loading);

    try {
      _user = await _repository.signUp(
        firstName: firstName,
        lastName: lastName,
        email: email,
        document: document,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      if (_user?.token != null) {
        await _prefs.setToken(_user!.token!);
      }

      _setState(AuthState.success);
      return true;
    } catch (e) {
      _errorMessage = _parseError(e);
      _setState(AuthState.error);
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await _repository.signOut();
    } finally {
      _user = null;
      await _prefs.clearSession();
      _setState(AuthState.idle);
    }
  }

  Future<bool> forgotPassword({required String email}) async {
    _setState(AuthState.loading);

    try {
      await _repository.forgotPassword(email: email);
      _setState(AuthState.success);
      return true;
    } catch (e) {
      _errorMessage = _parseError(e);
      _setState(AuthState.error);
      return false;
    }
  }

  void resetState() {
    _errorMessage = null;
    _setState(AuthState.idle);
  }

  void _setState(AuthState newState) {
    _state = newState;
    notifyListeners();
  }

  String _parseError(dynamic error) {
    if (error is Exception) {
      final message = error.toString();
      if (message.contains('401')) return 'E-mail ou senha incorretos.';
      if (message.contains('422'))
        return 'Dados inválidos. Verifique os campos.';
      if (message.contains('connection')) return 'Sem conexão com a internet.';
    }
    return 'Algo deu errado. Tente novamente.';
  }
}
