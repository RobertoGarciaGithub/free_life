import 'package:flutter/material.dart';
import 'package:free_life/theme/app_theme.dart';
import 'package:free_life/widgets/button_custom.dart';
import 'package:free_life/routes/routes.dart';
import 'package:free_life/widgets/form/email_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _forgotPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // TODO: implementar autenticação
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);
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
                    'Recupere sua senha!',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Insira seu e-mail para receber as instruções de recuperação de senha.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Campo e-mail
                  EmailField(controller: _emailController),

                  const SizedBox(height: 32),

                  // Botão entrar
                  _isLoading
                      ? const CircularProgressIndicator()
                      : CustomButton(
                          onPressed: _forgotPassword,
                          text: 'Enviar instruções',
                        ),
                  const SizedBox(height: 16),

                  // Cadastro
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Não esqueceu sua senha?'),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(Routes.signIn);
                        },
                        child: const Text('Então faça login!'),
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
