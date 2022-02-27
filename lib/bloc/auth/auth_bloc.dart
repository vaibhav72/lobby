import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:lobby/models/user_model.dart';
import 'package:lobby/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<auth.User> _userSubscription;
  StreamSubscription<UserModel> _userModelSubscription;
  AuthBloc({@required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthState.unknown()) {
    _userSubscription = _authRepository.user.listen((user) async {
      if (user != null) {
        _userModelSubscription =
            UserModel.collection.doc(user.uid).snapshots().map((data) {
          print("the data is                     ${data.exists}");
          if (data.exists) {
            return UserModel.fromMap(data)?.copyWith(
                documentReference: UserModel.collection.doc(user.uid));
          } else {
            _authRepository.createUser(user);
          }
        }).listen((userModel) {
          if (userModel != null) {
            print("hereeeeeee");
            userModel = userModel.copyWith(user: user);
            add(AuthUserChanged(userModel: userModel));
          }
        });
      } else
        _authRepository.createUser(user);
    });

    on<AuthEvent>((event, emit) {
      if (event is AuthUserChanged) {
        // print(event.user);
        {
          print(event.userModel.user);
          if (event.userModel?.user != null) {
            print(event.userModel.user);
            emit(AuthState.authenticated(user: event.userModel));
          } else {
            emit(AuthState.unauthenticated());
          }
        }
      }
      // TODO: implement event handler
    });
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    _userModelSubscription.cancel();
    super.close();
  }
}
