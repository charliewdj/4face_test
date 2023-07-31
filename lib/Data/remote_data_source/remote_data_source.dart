
import 'dart:io';


import '../../Domain/entities/user/user_entity.dart';

abstract class RemoteDataSource {


  Future<void> signInUser(UserEntity user);
  Future<void> signOut();
  Future<void> signUpUser(UserEntity user);

  //User
  Stream<List<UserEntity>> getUsers(UserEntity user);
  Stream<List<UserEntity>> getSingleUser(String uid);
  Future<String> getCurrentUid();
  Future<void> createUser(UserEntity user);
}