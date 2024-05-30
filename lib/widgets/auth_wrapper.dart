import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminder_app/provider/auth_provider.dart';
import 'package:reminder_app/provider/email_provider.dart';
import 'package:reminder_app/screens/home_screen.dart';
import 'package:reminder_app/screens/signin_screen.dart';


class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final email = ref.watch(emailProvider);
    return authState.when(
      data: (data) {
        if (data!=null) {
          return HomeScreen(email);
        }else{
          return const SigninScreen();

        }
      },
      error: (error, stackTrace) => Text('Error : $error'),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
