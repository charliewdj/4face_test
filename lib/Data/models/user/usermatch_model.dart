

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:four_face/Data/models/user/user_model.dart';



import '../../../Domain/entities/user/usermatch_entity.dart';

class UserMatchModel extends UserMatchEntity{
  final String? id;
  final String? userId;
  final UserModel? matchedUser1;
  final UserModel? matchedUser2;
  final UserModel? matchedUser3;
  final List<Chat>? chat;

  UserMatchModel({
  this.id,
  this.userId,
  this.matchedUser1,
  this.matchedUser2,
  this.matchedUser3,
  this chat,
  }) : super(
    id : id,
    userId : userId,
    matchedUser1 : matchedUser1,
    matchedUser2 : matchedUser2,
    matchedUser3 : matchedUser3,
    chat : chat,
  );

  factory UserMatchModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserMatchModel(
    id: snapshot['id'],
    userId: snapshot['userId'],
    matchedUser1: snapshot['matchedUser1'],
    matchedUser2: snapshot['matchedUser2'],
    matchedUser3: snapshot['matchedUser3'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "matchedUser1": matchedUser1,
    "matchedUser2": matchedUser2,
    "matchedUser3": matchedUser3,
    "chat": chat,
  };
}