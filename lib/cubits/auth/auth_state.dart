part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState({this.user, this.userCredentials});
  final UserModel? user;
  final User? userCredentials;
  AuthLoggedIn copyWith({required UserModel user}) => AuthLoggedIn(user);

  @override
  List<Object?> get props => [user, userCredentials];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {
  String? message;
  AuthLoading({this.message});
}

class AuthLoggedIn extends AuthState {
  const AuthLoggedIn(UserModel user) : super(user: user);

  AuthLoggedIn copyWith({required UserModel user}) => AuthLoggedIn(user);
  @override
  List<Object?> get props => [user, userCredentials];
}

class AuthCodeSent extends AuthState {
  String? phoneNumber;
  String? message;
  int? token;
  AuthCodeSent({this.phoneNumber, this.message, this.token});
}

class AuthNotRegistered extends AuthState {
  AuthNotRegistered({User? userCredentials})
      : super(userCredentials: userCredentials);
}

class AuthNotLoggedIn extends AuthState {}

class AuthError extends AuthState {
  String? message;

  AuthError({this.message, User? userCredentials})
      : super(userCredentials: userCredentials);
  @override
  List<Object?> get props => [message, userCredentials];
}
