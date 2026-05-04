import 'package:free_life/models/user.dart';
import 'package:free_life/services/api_service.dart';

class AuthRepository {
  final ApiService _api;

  AuthRepository(this._api);

  Future<User> signIn({required String email, required String password}) async {
    final response = await _api.client.post(
      '/auth/sign_in',
      data: {'email': email, 'password': password},
    );
    return User.fromJson(response.data);
  }

  Future<User> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String document,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await _api.client.post(
      '/auth/sign_up',
      data: {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'document': document,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );
    return User.fromJson(response.data);
  }

  Future<void> signOut() async {
    await _api.client.delete('/auth/sign_out');
  }

  Future<void> forgotPassword({required String email}) async {
    await _api.client.post('/auth/forgot_password', data: {'email': email});
  }
}
