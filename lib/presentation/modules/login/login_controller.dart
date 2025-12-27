import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/index.dart';
import '../../../domain/usecases/auth_usecase.dart';

class LoginController extends GetxController {
  final AuthUseCase _authUseCase;
  
  RxString currentUserName = ''.obs;
  RxString currentUserEmail = ''.obs;
  RxString currentUserId = ''.obs;
  RxBool isLoading = false.obs;

  LoginController(this._authUseCase);

  @override
  void onInit() {
    super.onInit();
    _setupAuthStateListener();
  }

  void _setupAuthStateListener() {
    _authUseCase.getAuthState().listen((user) {
      if (user != null) {
        currentUserId.value = user.uid;
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
        currentUserName.value = userData.fullName;
        currentUserEmail.value = userData.email;
        update();
        // Auto-navigate to home if user is already logged in (e.g., on app restart)
        if (Get.currentRoute == '/login') {
          Get.offNamed('/home');
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  void _handleUserLoggedOut() {
    currentUserName.value = '';
    currentUserEmail.value = '';
    currentUserId.value = '';
    update();
  }

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      update();
      await _authUseCase.signup(
        name: name,
        email: email,
        password: password,
      );
      currentUserName.value = name;
      currentUserEmail.value = email;
      update();
    } on SignupException catch (e) {
      Get.snackbar('Signup Failed', e.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      update();
      await _authUseCase.login(
        email: email,
        password: password,
      );
    } on LoginException catch (e) {
      Get.snackbar('Login Failed', e.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      update();
      await _authUseCase.logout();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
