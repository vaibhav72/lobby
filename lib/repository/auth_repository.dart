import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:lobby/models/user_model.dart';
import 'package:lobby/repository/base_auth_repository.dart';

class AuthRepository extends BaseAuthRepository {
  final auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;
  AuthRepository(
      {auth.FirebaseAuth firebaseAuth, FirebaseFirestore firebaseFirestore})
      : _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance,
        _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;
  @override
  Future<auth.User> signUp(
      {@required String emailId, @required String password}) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: emailId, password: password);
      final user = credential.user;
      print("Here");
      print(user);
      return user;
    } catch (_) {
      print(_.toString());
    }
    // TODO: implement signUp
  }

  @override
  // TODO: implement user
  Stream<auth.User> get user => _firebaseAuth.userChanges();

  @override
  Future<auth.User> signIn({String emailId, String password}) async {
    // TODO: implement signIn
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: emailId, password: password);
      final user = credential.user;
      print("Here");
      print(user);
      return user;
    } catch (_) {
      print(_.toString());
    }
  }

  @override
  Future<auth.User> signOut() async {
    // TODO: implement signOut
    try {
      final credential = await _firebaseAuth.signOut();
    } catch (_) {}
  }

  @override
  createUser(auth.User user) async {
    // TODO: implement createUser
    try {
      await UserModel.collection.doc(user.uid).set(UserModel(
              user: user,
              displayImageUrl: user.photoURL,
              isPremium: false,
              isAdmin: false,
              email: user.email)
          .toFirestore());
    } catch (_) {
      print(_.toString());
    }
  }
}
