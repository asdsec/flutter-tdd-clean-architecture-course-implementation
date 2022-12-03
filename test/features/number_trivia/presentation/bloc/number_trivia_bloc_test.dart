import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_with_clean_architecture/core/error/failures.dart';
import 'package:flutter_with_clean_architecture/core/utility/input_converter.dart';
import 'package:flutter_with_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_with_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_with_clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_with_clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([
  MockSpec<GetConcreteNumberTrivia>(),
  MockSpec<GetRandomNumberTrivia>(),
  MockSpec<InputConverter>(),
])
import 'number_trivia_bloc_test.mocks.dart';

void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('should initial state is NumberTriviaEmptyState', () {
    // assert
    expect(bloc.state, equals(const NumberTriviaEmptyState()));
  });

  group('GetTriviaForConcreteNumber -', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    test(
      'should call the InputConverter to validate and convert the string to as unsigned integer',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(tNumberString)).thenReturn(
          const Right(tNumberParsed),
        );
        when(mockGetConcreteNumberTrivia(const Params(number: tNumberParsed))).thenAnswer(
          (_) async => const Right(tNumberTrivia),
        );
        // act
        bloc.add(const GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(tNumberString));
        // assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );

    test(
      'should emit NumberTriviaErrorState when the input is invalid',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(tNumberString)).thenReturn(
          Left(InvalidInputFailure()),
        );
        // act
        bloc.add(const GetTriviaForConcreteNumber(tNumberString));
        // assert
        final expectedOrder = [
          const NumberTriviaErrorState(message: INVALID_INPUT_FAILURE_MESSAGE),
        ];
        await expectLater(bloc.stream, emitsInOrder(expectedOrder));
      },
    );

    test(
      'should get data from the concrete use case',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(tNumberString)).thenReturn(
          const Right(tNumberParsed),
        );
        when(mockGetConcreteNumberTrivia(const Params(number: tNumberParsed))).thenAnswer(
          (_) async => const Right(tNumberTrivia),
        );
        // act
        bloc.add(const GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)));
        // assert
        verify(mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)));
      },
    );

    test(
      'should emit NumberTriviaLoadingState and NumberTriviaLoadedState when data is gotten successfully',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(tNumberString)).thenReturn(
          const Right(tNumberParsed),
        );
        when(mockGetConcreteNumberTrivia(const Params(number: tNumberParsed))).thenAnswer(
          (_) async => const Right(tNumberTrivia),
        );
        // act
        bloc.add(const GetTriviaForConcreteNumber(tNumberString));
        // assert
        const expected = [
          NumberTriviaLoadingState(),
          NumberTriviaLoadedState(trivia: tNumberTrivia),
        ];
        await expectLater(bloc.stream, emitsInOrder(expected));
      },
    );

    test(
      'should emit NumberTriviaLoadingState and NumberTriviaErrorState when getting data fails',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(tNumberString)).thenReturn(
          const Right(tNumberParsed),
        );
        when(mockGetConcreteNumberTrivia(const Params(number: tNumberParsed))).thenAnswer(
          (_) async => Left(ServerFailure()),
        );
        // act
        bloc.add(const GetTriviaForConcreteNumber(tNumberString));
        // assert
        const expected = [
          NumberTriviaLoadingState(),
          NumberTriviaErrorState(message: SERVER_FAILURE_MESSAGE),
        ];
        await expectLater(bloc.stream, emitsInOrder(expected));
      },
    );

    test(
      'should emit NumberTriviaLoadingState and NumberTriviaErrorState with proper message for the error when getting data fails',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(tNumberString)).thenReturn(
          const Right(tNumberParsed),
        );
        when(mockGetConcreteNumberTrivia(const Params(number: tNumberParsed))).thenAnswer(
          (_) async => Left(CacheFailure()),
        );
        // act
        bloc.add(const GetTriviaForConcreteNumber(tNumberString));
        // assert
        const expected = [
          NumberTriviaLoadingState(),
          NumberTriviaErrorState(message: CACHE_FAILURE_MESSAGE),
        ];
        await expectLater(bloc.stream, emitsInOrder(expected));
      },
    );
  });

  group('GetTriviaForRandomNumber -', () {
    const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    test(
      'should get data from the random use case',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(const NoParams())).thenAnswer(
          (_) async => const Right(tNumberTrivia),
        );
        // act
        bloc.add(const GetTriviaForRandomNumber());
        await untilCalled(mockGetRandomNumberTrivia(const NoParams()));
        // assert
        verify(mockGetRandomNumberTrivia(const NoParams()));
      },
    );

    test(
      'should emit NumberTriviaLoadingState and NumberTriviaLoadedState when data is gotten successfully',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(const NoParams())).thenAnswer(
          (_) async => const Right(tNumberTrivia),
        );
        // act
        bloc.add(const GetTriviaForRandomNumber());
        // assert
        const expected = [
          NumberTriviaLoadingState(),
          NumberTriviaLoadedState(trivia: tNumberTrivia),
        ];
        await expectLater(bloc.stream, emitsInOrder(expected));
      },
    );

    test(
      'should emit NumberTriviaLoadingState and NumberTriviaErrorState when getting data fails',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(const NoParams())).thenAnswer(
          (_) async => Left(ServerFailure()),
        );
        // act
        bloc.add(const GetTriviaForRandomNumber());
        // assert
        const expected = [
          NumberTriviaLoadingState(),
          NumberTriviaErrorState(message: SERVER_FAILURE_MESSAGE),
        ];
        await expectLater(bloc.stream, emitsInOrder(expected));
      },
    );

    test(
      'should emit NumberTriviaLoadingState and NumberTriviaErrorState with proper message for the error when getting data fails',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(const NoParams())).thenAnswer(
          (_) async => Left(CacheFailure()),
        );
        // act
        bloc.add(const GetTriviaForRandomNumber());
        // assert
        const expected = [
          NumberTriviaLoadingState(),
          NumberTriviaErrorState(message: CACHE_FAILURE_MESSAGE),
        ];
        await expectLater(bloc.stream, emitsInOrder(expected));
      },
    );
  });
}
