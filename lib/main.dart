import 'package:flutter/material.dart';
import 'package:free_life/provider.dart';
import 'package:free_life/routes/routes.dart';
import 'package:free_life/theme/app_theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final providers = await createProviders();

  runApp(MultiProvider(providers: providers, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routes: Routes.list,
      initialRoute: Routes.authCheck,
      navigatorKey: Routes.navigatorKey,
      debugShowCheckedModeBanner: false,
    );
  }
}
