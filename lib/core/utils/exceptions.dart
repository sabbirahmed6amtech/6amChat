// Base exception class
class AppException implements Exception {
  final String message;
  AppException(this.message);

  @override
  String toString() => message;
}

// Authentication exceptions
class AuthException extends AppException {
  AuthException(super.message);
}

class LoginException extends AuthException {
  LoginException(super.message);
}

class SignupException extends AuthException {
  SignupException(super.message);
}

class UserAlreadyExistsException extends SignupException {
  UserAlreadyExistsException()
      : super('Email already registered. Please login instead.');
}

class WeakPasswordException extends SignupException {
  WeakPasswordException() : super('Password is too weak.');
}

class InvalidEmailException extends AuthException {
  InvalidEmailException() : super('Invalid email address.');
}

class UserNotFoundException extends LoginException {
  UserNotFoundException() : super('User not found. Please sign up.');
}

class WrongPasswordException extends LoginException {
  WrongPasswordException() : super('Incorrect password.');
}

