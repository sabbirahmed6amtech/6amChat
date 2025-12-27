import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/service_locator.dart';
import '../../../domain/usecases/auth_usecase.dart';
import 'signup_controller.dart';

class SignupBinding extends StatelessWidget {
  final Widget child;

  const SignupBinding({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignupController>(
      create: (_) => SignupController(getIt<AuthUseCase>()),
      child: child,
    );
  }
}
