import 'package:flutter_test/flutter_test.dart';
import 'package:tap_and_learn/features/arithmetic/data/models/exercise_model.dart';
import 'package:tap_and_learn/features/arithmetic/domain/entities/exercise.dart';

void main() {
  const tMultiplicationExerciseModel =
      ExerciseModel(operand1: 2, operand2: 3, result: 6);

  test('should be a subclass of MultiplicationExercise entity', () async {
    expect(tMultiplicationExerciseModel, isA<Exercise>());
  });
}
