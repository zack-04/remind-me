import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reminder_app/provider/email_provider.dart';
import 'package:reminder_app/provider/loader_provider.dart';
import 'package:reminder_app/screens/home_screen.dart';
import 'package:reminder_app/screens/signin_screen.dart';
import 'package:reminder_app/utils/firebase_service.dart';
import 'package:reminder_app/utils/snackbar_helper.dart';
import 'package:reminder_app/utils/validator.dart';
import 'package:reminder_app/widgets/custom_button.dart';
import 'package:reminder_app/widgets/custom_form_field.dart';
import 'package:reminder_app/widgets/custom_password_field.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({
    super.key,
  });

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _globalKey = GlobalKey<FormState>();
  bool isFormValid = false;
  bool showPassword = false;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
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
      final response = await FirebaseService().createUser(
        _email.text,
        _password.text,
        _firstName.text,
        _lastName.text,
      );
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
    final isLoading = ref.watch(loaderProvider);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: Stack(
          children: [
            ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 30.sp, top: 30.sp, right: 30.sp),
                  child: Column(
                    children: [
                      SizedBox(height: 30.h),
                      //text
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Sign up to RemindMe",
                          style: TextStyle(
                            fontSize: 25.sp,
                            fontWeight: FontWeight.w400,
                            height: 0.8.h,
                            color: Colors.white70,
                          ),
                        ),
                      ),
            
                      SizedBox(height: 30.h),
                      //form
                      Form(
                        key: _globalKey,
                        child: Column(
                          children: [
                            //first name and surname
                            Row(
                              children: [
                                Expanded(
                                  child: CustomFormField(
                                    controller: _firstName,
                                    validator: Validator.validateName,
                                    label: 'First name',
                                    textInputType: TextInputType.name,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: CustomFormField(
                                    controller: _lastName,
                                    validator: Validator.validateName,
                                    label: 'Last name',
                                    textInputType: TextInputType.name,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.sp),
                            CustomFormField(
                              controller: _email,
                              validator: Validator.validateEmail,
                              label: 'Email',
                              textInputType: TextInputType.emailAddress,
                            ),
                            SizedBox(
                              height: 20.sp,
                            ),
                            //password
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
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      CustomButton(
                        onPressed: () => handleSubmit(ref),
                        text: 'Sign Up',
                        color: Colors.white70,
                        textColor: Colors.black,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?  ",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 15.sp),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SigninScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Signin',
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
                )
              ],
            ),
            Visibility(
              visible: isLoading,
              child: Container(
                color: Colors.black.withOpacity(0.3),
                width: ScreenUtil().screenWidth,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
