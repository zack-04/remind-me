import 'package:flutter/material.dart';
import 'package:reminder_app/utils/validator.dart';

class CustomPasswordField extends StatelessWidget {
  const CustomPasswordField({
    super.key,
    required this.controller,
    required this.suffixIcon,
    required this.showPassword,
  });

  final TextEditingController controller;
  final Widget suffixIcon;
  final bool showPassword;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: Validator.validatePassword,
      obscureText: !showPassword,
      cursorColor: Colors.white70,
      style: const TextStyle(color: Colors.white70),
      decoration: InputDecoration(
          label: const Text('Password'),
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
          suffixIcon: suffixIcon),
    );
  }
}
