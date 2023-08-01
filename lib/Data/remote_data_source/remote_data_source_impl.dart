import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:four_face/Data/models/user/user_model.dart';
import 'package:four_face/Data/remote_data_source/remote_data_source.dart';
import 'package:four_face/Domain/entities/user/user_entity.dart';

import 'package:uuid/uuid.dart';

import '../../const.dart';
import '../models/user/usermatch_model.dart';


class RemoteDataSourceImpl implements RemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;

  RemoteDataSourceImpl({required this.firebaseStorage, required this.firebaseFirestore, required this.firebaseAuth});



  //userUseCase
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


  //MatchingUseCase
  Future<void> matchAndRegisterUser(
      UserEntity currentUser,
      List<UserEntity> potentialMatches,
      List<Chat> chat,
      ) async {
    try {
      // Step 1: Perform the matching algorithm to select three potential matches
      List<UserModel> matchedUsers = performMatchingAlgorithm(currentUser, potentialMatches);

      // Step 2: Generate a unique ID for the UserMatchedModel
      final userMatchId =  firebaseFirestore.collection('user_matches').doc().id;

      // Step 3: Create the UserMatchedModel
      final userMatchedModel = UserMatchModel(
        id: userMatchId,
        userId: currentUser.uid,
        matchedUser1: matchedUsers.length >= 1 ? matchedUsers[0] : null,
        matchedUser2: matchedUsers.length >= 2 ? matchedUsers[1] : null,
        matchedUser3: matchedUsers.length >= 3 ? matchedUsers[2] : null,
        chat: chat,
      );

      // Step 4: Convert the UserMatchedModel to JSON
      final userMatchedData = userMatchedModel.toJson();

      // Step 5: Register the UserMatchedModel on FirebaseFirestore
      await firebaseFirestore
          .collection('user_matches')
          .doc(userMatchId)
          .set(userMatchedData);
    } catch (e) {
      // Handle any errors here
      print('Error matching and registering user: $e');
    }
  }


  List<UserModel> performMatchingAlgorithm(
      UserModel currentUser,
      List<UserModel> potentialMatches,
      ) {
    // Step 1: Convert UserModel data to numerical feature vectors
    List<List<double>> featureVectors = [];
    List<double> currentUserVector = [
      currentUser.age, // Add other numerical features here
    ];

    for (var match in potentialMatches) {
      List<double> matchVector = [
        match.age, // Add other numerical features here
      ];
      featureVectors.add(matchVector);
    }

    // Step 2: Calculate the Euclidean distance between the currentUserVector and each matchVector
    List<double> distances = [];
    for (var matchVector in featureVectors) {
      double distance = euclideanDistance(currentUserVector, matchVector);
      distances.add(distance);
    }

    // Step 3: Sort the potentialMatches based on distance (ascending order)
    List<UserModel> sortedMatches = [];
    for (var i = 0; i < distances.length; i++) {
      sortedMatches.add(potentialMatches[i]);
    }

    sortedMatches.sort((a, b) => distances[featureVectors.indexOf(currentUserVector)]
        .compareTo(distances[featureVectors.indexOf(currentUserVector)]));

    // Step 4: Return the top three matches
    return sortedMatches.take(3).toList();
  }

  // Helper method to calculate Euclidean distance between two feature vectors
  double euclideanDistance(List<double> vector1, List<double> vector2) {
    double sum = 0.0;
    for (var i = 0; i < vector1.length; i++) {
      sum += pow(vector1[i] - vector2[i], 2);
    }
    return sqrt(sum);
  }




}


