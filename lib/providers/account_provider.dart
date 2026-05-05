import 'package:flutter/material.dart';
import 'package:free_life/models/account.dart';
import 'package:free_life/repositories/account_repository.dart';

enum AccountState { idle, loading, success, error }

class AccountProvider extends ChangeNotifier {
  final AccountRepository _repository;

  AccountProvider(this._repository);

  AccountState _state = AccountState.idle;
  List<Account> _accounts = [];
  String? _errorMessage;

  AccountState get state => _state;
  List<Account> get accounts => _accounts;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == AccountState.loading;

  double get totalBalance =>
      _accounts.fold(0, (sum, account) => sum + account.amount);

  Future<void> fetchAccounts() async {
    _setState(AccountState.loading);
    try {
      _accounts = await _repository.getAccounts();
      _setState(AccountState.success);
    } catch (e) {
      _errorMessage = 'Erro ao carregar contas.';
      _setState(AccountState.error);
    }
  }

  Future<bool> createAccount({
    required String name,
    required String type,
    required double balance,
  }) async {
    _setState(AccountState.loading);
    try {
      final account = await _repository.createAccount(
        name: name,
        type: type,
        balance: balance,
      );
      _accounts.add(account);
      _setState(AccountState.success);
      return true;
    } catch (e) {
      _errorMessage = 'Erro ao criar conta.';
      _setState(AccountState.error);
      return false;
    }
  }

  Future<bool> deleteAccount(String id) async {
    try {
      await _repository.deleteAccount(id);
      _accounts.removeWhere((a) => a.id == id);
      _setState(AccountState.success);
      return true;
    } catch (e) {
      _errorMessage = 'Erro ao excluir conta.';
      _setState(AccountState.error);
      return false;
    }
  }

  void resetState() {
    _errorMessage = null;
    _setState(AccountState.idle);
  }

  void _setState(AccountState newState) {
    _state = newState;
    notifyListeners();
  }
}
