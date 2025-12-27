import 'package:get/get.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/users_usecase.dart';

class HomeController extends GetxController {
  final UsersUseCase _usersUseCase;
  
  RxList<UserEntity> users = <UserEntity>[].obs;
  RxBool isLoading = false.obs;

  HomeController(this._usersUseCase);

  @override
  void onInit() {
    super.onInit();
    fetchAllUsers();
  }

  void fetchAllUsers() {
    isLoading.value = true;
    update();
    _usersUseCase.getAllUsers().listen(
      (userList) {
        users.value = userList;
        isLoading.value = false;
        update();
      },
      onError: (error) {
        isLoading.value = false;
        Get.snackbar('Error', 'Failed to fetch users');
        update();
      },
    );
  }
}
