
import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/core/usecase/usecase.dart';
import 'package:chat_app/features/auth/domain/entities/user_data.dart';
import 'package:chat_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/src/either.dart';

class SignInUsecase implements Usecase<UserData,UserSigninParams>{
    final AuthRepository authRepository;

  SignInUsecase({required this.authRepository});

  @override
  Future<Either<Failure, UserData>> call(UserSigninParams params) {
    return authRepository.signInWithEmailAndPassword(name: params.name, email: params.email, password: params.password);
  }
}


class UserSigninParams {
  final String name;
  final String email;
  final String password;

  UserSigninParams({required this.name, required this.email, required this.password});
}