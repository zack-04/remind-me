import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmailNotifier extends StateNotifier<String> {
  EmailNotifier() : super('');

  void setEmail(String email) {
    state = email;
  }

  void clearEmail() {
    state = '';
  }
}

final emailProvider = StateNotifierProvider<EmailNotifier, String>((ref) {
  return EmailNotifier();
});