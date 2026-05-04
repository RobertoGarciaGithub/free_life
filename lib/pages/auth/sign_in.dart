import 'package:flutter/material.dart';
import 'package:free_life/providers/auth_provider.dart';
import 'package:free_life/theme/app_theme.dart';
import 'package:free_life/widgets/biometric_setup_sheet.dart';
import 'package:free_life/widgets/button_custom.dart';
import 'package:free_life/routes/routes.dart';
import 'package:free_life/widgets/form/email_field.dart';
import 'package:free_life/widgets/form/password_field.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      await BiometricSetupSheet.show(context);
      if (!mounted) return;
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(Routes.initial, (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.errorMessage ?? 'Erro ao fazer login.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo / ícone
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.lock_outline_rounded,
                      size: 48,
                      color: AppColors.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Título
                  Text(
                    'Free Life!',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Faça login para continuar',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Campo e-mail
                  EmailField(controller: _emailController),

                  const SizedBox(height: 16),
                  // Campo senha

                  // onde estava o TextFormField de email:
                  PasswordField(
                    controller: _passwordController,
                    onFieldSubmitted: (_) => _signIn(),
                  ),
                  const SizedBox(height: 8),

                  // Esqueci a senha
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(Routes.forgotPassword);
                      },
                      child: const Text('Esqueci minha senha'),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Botão entrar
                  Consumer<AuthProvider>(
                    builder: (context, auth, _) => auth.isLoading
                        ? const CircularProgressIndicator()
                        : CustomButton(onPressed: _signIn, text: 'Entrar'),
                  ),
                  const SizedBox(height: 16),

                  // Cadastro
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Não tem uma conta?'),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(Routes.signUp);
                        },
                        child: const Text('Cadastre-se'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
