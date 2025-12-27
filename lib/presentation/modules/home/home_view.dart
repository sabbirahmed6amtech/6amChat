import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixamchat/core/constants/app_strings.dart';
import '../../../config/routes/app_routes.dart';
import '../login/login_controller.dart';
import 'home_controller.dart';
import '../../../presentation/shared/widgets/index.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = context.read<LoginController>();
    final homeController = context.read<HomeController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.appName),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authController.logout(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Consumer<LoginController>(
            builder: (_,authCtrl,_) =>
                UserProfileHeader(userName: authCtrl.currentUserName),
          ),
          Expanded(
            child: Consumer<HomeController>(
              builder: (_,controller,_) {
                final authCtrl = context.read<LoginController>();

                if (controller.isLoading) {
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
                        Navigator.pushNamed(
                          context,
                          Routes.chat,
                          arguments: {
                            'recipientName': user.fullName,
                            'recipientId': user.uid,
                            'currentUserId': authCtrl.currentUserId,
                            'currentUserName': authCtrl.currentUserName,
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
