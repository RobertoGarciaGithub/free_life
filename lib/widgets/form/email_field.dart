import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  const EmailField({
    Key? key,
    required this.controller,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        labelText: 'E-mail',
        hintText: 'seu@email.com',
        prefixIcon: const Icon(Icons.email_outlined),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe seu e-mail';
        }
        if (!value.contains('@')) {
          return 'E-mail inválido';
        }
        return null;
      },
    );
  }
}
