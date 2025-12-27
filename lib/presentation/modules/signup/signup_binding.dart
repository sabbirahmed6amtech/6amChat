import 'package:get/get.dart';
import '../../../../core/services/service_locator.dart';
import 'signup_controller.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SignupController>(getIt<SignupController>());
  }
}
