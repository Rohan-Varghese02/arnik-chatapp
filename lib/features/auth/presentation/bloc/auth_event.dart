part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthLogin extends AuthEvent{
  final String email;
  final String pasword;

  AuthLogin({required this.email, required this.pasword});
}

 class AuthSignIn extends AuthEvent{
  final String name;
  final String email;
  final String password;

  AuthSignIn({required this.name, required this.email, required this.password});
 }

