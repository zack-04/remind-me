import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    super.key,
    required this.controller,
    required this.validator,
    required this.label,
    required this.textInputType,
  });

  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String label;
  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      cursorColor: Colors.white70,
      style: const TextStyle(color: Colors.white70),
      keyboardType: textInputType,
      decoration: InputDecoration(
        label: Text(label),
        labelStyle: const TextStyle(
          color: Colors.white70,
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 2,
            color: Colors.white70,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.white70,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
}
