import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/core/usecase/usecase.dart';
import 'package:chat_app/features/auth/domain/entities/user_data.dart';
import 'package:chat_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class LoginUsecase implements Usecase<UserData, UserLoginParams> {
  final AuthRepository authRepository;

  LoginUsecase({required this.authRepository});

  @override
  Future<Either<Failure, UserData>> call(UserLoginParams params) {
    return authRepository.loginWithEmailandPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserLoginParams {
  final String email;
  final String password;

  UserLoginParams({required this.email, required this.password});
}
