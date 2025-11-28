import 'package:chat_app/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract class StreamUsecase<SuccessType, Params> {
  Stream<Either<Failure, SuccessType>> call(Params params);
}
