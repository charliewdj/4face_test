import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:four_face/Data/models/user/user_model.dart';
import 'package:four_face/Data/remote_data_source/remote_data_source.dart';
import 'package:four_face/Domain/entities/user/user_entity.dart';
import 'package:instagram_clone/const.dart';
import 'package:instagram_clone/features/data/data_sources/remote_data_source/remote_data_source.dart';
import 'package:instagram_clone/features/data/models/post/post_model.dart';
import 'package:instagram_clone/features/data/models/user/user_model.dart';
import 'package:instagram_clone/features/domain/entities/comment/comment_entity.dart';
import 'package:instagram_clone/features/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/features/domain/entities/replay/replay_entity.dart';
import 'package:instagram_clone/features/domain/entities/user/user_entity.dart';
import 'package:uuid/uuid.dart';

import '../../const.dart';


class RemoteDataSourceImpl implements RemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;

  RemoteDataSourceImpl({required this.firebaseStorage, required this.firebaseFirestore, required this.firebaseAuth});




  @override
  Stream<List<UserEntity>> getSingleUser(String uid) {
    // TODO: implement getSingleUser
    throw UnimplementedError();
  }

  @override
  Stream<List<UserEntity>> getUsers(UserEntity user) {
    // TODO: implement getUsers
    throw UnimplementedError();
  }

  @override
  Future<void> createUser(UserEntity user) {
    final userCollection = firebaseFirestore.collection(FirebaseConsts.users);

    final uid = await getCurrentUid();

    userCollection.doc(uid).get().then((userDoc) {
      final newUser = UserModel(
          uid: uid,
          name: user.name,
          birthdate: user.birthdate,
          username: user.username,
      ).toJson();

      if (!userDoc.exists) {
        userCollection.doc(uid).set(newUser);
      } else {
        userCollection.doc(uid).update(newUser);
      }
    }).catchError((error) {
      toast("Some error occured");
    });
  }


  @override
  Future<String> getCurrentUid() async => firebaseAuth.currentUser!.uid;
}