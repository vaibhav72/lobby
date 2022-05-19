import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lobby/models/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthCubit() : super(AuthInitial()) {
    _userSubscription = user.listen((user) async {
      if (user != null) {
        _userModelSubscription =
            UserModel.collection.doc(user.uid).snapshots().map((data) {
          print("the data is                     ${data.exists}");
          if (data.exists) {
            return UserModel.fromMap(data)?.copyWith(
                documentReference: UserModel.collection.doc(user.uid));
          } else {
            return null;
          }
        }).listen((userModel) {
          if (userModel != null) {
            print("hereeeeeee");
            userModel = userModel.copyWith(user: user);
            emit(AuthLoggedIn(userModel));
          }
          emit(AuthNotRegistered());
        });
      } else {
        emit(AuthNotLoggedIn());
      }
    });
  }

  StreamSubscription<UserModel> _userModelSubscription;
  StreamSubscription<User> _userSubscription;
  Stream<User> get user => _firebaseAuth.userChanges();
  String _verificationId;

  sendOtp(String phoneNumber) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credentials) {
            signInWithCredentials(credentials);
          },
          verificationFailed: (FirebaseAuthException e) {
            throw (e);
          },
          codeSent: (String verificationId, [int forceResendingToken]) {
            _verificationId = verificationId;
            emit(AuthCodeSent(
                phoneNumber: phoneNumber, token: forceResendingToken));
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            _verificationId = verificationId;
          });
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: e.message));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  void verifyOTP(String otp) {
    try {
      log('heree');
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: otp);
      signInWithCredentials(credential);
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  signInWithCredentials(PhoneAuthCredential credential) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  createUser(User user, String email, String name) async {
    // TODO: implement createUser
    try {
      user.updateEmail(email);
      await UserModel.collection.doc(user.uid).set(UserModel(
            user: user,
            email: email,
            displayName: name,
            phoneNumber: user.phoneNumber,
            displayImageUrl: user.photoURL,
            createdAt: DateTime.now(),
            isPremium: false,
            balance: 0,
            isAdmin: false,
          ).toFirestore());
    } catch (_) {
      print(_.toString());
    }
  }
}
