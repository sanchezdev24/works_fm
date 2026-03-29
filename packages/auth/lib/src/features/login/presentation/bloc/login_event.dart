part of 'login_bloc.dart';

abstract class LoginEvent {
}

class LoginEventOnLogin extends LoginEvent {
  final String email;
  final String pwd;

  LoginEventOnLogin({required this.email, required this.pwd});
}