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

      // sign_up do Devise não retorna token, precisa fazer login depois
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

  void resetState() {
    _errorMessage = null;
    _setState(AuthState.idle);
  }

  void _setState(AuthState newState) {
    _state = newState;
    notifyListeners();
  }

  String _parseError(dynamic error) {
    try {
      // Tenta pegar erros do Devise: { errors: ["Email já foi utilizado"] }
      final data = (error as dynamic).response?.data;
      if (data != null) {
        if (data['errors'] is List) {
          return (data['errors'] as List).join('\n');
        }
        if (data['error'] is String) return data['error'];
      }
      final status = (error as dynamic).response?.statusCode;
      if (status == 401) return 'E-mail ou senha incorretos.';
      if (status == 422) return 'Dados inválidos. Verifique os campos.';
    } catch (_) {}
    if (error.toString().contains('connection')) {
      return 'Sem conexão com a internet.';
    }
    return 'Algo deu errado. Tente novamente.';
  }
}
