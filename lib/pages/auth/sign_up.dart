import 'package:flutter/material.dart';
import 'package:free_life/providers/auth_provider.dart';
import 'package:free_life/routes/routes.dart';
import 'package:free_life/theme/app_theme.dart';
import 'package:free_life/widgets/button_custom.dart';
import 'package:free_life/widgets/form/email_field.dart';
import 'package:free_life/widgets/form/password_field.dart';
import 'package:free_life/widgets/form/document_field.dart';
import 'package:free_life/widgets/form/text_field.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _documentController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _documentController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.signUp(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      document: _documentController.text,
      password: _passwordController.text,
      passwordConfirmation: _passwordConfirmationController.text,
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(Routes.initial, (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.errorMessage ?? 'Erro ao criar conta.')),
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
                      Icons.person_add_outlined,
                      size: 48,
                      color: AppColors.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Título
                  Text(
                    'Criar conta',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Preencha os dados para se cadastrar',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // nome
                  CustomTextField(
                    controller: _firstNameController,
                    label: 'Nome',
                    hint: 'João',
                    icon: Icons.person_outline,
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),

                  // sobrenome
                  CustomTextField(
                    controller: _lastNameController,
                    label: 'Sobrenome',
                    hint: 'Silva',
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),

                  // E-mail
                  EmailField(controller: _emailController),
                  const SizedBox(height: 16),

                  // CPF / Documento
                  DocumentField(controller: _documentController),
                  const SizedBox(height: 16),

                  // Senha
                  PasswordField(controller: _passwordController),
                  const SizedBox(height: 16),

                  // Confirmar senha
                  PasswordField(
                    controller: _passwordConfirmationController,
                    onFieldSubmitted: (_) => _signUp(),
                    label: 'Confirmar senha',
                  ),
                  const SizedBox(height: 32),

                  // Botão cadastrar
                  Consumer<AuthProvider>(
                    builder: (context, auth, _) => auth.isLoading
                        ? const CircularProgressIndicator()
                        : CustomButton(onPressed: _signUp, text: 'Cadastrar'),
                  ),
                  const SizedBox(height: 16),

                  // Já tem conta
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Já tem uma conta?'),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Entrar'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
