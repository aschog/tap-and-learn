import 'package:flutter_test/flutter_test.dart';
import 'package:multiply_fast/features/generateQustion/data/models/question_model.dart';
import 'package:multiply_fast/features/generateQustion/domain/entities/question.dart';

void main() {
  final tQuestionModel = QuestionModel(factor1: 2, factor2: 3, answer: 6);

  test('should be a subclass of Question entity', () async {
    expect(tQuestionModel, isA<Question>());
  });
}
