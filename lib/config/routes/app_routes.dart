// This file is kept for backward compatibility
// All route definitions are now in presentation/routes/app_pages.dart
import 'package:sixamchat/presentation/routes/app_pages.dart';

export '../../presentation/routes/app_pages.dart' show Routes;

/// Convenience alias for Routes class
class AppRoutes {
  static const login = Routes.login;
  static const signup = Routes.signup;
  static const home = Routes.home;
  static const chat = Routes.chat;
}
