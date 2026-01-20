import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utill/color_resources.dart';
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
          style:  TextStyle(
            color: ColorResources.textColor,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 3),
        Container(
          decoration: BoxDecoration(
            color:ColorResources.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: ColorResources.borderColor,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: ColorResources.borderColor.withOpacity(0.24),
                blurRadius: 2,
                spreadRadius: 0,
                offset: Offset(0, 1),
              ),
            ],
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
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 1.0,
                ),
              ),

              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 1,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.redAccent,
                  width: 1.5,
                ),
              ),

              counterText: '',
              // border: InputBorder.none,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}
