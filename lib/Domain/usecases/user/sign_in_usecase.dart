


import '../../entities/user/user_entity.dart';
import '../../repository/repository.dart';

class SignUpUseCase {
  final Repository repository;

  SignUpUseCase({required this.repository});

  Future<void> call(UserEntity userEntity) {
    return repository.signUpUser(userEntity);
  }
}