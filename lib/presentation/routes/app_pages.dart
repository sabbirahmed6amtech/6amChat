import 'package:get/get.dart';
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

  static final routes = [
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.signup,
      page: () => const SignupView(),
      binding: SignupBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.chat,
      page: () {
        final arguments = Get.arguments as Map<String, dynamic>;
        return ChatView(
          recipientName: arguments['recipientName'],
          recipientId: arguments['recipientId'],
          currentUserId: arguments['currentUserId'],
          currentUserName: arguments['currentUserName'],
        );
      },
      binding: ChatBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}

abstract class Routes {
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const chat = '/chat';
}
