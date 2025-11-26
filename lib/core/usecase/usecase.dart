import 'package:chat_app/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract class Usecase<SucessType, Params> {
  Future<Either<Failure, SucessType>> call(Params params);
}

class NoParams {}
