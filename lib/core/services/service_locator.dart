import 'package:get_it/get_it.dart';
import '../../data/repository/auth_repository_impl.dart';
import '../../data/repository/chat_repository_impl.dart';
import '../../data/repository/users_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/repositories/users_repository.dart';
import '../../domain/usecases/auth_usecase.dart';
import '../../domain/usecases/chat_usecase.dart';
import '../../domain/usecases/users_usecase.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Prevent duplicate registrations during hot reload
  if (getIt.isRegistered<AuthRepository>()) {
    return;
  }

  // Repositories
  getIt.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  getIt.registerSingleton<ChatRepository>(ChatRepositoryImpl());
  getIt.registerSingleton<UsersRepository>(UsersRepositoryImpl());

  // Use Cases
  getIt.registerSingleton<AuthUseCase>(AuthUseCase(getIt<AuthRepository>()));
  getIt.registerSingleton<ChatUseCase>(ChatUseCase(getIt<ChatRepository>()));
  getIt.registerSingleton<UsersUseCase>(UsersUseCase(getIt<UsersRepository>()));
}
