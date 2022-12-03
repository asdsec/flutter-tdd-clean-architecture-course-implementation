import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  const Failure([this.properties]);

  final List<dynamic>? properties;

  @override
  List<Object?> get props => [properties];
}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}
