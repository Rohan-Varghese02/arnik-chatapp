import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/core/usecase/usecase.dart';
import 'package:chat_app/features/auth/domain/entities/user_data.dart';
import 'package:chat_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class GoogleSignInUsecase implements Usecase<UserData, NoParams> {
  final AuthRepository authRepository;

  GoogleSignInUsecase({required this.authRepository});

  @override
  Future<Either<Failure, UserData>> call(NoParams params) {
    return authRepository.signInWithGoogle();
  }
}

