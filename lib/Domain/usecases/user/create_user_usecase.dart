import '../../entities/user/user_entity.dart';
import '../../repository/repository.dart';

class CreateUserUseCase {
  final Repository repository;

  CreateUserUseCase({required this.repository});

  Future<void> call(UserEntity user) {
    return repository.createUser(user);
  }
}