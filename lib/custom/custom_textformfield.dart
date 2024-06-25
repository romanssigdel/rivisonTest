import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  String? labelText;
  Function(String)? onChanged;
  String? initialValue;
  TextEditingController? controller;
  String? Function(String?)? validator;
  TextInputType? keyboardType;
  List<TextInputFormatter>? inputFormatters;
  CustomTextFormField(
      {super.key,
      this.onChanged,
      this.labelText,
      this.validator,
      this.keyboardType,
      this.inputFormatters,
      this.controller,
      this.initialValue});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
      child: TextFormField(
        controller: controller,
        initialValue: initialValue,
        // autovalidateMode: AutovalidateMode.onUserInteraction,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
            labelText: labelText,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
      ),
    );
  }
}
