class Validators {
  static String? email(String? value) {
    if (value?.isEmpty ?? true) return 'Please enter email';
    if (!value!.contains('@')) return 'Invalid email';
    return null;
  }

  static String? password(String? value) {
    if (value?.isEmpty ?? true) return 'Please enter password';
    if (value!.length < 6) return 'Password must be 6+ characters';
    return null;
  }

  static String? name(String? value) {
    if (value?.isEmpty ?? true) return 'Please enter name';
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value?.isEmpty ?? true) return 'Please confirm password';
    if (value != password) return 'Passwords do not match';
    return null;
  }
}
