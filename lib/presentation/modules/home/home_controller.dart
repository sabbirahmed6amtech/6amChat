import 'dart:async';
import 'package:flutter/material.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/users_usecase.dart';

class HomeController with ChangeNotifier {
  final UsersUseCase _usersUseCase;

  HomeController(this._usersUseCase) {
    fetchAllUsers();
  }

  List<UserEntity> users = [];
  bool isLoading = false;

  StreamSubscription? _usersSubscription;

  void fetchAllUsers() {
    isLoading = true;
    notifyListeners();

    _usersSubscription?.cancel();
    _usersSubscription = _usersUseCase.getAllUsers().listen(
          (userList) {
        users = userList;
        isLoading = false;
        notifyListeners();
      },
      onError: (_) {
        isLoading = false;
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _usersSubscription?.cancel();
    super.dispose();
  }
}
