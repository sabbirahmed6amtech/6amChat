import '../entities/user_entity.dart';
import '../repositories/users_repository.dart';

class UsersUseCase {
  final UsersRepository _usersRepository;

  UsersUseCase(this._usersRepository);

  // Get all users
  Stream<List<UserEntity>> getAllUsers() {
    return _usersRepository.getAllUsers();
  }
}
