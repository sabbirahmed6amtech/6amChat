import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/service_locator.dart';
import '../../../domain/usecases/auth_usecase.dart';
import 'login_controller.dart';

class LoginBinding extends StatelessWidget {
  final Widget child;

  const LoginBinding({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginController>(
      create: (_) => LoginController(getIt<AuthUseCase>()),
      child: child,
    );
  }
}
