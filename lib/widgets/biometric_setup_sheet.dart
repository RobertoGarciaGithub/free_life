import 'package:flutter/material.dart';
import 'package:free_life/services/local_auth_service.dart';
import 'package:free_life/services/preferences_service.dart';
import 'package:free_life/theme/app_theme.dart';
import 'package:provider/provider.dart';

class BiometricSetupSheet extends StatefulWidget {
  const BiometricSetupSheet({Key? key}) : super(key: key);

  static Future<void> show(BuildContext context) async {
    final auth = context.read<LocalAuthService>();
    final isAvailable = await auth.isBiometricAvailable();
    if (!isAvailable) return;

    if (!context.mounted) return;

    await showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const BiometricSetupSheet(),
    );
  }

  @override
  State<BiometricSetupSheet> createState() => _BiometricSetupSheetState();
}

class _BiometricSetupSheetState extends State<BiometricSetupSheet> {
  bool _isLoading = false;

  Future<void> _enableBiometric() async {
    setState(() => _isLoading = true);

    try {
      final auth = context.read<LocalAuthService>();
      final prefs = context.read<PreferencesService>();

      final authenticated = await auth.authenticate();

      if (authenticated) {
        await prefs.setBiometricEnabled(true);
        if (!mounted) return;
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Biometria ativada com sucesso!')),
        );
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _skip() async {
    final prefs = context.read<PreferencesService>();
    await prefs.setBiometricEnabled(false);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(Icons.fingerprint, size: 42, color: AppColors.primary),
          ),
          const SizedBox(height: 24),
          Text(
            'Ativar biometria?',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            'Nas próximas vezes, você poderá entrar no app usando sua digital ou reconhecimento facial.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 32),
          _isLoading
              ? const CircularProgressIndicator()
              : SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _enableBiometric,
                    icon: const Icon(Icons.fingerprint),
                    label: const Text('Confirmar com digital'),
                  ),
                ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _isLoading ? null : _skip,
            child: const Text('Agora não'),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
