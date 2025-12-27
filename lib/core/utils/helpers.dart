class AppHelpers {
  static bool isEmpty(String? value) => value == null || value.isEmpty;

  static bool isNotEmpty(String? value) => !isEmpty(value);

  static bool isValidEmail(String email) {
    return email.contains('@') && email.contains('.');
  }
}
