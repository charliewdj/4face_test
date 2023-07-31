

import 'dart:io';

import 'package:equatable/equatable.dart';

class UserEntity extends Equatable{
  final String? uid;
  final String? username;
  final String? name;
  final String? birthdate;


  //will not going to be stored in DB
  final File? imageFile;
  final String? password;
  final String? otherUid;

  UserEntity({
    this.imageFile,
    this.uid,
    this.username,
    this.name,
    this.birthdate,
    this.password,
    this.otherUid
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    uid,
    username,
    name,
    birthdate,
    password,
    otherUid,
    imageFile
  ];
}
