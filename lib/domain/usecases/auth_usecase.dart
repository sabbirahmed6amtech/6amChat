import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class AuthUseCase {
  final AuthRepository _authRepository;

  AuthUseCase(this._authRepository);

  // Sign up
  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    return await _authRepository.signup(
      name: name,
      email: email,
      password: password,
    );
  }

  // Login
  Future<void> login({
    required String email,
    required String password,
  }) async {
    return await _authRepository.login(
      email: email,
      password: password,
    );
  }

  // Logout
  Future<void> logout() async {
    return await _authRepository.logout();
  }

  // Get auth state
  Stream<UserEntity?> getAuthState() {
    return _authRepository.authStateChanges;
  }

  // Fetch user data
  Future<UserEntity?> fetchUserData(String uid) async {
    return await _authRepository.getUserData(uid);
  }
}
