import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DocumentField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final String label;

  const DocumentField({
    Key? key,
    required this.controller,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
    this.label = 'CPF',
  }) : super(key: key);

  @override
  State<DocumentField> createState() => _DocumentFieldState();
}

class _DocumentFieldState extends State<DocumentField> {
  String _formatDocument(String value) {
    value = value.replaceAll(RegExp(r'\D'), '');
    if (value.length > 9) {
      return '${value.substring(0, 3)}.${value.substring(3, 6)}.${value.substring(6, 9)}-${value.substring(9)}';
    } else if (value.length > 6) {
      return '${value.substring(0, 3)}.${value.substring(3, 6)}.${value.substring(6)}';
    } else if (value.length > 3) {
      return '${value.substring(0, 3)}.${value.substring(3)}';
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(11),
      ],
      onChanged: (value) {
        final formatted = _formatDocument(value);
        widget.controller.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      },
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: '000.000.000-00',
        prefixIcon: const Icon(Icons.badge_outlined),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe seu CPF';
        }
        final digits = value.replaceAll(RegExp(r'\D'), '');
        if (digits.length != 11) {
          return 'CPF inválido';
        }
        return null;
      },
    );
  }
}
