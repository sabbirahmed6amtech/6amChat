import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/index.dart';
import '../../../domain/usecases/auth_usecase.dart';

class SignupController with ChangeNotifier {
  final AuthUseCase _authUseCase;

  SignupController(this._authUseCase) {
    _setupAuthStateListener();
  }

  String currentUserName = '';
  String currentUserEmail = '';
  String currentUserId = '';
  bool isLoading = false;

  StreamSubscription? _authSubscription;

  void _setupAuthStateListener() {
    _authSubscription = _authUseCase.getAuthState().listen((user) {
      if (user != null) {
        currentUserId = user.uid;
        _handleUserLoggedIn(user.uid);
      } else {
        _handleUserLoggedOut();
      }
    });
  }

  Future<void> _handleUserLoggedIn(String uid) async {
    try {
      final userData = await _authUseCase.fetchUserData(uid);
      if (userData != null) {
        currentUserName = userData.fullName;
        currentUserEmail = userData.email;
        notifyListeners();
      }
    } catch (_) {}
  }

  void _handleUserLoggedOut() {
    currentUserName = '';
    currentUserEmail = '';
    currentUserId = '';
    notifyListeners();
  }

  Future<void> signup({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      await _authUseCase.signup(
        name: name,
        email: email,
        password: password,
      );

      currentUserName = name;
      currentUserEmail = email;
    } on SignupException catch (e) {
      _showSnackBar(context, e.message, true);
    } catch (_) {
      _showSnackBar(context, 'An unexpected error occurred', true);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      await _authUseCase.login(
        email: email,
        password: password,
      );
    } on LoginException catch (e) {
      _showSnackBar(context, e.message, true);
    } catch (_) {
      _showSnackBar(context, 'An unexpected error occurred', true);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();
      await _authUseCase.logout();
    } catch (e) {
      _showSnackBar(context, e.toString(), true);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _showSnackBar(BuildContext context, String message, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
