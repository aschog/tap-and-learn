import 'package:flutter_test/flutter_test.dart';
import 'package:multiplication_trainer/features/arithmetic/data/models/multiplication_exercise_model.dart';
import 'package:multiplication_trainer/features/arithmetic/domain/entities/multiplication_exercise.dart';

void main() {
  final tMultiplicationExerciseModel = MultiplicationExerciseModel(
    multiplicand: 2,
    multiplier: 3,
  );

  test('should be a subclass of MultiplicationExercise entity', () async {
    expect(tMultiplicationExerciseModel, isA<MultiplicationExercise>());
  });
}
