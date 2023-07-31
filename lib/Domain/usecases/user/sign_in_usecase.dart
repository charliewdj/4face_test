


import '../../entities/user/user_entity.dart';
import '../../repository/repository.dart';

class SignInUserUseCase {
  final Repository repository;

  SignInUserUseCase({required this.repository});

  Future<void> call(UserEntity userEntity) {
    return repository.signInUser(userEntity);
  }
}