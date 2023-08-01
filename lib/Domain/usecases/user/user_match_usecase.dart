

import '../../entities/user/user_entity.dart';
import '../../repository/repository.dart';

class UserMatchUseCase {
  final Repository repository;

  UserMatchUseCase({required this.repository});

  Future<void> call(UserEntity currentUser, List<UserEntity> potentialMatches, List<Chat> chat){
      return repository.matchAndRegisterUser(currentUser, potentialMatches, chat);
  }

}
