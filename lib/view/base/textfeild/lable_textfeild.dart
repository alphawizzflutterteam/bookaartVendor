import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utill/styles.dart';

class LabeledTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final bool obSecure;
  final int? maxLength;
  final TextInputAction? textInputAction;


  const LabeledTextField({Key? key,

    required this.label,
    required this.hint,
    required this.controller,
    this.inputFormatters,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.enabled = true,
    this.obSecure = false,
    this.textInputAction,
    this.maxLength

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 3),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary,
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller,
            enabled: enabled,
            cursorColor: Theme.of(context).primaryColor,
            keyboardType: keyboardType,
            textInputAction: textInputAction ?? TextInputAction.next,
            inputFormatters: inputFormatters,
            onChanged: onChanged,
            maxLength: maxLength,
            obscureText: obSecure,

            decoration: InputDecoration(
              hintText: hint,
              hintStyle: titilliumRegular.copyWith(
                color: Theme.of(context).hintColor,
                fontSize: 16,
              ),

              counterText: '',
              border: InputBorder.none,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}
