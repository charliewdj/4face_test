import 'package:equatable/equatable.dart';
import 'package:four_face/Domain/entities/user/user_entity.dart';



class UserMatchEntity extends Equatable {
  final String? id;
  final String? userId;
  final UserEntity? matchedUser1;
  final UserEntity? matchedUser2;
  final UserEntity? matchedUser3;
  final List<Chat>? chat;

  const UserMatchEntity({
    required this.id,
    required this.userId,
    required this.matchedUser1,
    required this.matchedUser2,
    required this.matchedUser3,
    required this.chat,
  });

  @override
  List<Object?> get props => [id, userId, matchedUser1, matchedUser2, matchedUser3];