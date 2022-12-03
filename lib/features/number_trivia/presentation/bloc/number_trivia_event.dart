part of 'number_trivia_bloc.dart';

@immutable
abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();

  @override
  List<Object> get props => [];
}

@immutable
class GetTriviaForConcreteNumber extends NumberTriviaEvent {
  const GetTriviaForConcreteNumber(this.numberString);

  final String numberString;

  @override
  List<Object> get props => [numberString];
}

@immutable
class GetTriviaForRandomNumber extends NumberTriviaEvent {
  const GetTriviaForRandomNumber();
}
