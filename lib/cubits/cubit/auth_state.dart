part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState({this.user});
  final UserModel user;

  @override
  List<Object> get props => [user];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {
  String message;
  AuthLoading({this.message});
}

class AuthLoggedIn extends AuthState {
  const AuthLoggedIn(UserModel user) : super(user: user);
}

class AuthCodeSent extends AuthState {
  String phoneNumber;
  String message;
  int token;
  AuthCodeSent({this.phoneNumber, this.message, this.token});
}

class AuthNotRegistered extends AuthState {
  User userCredentials;
  AuthNotRegistered({this.userCredentials});
}

class AuthNotLoggedIn extends AuthState {}

class AuthError extends AuthState {
  String message;
  AuthError({this.message});
}
