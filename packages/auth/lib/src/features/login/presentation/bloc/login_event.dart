part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object?> get props => [];
}

class LoginEventOnLogin extends LoginEvent {
  final String email;
  final String pwd;

  const LoginEventOnLogin({required this.email, required this.pwd});

  @override
  List<Object?> get props => [email, pwd];
}