part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthUserChanged extends AuthEvent {
  // final auth.User user;
  final UserModel userModel;
  const AuthUserChanged({@required this.userModel});
  @override
  List<Object> get props => [userModel];
}
