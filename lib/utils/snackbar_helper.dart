import 'package:flutter/material.dart';

class SnackbarHelper {
  static void showErrorSnackbar(BuildContext context, String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red[400],
      ),
    );
  }

  static String getErrorMsgFromCode(String code) {
    String errorMessage = '';
    switch (code) {
      case 'user-not-found':
        errorMessage = 'User not found';
        break;
      case 'invalid-credential':
        errorMessage = 'Invalid credentials used.';
        break;
      case 'wrong-password':
        errorMessage = 'Wrong password provided for this user.';
        break;
      case 'invalid-email':
        errorMessage = 'The email address is not valid.';
        break;
      case 'too-many-requests':
        errorMessage = 'Too many login attempts. Please try again later.';
        break;
      case 'weak-password':
        errorMessage = 'Weak password detected. Please enter a strong one';
        break;
      case 'email-already-in-use':
        errorMessage = 'Email already in use';
        break;
      default:
        errorMessage = 'An error occurred while signing in.';
        break;
    }
    return errorMessage;
  }
}
