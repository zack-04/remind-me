class Validator {
  static  String? validateName(String? value) {
    final nameRegExp = RegExp(r'^[a-zA-Z]+$');
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (value.length < 4) {
      return 'Must be 4+ chars long';
    }
    if (!nameRegExp.hasMatch(value)) {
      return 'Only alphabets are allowed';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    final passwordRegExp =
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    if (!passwordRegExp.hasMatch(value)) {
      return 'Must be 8+ chars, including a letter and a number';
    }
    return null;
  }
}
