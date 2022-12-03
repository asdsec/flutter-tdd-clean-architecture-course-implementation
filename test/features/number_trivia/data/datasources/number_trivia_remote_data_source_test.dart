import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_with_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_with_clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_with_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';
@GenerateNiceMocks([MockSpec<http.Client>()])
import 'number_trivia_remote_data_source_test.mocks.dart';

void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tUrl = Uri.parse('http://numbersapi.com/$tNumber');
    const tHeader = {'Content-Type': 'application/json'};
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
      json.decode(fixture('trivia.json')) as Map<String, dynamic>,
    );

    test(
      'should perform a GET request on a URL with number being the endpoint and with application/json header',
      () async {
        // arrange
        when(mockHttpClient.get(tUrl, headers: tHeader)).thenAnswer(
          (_) async => http.Response(fixture('trivia.json'), 200),
        );
        // act
        await dataSource.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockHttpClient.get(tUrl, headers: tHeader));
      },
    );

    test(
      'should return NumberTrivia when the response code is (success)',
      () async {
        // arrange
        when(mockHttpClient.get(tUrl, headers: tHeader)).thenAnswer(
          (_) async => http.Response(fixture('trivia.json'), 200),
        );
        // act
        final result = await dataSource.getConcreteNumberTrivia(tNumber);
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(mockHttpClient.get(tUrl, headers: tHeader)).thenAnswer(
          (_) async => http.Response('Something went wrong!', 404),
        );
        // act
        final call = dataSource.getConcreteNumberTrivia;
        // assert
        expect(() => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });

  group('getRandomNumberTrivia', () {
    final tUrl = Uri.parse('http://numbersapi.com/random');
    const tHeader = {'Content-Type': 'application/json'};
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
      json.decode(fixture('trivia.json')) as Map<String, dynamic>,
    );

    test(
      'should perform a GET request on a URL with number being the endpoint and with application/json header',
      () async {
        // arrange
        when(mockHttpClient.get(tUrl, headers: tHeader)).thenAnswer(
          (_) async => http.Response(fixture('trivia.json'), 200),
        );
        // act
        await dataSource.getRandomNumberTrivia();
        // assert
        verify(mockHttpClient.get(tUrl, headers: tHeader));
      },
    );

    test(
      'should return NumberTrivia when the response code is (success)',
      () async {
        // arrange
        when(mockHttpClient.get(tUrl, headers: tHeader)).thenAnswer(
          (_) async => http.Response(fixture('trivia.json'), 200),
        );
        // act
        final result = await dataSource.getRandomNumberTrivia();
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(mockHttpClient.get(tUrl, headers: tHeader)).thenAnswer(
          (_) async => http.Response('Something went wrong!', 404),
        );
        // act
        final call = dataSource.getRandomNumberTrivia;
        // assert
        expect(call, throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });
}
