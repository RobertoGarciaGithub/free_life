import 'package:free_life/providers/account_provider.dart';
import 'package:free_life/providers/auth_provider.dart';
import 'package:free_life/repositories/account_repository.dart';
import 'package:free_life/repositories/auth_repository.dart';
import 'package:free_life/services/api_service.dart';
import 'package:free_life/services/local_auth_service.dart';
import 'package:free_life/services/preferences_service.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<SingleChildWidget>> createProviders() async {
  final sharedPrefs = await SharedPreferences.getInstance();
  final prefs = PreferencesService(sharedPrefs);
  final api = ApiService(prefs);

  return [
    Provider<LocalAuthService>(
      create: (_) => LocalAuthService(auth: LocalAuthentication()),
    ),
    Provider<PreferencesService>(create: (_) => prefs),
    Provider<ApiService>(create: (_) => api),
    Provider<AuthRepository>(create: (_) => AuthRepository(api)),
    ChangeNotifierProvider<AuthProvider>(
      create: (_) => AuthProvider(AuthRepository(api), prefs),
    ),
    Provider<AccountRepository>(create: (_) => AccountRepository(api)),
    ChangeNotifierProvider<AccountProvider>(
      create: (_) => AccountProvider(AccountRepository(api)),
    ),
  ];
}
