part of 'login_bloc.dart';

sealed class LoginState {}

class LoginStateInitial extends LoginState {}

class LoginStateIsLoading extends LoginState {}

class LoginStateIsError extends LoginState {
  final String errorMsg;
  LoginStateIsError(this.errorMsg);
}

class LoginStateIsSuccess extends LoginState {}