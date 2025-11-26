import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/features/auth/domain/entities/user_data.dart';
import 'package:fpdart/fpdart.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserData>> loginWithEmailandPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserData>> signInWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });
}
