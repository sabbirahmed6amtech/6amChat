import 'package:flutter/material.dart';

import '../modules/login/login_binding.dart';
import '../modules/login/login_view.dart';
import '../modules/signup/signup_binding.dart';
import '../modules/signup/signup_view.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/chat/chat_binding.dart';
import '../modules/chat/chat_view.dart';

class AppPages {
  static const initial = Routes.login;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.login:
        return MaterialPageRoute(
          builder: (_) => LoginBinding(
            child: const LoginView(),
          ),
        );

      case Routes.signup:
        return MaterialPageRoute(
          builder: (_) => SignupBinding(
            child: const SignupView(),
          ),
        );

      case Routes.home:
        return MaterialPageRoute(
          builder: (_) => HomeBinding(
            child: const HomeView(),
          ),
        );

      case Routes.chat:
        final args = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) => ChatBinding(
            child: ChatView(
              recipientName: args['recipientName'],
              recipientId: args['recipientId'],
              currentUserId: args['currentUserId'],
              currentUserName: args['currentUserName'],
            ),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Route not found'),
            ),
          ),
        );
    }
  }
}

abstract class Routes {
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const chat = '/chat';
}
