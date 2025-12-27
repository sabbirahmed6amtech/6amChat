import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/service_locator.dart';
import '../../../domain/usecases/auth_usecase.dart';
import '../../../domain/usecases/users_usecase.dart';
import '../login/login_controller.dart';
import 'home_controller.dart';

class HomeBinding extends StatelessWidget {
  final Widget child;

  const HomeBinding({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginController>(
          create: (_) => LoginController(getIt<AuthUseCase>()),
        ),
        ChangeNotifierProvider<HomeController>(
          create: (_) => HomeController(getIt<UsersUseCase>()),
        ),
      ],
      child: child,
    );
  }
}
