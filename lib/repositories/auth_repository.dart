import 'package:free_life/models/user.dart';
import 'package:free_life/services/api_service.dart';

class AuthRepository {
  final ApiService _api;

  AuthRepository(this._api);

  // POST /api/v1/auth/login
  // response: { token: "...", user: { id, email, first_name, last_name } }
  Future<User> signIn({required String email, required String password}) async {
    final response = await _api.client.post(
      '/auth/login',
      data: {
        'user': {'email': email, 'password': password},
      },
    );

    final user = User.fromJson(response.data['user']);
    final token = response.data['token'];

    return user.copyWith(token: token);
  }

  // POST /api/v1/auth/register
  // response: { user: { id, email, first_name, last_name } }
  Future<User> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String document,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await _api.client.post(
      '/auth/register',
      data: {
        'user': {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'document': document,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      },
    );

    return User.fromJson(response.data['user']);
  }

  // DELETE /api/v1/auth/logout
  Future<void> signOut() async {
    await _api.client.delete('/auth/logout');
  }
}
