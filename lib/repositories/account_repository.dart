import 'package:free_life/models/account.dart';
import 'package:free_life/services/api_service.dart';

class AccountRepository {
  final ApiService _api;

  AccountRepository(this._api);

  Future<List<Account>> getAccounts() async {
    final response = await _api.client.get('/accounts');
    return (response.data as List)
        .map((json) => Account.fromJson(json))
        .toList();
  }

  Future<Account> getAccount(String id) async {
    final response = await _api.client.get('/accounts/$id');
    return Account.fromJson(response.data);
  }

  Future<Account> createAccount({
    required String name,
    required String type,
    required double balance,
  }) async {
    final response = await _api.client.post(
      '/accounts',
      data: {'name': name, 'type': type, 'balance': balance},
    );
    return Account.fromJson(response.data);
  }

  Future<Account> updateAccount({
    required String id,
    required String name,
    required String type,
    required double balance,
  }) async {
    final response = await _api.client.put(
      '/accounts/$id',
      data: {'name': name, 'type': type, 'balance': balance},
    );
    return Account.fromJson(response.data);
  }

  Future<void> deleteAccount(String id) async {
    await _api.client.delete('/accounts/$id');
  }
}
