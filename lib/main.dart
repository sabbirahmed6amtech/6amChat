import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:sixamchat/presentation/routes/app_pages.dart';

import 'config/firebase_options.dart';
import 'core/services/service_locator.dart';

import 'presentation/modules/login/login_controller.dart';
import 'presentation/modules/signup/signup_controller.dart';
import 'presentation/modules/home/home_controller.dart';
import 'presentation/modules/chat/chat_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    // Firebase already initialized, ignore the error
    debugPrint('Firebase initialization: $e');
  }

  setupServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginController(getIt())),
        ChangeNotifierProvider(create: (_) => SignupController(getIt())),
        ChangeNotifierProvider(create: (_) => HomeController(getIt())),
        ChangeNotifierProvider(create: (_) => ChatController(getIt())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '6am Chat',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: AppPages.initial,
        onGenerateRoute: AppPages.onGenerateRoute,
      ),
    );
  }
}
