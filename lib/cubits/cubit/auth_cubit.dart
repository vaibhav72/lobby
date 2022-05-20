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
    try {
      _userSubscription = user.listen((user) async {
        emit(AuthLoading());
        if (user != null) {
          _userModelSubscription =
              UserModel.collection.doc(user.uid).snapshots().map((data) {
            if (data.exists) {
              return UserModel.fromMap(data)?.copyWith(
                  documentReference: UserModel.collection.doc(user.uid));
            } else {
              return null;
            }
          }).listen((userModel) {
            if (userModel != null) {
              log('User existing');
              userModel = userModel.copyWith(user: user);
              emit(AuthLoggedIn(userModel));
            } else {
              emit(AuthNotRegistered(userCredentials: user));
            }
          });
        } else {
          emit(AuthNotLoggedIn());
        }
      });
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: e.message));
    } on Exception catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  StreamSubscription<UserModel> _userModelSubscription;
  StreamSubscription<User> _userSubscription;
  Stream<User> get user => _firebaseAuth.userChanges();
  String _verificationId;

  sendOtp(String phoneNumber) async {
    try {
      emit(AuthLoading(message: 'Sending OTP'));
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
                phoneNumber: phoneNumber,
                token: forceResendingToken,
                message: 'Code sent'));
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
    emit(AuthLoading(message: 'Verifying OTP'));
    try {
      log('heree');
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: otp);
      signInWithCredentials(credential);
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  void signOut() async {
    emit(AuthLoading(message: 'Signing out'));
    await _firebaseAuth.signOut();
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
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: e.message));
    } catch (_) {
      emit(AuthError(message: _.toString()));
    }
  }
}
