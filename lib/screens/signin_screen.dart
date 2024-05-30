import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reminder_app/provider/email_provider.dart';
import 'package:reminder_app/provider/loader_provider.dart';
import 'package:reminder_app/screens/home_screen.dart';
import 'package:reminder_app/screens/signup_screen.dart';
import 'package:reminder_app/utils/firebase_service.dart';
import 'package:reminder_app/utils/snackbar_helper.dart';
import 'package:reminder_app/utils/validator.dart';
import 'package:reminder_app/widgets/custom_button.dart';
import 'package:reminder_app/widgets/custom_form_field.dart';
import 'package:reminder_app/widgets/custom_password_field.dart';

class SigninScreen extends ConsumerStatefulWidget {
  const SigninScreen({super.key});

  @override
  ConsumerState<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends ConsumerState<SigninScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _globalKey = GlobalKey<FormState>();
  bool isFormValid = false;
  bool showPassword = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void handleSubmit(WidgetRef ref) async {
    isFormValid = _globalKey.currentState!.validate();
    if (!isFormValid) {
      return;
    } else {
      _globalKey.currentState!.save();
      final loaderNotifier = ref.read(loaderProvider.notifier);
      loaderNotifier.setLoading(true);
      final response =
          await FirebaseService().signInUser(_email.text, _password.text);
      
      if (response['type'] == 'SUCCESS' && mounted) {
        loaderNotifier.setLoading(false);
        // ref.read(emailProvider.notifier).setEmail(_email.text);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>  HomeScreen(_email.text),
          ),
        );
      } else if (response['type'] == 'ERROR') {
        if (mounted) {
          SnackbarHelper.showErrorSnackbar(
            context,
            response['message'],
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.only(left: 30.sp, top: 30.sp, right: 30.sp),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 50.h,
                  ),
                  //text
                  Center(
                    child: Text(
                      'Sign in to RemindMe',
                      style: TextStyle(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w400,
                        height: 0.8.h,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  //form
                  SizedBox(
                    child: Form(
                      key: _globalKey,
                      child: Column(
                        children: [
                          CustomFormField(
                            controller: _email,
                            validator: Validator.validateEmail,
                            label: 'Email',
                            textInputType: TextInputType.emailAddress,
                          ),
                          SizedBox(
                            height: 20.sp,
                          ),
                          CustomPasswordField(
                            controller: _password,
                            suffixIcon: GestureDetector(
                              onTap: () => setState(() {
                                showPassword = !showPassword;
                              }),
                              child: const Icon(
                                Icons.remove_red_eye,
                                color: Colors.white70,
                              ),
                            ),
                            showPassword: showPassword,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  CustomButton(
                    onPressed: () => handleSubmit(ref),
                    text: 'Sign In',
                    color: Colors.white70,
                    textColor: Colors.black,
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?  ",
                        style:
                            TextStyle(color: Colors.white70, fontSize: 15.sp),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Signup',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white70,
                            color: Colors.white70,
                            fontSize: 15.sp,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
