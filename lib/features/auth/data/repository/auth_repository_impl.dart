
import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:chat_app/features/auth/domain/entities/user_data.dart';
import 'package:chat_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository{
  final AuthRemoteDatasource authRemoteDatasource;

  AuthRepositoryImpl({required this.authRemoteDatasource});
  @override
  Future<Either<Failure, UserData>> loginWithEmailandPassword({required String email, required String password}) async{
    final response = await authRemoteDatasource.loginWithEmailandPassword(email: email, password: password);
    return right(response);
  }
  
  @override
  Future<Either<Failure, UserData>> signInWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
    String? photoUrl,
  }) async {
    try {
      final response = await authRemoteDatasource.signInWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
        photoUrl: photoUrl,
      );
      return right(response);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserData>> signInWithGoogle() async {
    try {
      final response = await authRemoteDatasource.signInWithGoogle();
      return right(response);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}