import 'package:get/get.dart';
import '../../../../core/services/service_locator.dart';
import '../login/login_controller.dart';
import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<LoginController>(getIt<LoginController>());
    Get.put<HomeController>(getIt<HomeController>());
  }
}
