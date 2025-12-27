import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/service_locator.dart';
import '../../../domain/usecases/chat_usecase.dart';
import 'chat_controller.dart';

class ChatBinding extends StatelessWidget {
  final Widget child;

  const ChatBinding({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChatController>(
      create: (_) => ChatController(getIt<ChatUseCase>()),
      child: child,
    );
  }
}
