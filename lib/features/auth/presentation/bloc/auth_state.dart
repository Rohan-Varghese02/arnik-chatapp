part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}


class LoginSuccess extends AuthState {
  final UserData user;

  LoginSuccess({required this.user});
}

class LoginFailed extends AuthState {
  final String message;

  LoginFailed({required this.message});
}

class SignInSuccess extends AuthState{
  final UserData user;

  SignInSuccess({required this.user});
}

class SignInFailed extends AuthState{
  final String message;

  SignInFailed({required this.message});
}