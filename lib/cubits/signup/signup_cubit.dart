import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:lobby/repository/auth_repository.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;
  SignupCubit({@required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SignupState.initial());

  void emailChanged(String value) {
    emit(state.copyWith(emailId: value, status: SignupStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: SignupStatus.initial));
  }

  void signOut() async {
    try {
      await _authRepository.signOut();
      emit(state.copyWith(status: SignupStatus.initial));
    } catch (_) {}
  }

  void signUpWithCredentiails() async {
    try {
      print("Here");
      await _authRepository.signUp(
          emailId: state.emailId, password: state.password);
      emit(state.copyWith(status: SignupStatus.sucess));
    } catch (_) {}
  }

  void signInWithCredentiails() async {
    try {
      print("Here");
      await _authRepository.signIn(
          emailId: state.emailId, password: state.password);
      emit(state.copyWith(status: SignupStatus.sucess));
    } catch (_) {}
  }
}
