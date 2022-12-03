import 'package:dartz/dartz.dart';
import 'package:flutter_with_clean_architecture/core/error/failures.dart';

mixin UseCase<T, P> {
  Future<Either<Failure, T>> call(P params);
}
