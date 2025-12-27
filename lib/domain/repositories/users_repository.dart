import '../entities/user_entity.dart';

abstract class UsersRepository {
  Stream<List<UserEntity>> getAllUsers();
}
