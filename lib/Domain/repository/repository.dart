


//User features
import '../entities/user/user_entity.dart';

abstract class Repository {
  Future<String> getCurrentUid();
  Future<void> createUser(UserEntity user);
  Future<void> signInUser(UserEntity user);
  Future<void> signUpUser(UserEntity user);
  Future<void> signOut();


  Future<void> matchAndRegisterUser(UserEntity currentUser, List<UserEntity> potentialMatches, List<Chat> chat);
}