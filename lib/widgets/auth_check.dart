import 'package:flutter/material.dart';

import 'package:free_life/routes/routes.dart';
import 'package:free_life/services/local_auth_service.dart';
import 'package:free_life/services/preferences_service.dart';
import 'package:free_life/theme/app_theme.dart';
import 'package:free_life/widgets/button_custom.dart';
import 'package:provider/provider.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  final ValueNotifier<bool> isLocalAuthFailed = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => checkLocalAuth());
  }

  checkLocalAuth() async {
    try {
      final auth = context.read<LocalAuthService>();
      final prefs = context.read<PreferencesService>();

      // Se o usuário nunca habilitou biometria, vai direto para a home
      if (!prefs.isBiometricEnabled) {
        if (!mounted) return;
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(Routes.signIn, (route) => false);
        return;
      }

      final isLocalAuthAvailable = await auth.isBiometricAvailable();
      isLocalAuthFailed.value = false;

      if (isLocalAuthAvailable) {
        final authenticated = await auth.authenticate();

        if (!authenticated) {
          isLocalAuthFailed.value = true;
        } else {
          if (!mounted) return;
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(Routes.initial, (route) => false);
        }
      } else {
        // Biometria não disponível, vai para sign in
        if (!mounted) return;
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(Routes.signIn, (route) => false);
      }
    } catch (e) {
      isLocalAuthFailed.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: ValueListenableBuilder<bool>(
        valueListenable: isLocalAuthFailed,
        builder: (context, failed, _) {
          if (failed) {
            return Center(
              child: CustomButton(
                onPressed: checkLocalAuth,
                text: 'Tentar autenticar novamente',
              ),
            );
          }
          return Center(
            child: SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                color: AppColors.onPrimary,
                backgroundColor: AppColors.secondary,
              ),
            ),
          );
        },
      ),
    );
  }
}
