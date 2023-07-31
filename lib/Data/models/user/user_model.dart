import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../Domain/entities/user/user_entity.dart';

class UserModel extends UserEntity {
  final String? uid;
  final String? username;
  final String? name;
  final String? birthdate;

  UserModel({
    this.uid,
    this.username,
    this.name,
    this.birthdate,
  }) : super(
    uid: uid,
    username: username,
    name: name,
    birthdate: birthdate,
  );

  factory UserModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      name: snapshot['name'],
      birthdate: snapshot['bio'],
      uid: snapshot['uid'],
      username: snapshot['username'],
    );
  }

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "name": name,
    "username": username,
    "birthdate": birthdate,
  };
}
