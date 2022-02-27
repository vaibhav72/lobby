import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:lobby/models/user_model.dart';

abstract class BaseAuthRepository {
  Stream<auth.User> get user;

  Future<auth.User> signUp(
      {@required String emailId, @required String password});
  Future<auth.User> signIn(
      {@required String emailId, @required String password});
  Future<auth.User> signOut();
  createUser(auth.User user);
}
