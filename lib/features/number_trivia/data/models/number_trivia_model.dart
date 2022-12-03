import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_with_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';

@immutable
class NumberTriviaModel extends NumberTrivia {
  const NumberTriviaModel({
    String? text,
    int? number,
  }) : super(
          text: text ?? '',
          number: number ?? 0,
        );

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(
      text: json['text'] as String?,
      number: (json['number'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'number': number,
    };
  }
}
