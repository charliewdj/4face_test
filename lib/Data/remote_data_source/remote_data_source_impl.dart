import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:four_face/Data/models/user/user_model.dart';
import 'package:four_face/Data/remote_data_source/remote_data_source.dart';
import 'package:four_face/Domain/entities/user/user_entity.dart';

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
  Future<void> createUser(UserEntity user) async {
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

  @override
  Future<void> signInUser(UserEntity user) async {
    try {
      if (user.username!.isNotEmpty || user.password!.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(email: user.username!, password: user.password!);
      } else {
        print("fields cannot be empty");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        toast("user not found");
      }else if (e.code == "wrong-password") {
        toast("Invalid email or password");
      }
    }
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<void> signUpUser(UserEntity user) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(email: user.username!, password: user.password!).then((value) async{
        if (value.user?.uid != null) {
          if (user.imageFile != null) {
            createUser(user);
          } else {
            createUser(user);
          }
        }
      });
      return;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        toast("email is already taken");
      } else {
        toast("something went wrong !");
      }
    }
  }


}