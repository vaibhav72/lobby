import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lobby/models/user_model.dart';
import 'package:ntp/ntp.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthCubit() : super(AuthLoading()) {
    try {
      _userSubscription = user.listen((user) async {
        emit(AuthLoading());
        if (user != null) {
          _userModelSubscription =
              UserModel.collection.doc(user.uid).snapshots().map((data) {
            if (data.exists) {
              return UserModel.fromMap(data).copyWith(
                  documentReference: UserModel.collection.doc(user.uid));
            } else {
              return null;
            }
          }).listen((userModel) {
            if (userModel != null) {
              log('User existing');
              if (state.user == userModel) print("data didnt change");
              log(userModel.name);
              UserModel newUserModel = userModel.copyWith(user: user);
              if (state is AuthLoggedIn) {
                log('User already logged in');

                emit(state.copyWith(user: newUserModel));
              } else {
                emit(AuthLoggedIn(newUserModel));
              }
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

  late StreamSubscription<UserModel?> _userModelSubscription;
  late StreamSubscription<User?> _userSubscription;
  Stream<User?> get user => _firebaseAuth.userChanges();
  late String _verificationId;

  sendOtp(String phoneNumber) async {
    try {
      emit(AuthLoading(message: 'Sending OTP'));
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credentials) {
            signInWithCredentials(credentials);
          },
          verificationFailed: (FirebaseAuthException e) {
            emit(AuthError(message: e.message));
          },
          codeSent: (String verificationId, int? forceResendingToken) {
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
      log(' firebase error');
      emit(AuthError(message: e.message));
    } catch (e) {
      log('error');
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
      // user.updateEmail(email).catchError((e) {
      //   log(e.toString());
      //   emit(
      //     AuthError(message: e.toString(), userCredentials: user),
      //   );
      // });
      await UserModel.collection.doc(user.uid).set(UserModel(
            user: user,
            email: email,
            name: name,
            phoneNumber: user.phoneNumber ?? '',
            displayImageUrl: user.photoURL,
            createdAt: (await NTP.now()),
            isPremium: false,
            balance: 0,
            isAdmin: false,
          ).toFirestore());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: e.message, userCredentials: user));
    } catch (_) {
      log(_.toString());
      emit(AuthError(message: _.toString(), userCredentials: user));
    }
  }

  update(User user, String email, String name) async {
    // TODO: implement createUser
    try {
      // user.updateEmail(email).catchError((e) {
      //   log(e.toString());
      //   emit(
      //     AuthError(message: e.toString(), userCredentials: user),
      //   );
      // });
      await UserModel.collection.doc(user.uid).set(UserModel(
            user: user,
            email: email,
            name: name,
            phoneNumber: user.phoneNumber ?? '',
            displayImageUrl: user.photoURL,
            createdAt: (await NTP.now()),
            isPremium: false,
            balance: 0,
            isAdmin: false,
          ).toFirestore());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: e.message, userCredentials: user));
    } catch (_) {
      log(_.toString());
      emit(AuthError(message: _.toString(), userCredentials: user));
    }
  }
}
