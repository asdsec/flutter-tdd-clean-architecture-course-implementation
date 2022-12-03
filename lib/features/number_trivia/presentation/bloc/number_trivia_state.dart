part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();

  @override
  List<Object> get props => [];
}

@immutable
class NumberTriviaEmptyState extends NumberTriviaState {
  const NumberTriviaEmptyState();
}

@immutable
class NumberTriviaLoadingState extends NumberTriviaState {
  const NumberTriviaLoadingState();
}

@immutable
class NumberTriviaLoadedState extends NumberTriviaState {
  const NumberTriviaLoadedState({required this.trivia});

  final NumberTrivia trivia;

  @override
  List<Object> get props => [trivia];
}

@immutable
class NumberTriviaErrorState extends NumberTriviaState {
  const NumberTriviaErrorState({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
