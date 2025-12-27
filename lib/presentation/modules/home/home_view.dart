import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixamchat/core/constants/app_strings.dart';
import '../../../config/routes/app_routes.dart';
import '../login/login_controller.dart';
import 'home_controller.dart';
import '../../../presentation/shared/widgets/index.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<LoginController>();
    Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.appName),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authController.logout();
              Get.offNamed(AppRoutes.login);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          GetBuilder<LoginController>(
            builder: (authCtrl) =>
                UserProfileHeader(userName: authCtrl.currentUserName.value),
          ),
          Expanded(
            child: GetBuilder<HomeController>(
              builder: (controller) {
                final authCtrl = Get.find<LoginController>();

                if (controller.isLoading.value) {
                  return const AppLoading();
                }

                if (controller.users.isEmpty) {
                  return EmptyState(
                    message: AppStrings.noUsers,
                    icon: Icons.people_outline,
                  );
                }

                return ListView.builder(
                  itemCount: controller.users.length,
                  itemBuilder: (context, index) {
                    final user = controller.users[index];

                    return UserListTile(
                      userName: user.fullName,
                      userEmail: user.email,
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.chat,
                          arguments: {
                            'recipientName': user.fullName,
                            'recipientId': user.uid,
                            'currentUserId': authCtrl.currentUserId.value,
                            'currentUserName': authCtrl.currentUserName.value,
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
