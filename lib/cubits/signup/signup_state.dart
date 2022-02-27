part of 'signup_cubit.dart';

enum SignupStatus { initial, submitting, sucess, error }

class SignupState extends Equatable {
  final String emailId;
  final String password;
  final SignupStatus status;
  const SignupState(
      {@required this.emailId, @required this.password, @required this.status});
  factory SignupState.initial() {
    return const SignupState(
        emailId: '', password: '', status: SignupStatus.initial);
  }
  SignupState copyWith({String emailId, String password, SignupStatus status}) {
    return SignupState(
        emailId: emailId ?? this.emailId,
        password: password ?? this.password,
        status: status ?? this.status);
  }

  @override
  List<Object> get props => [emailId, password, status];
}

class SignupInitial extends SignupState {}
