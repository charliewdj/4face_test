
import 'dart:io';


import '../../Domain/entities/user/user_entity.dart';

abstract class RemoteDataSource {
  //User
  Stream<List<UserEntity>> getUsers(UserEntity user);
  Stream<List<UserEntity>> getSingleUser(String uid);
  Future<String> getCurrentUid();
  Future<void> createUser(UserEntity user);
}