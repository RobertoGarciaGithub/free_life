import 'package:free_life/services/local_auth_service.dart';
import 'package:free_life/services/preferences_service.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<SingleChildWidget>> createProviders() async {
  final prefs = await SharedPreferences.getInstance();

  return [
    Provider<LocalAuthService>(
      create: (_) => LocalAuthService(auth: LocalAuthentication()),
    ),
    Provider<PreferencesService>(create: (_) => PreferencesService(prefs)),
  ];
}
