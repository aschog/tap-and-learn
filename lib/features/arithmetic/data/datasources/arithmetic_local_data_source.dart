import 'dart:math';

import 'package:tap_and_learn/features/arithmetic/data/models/multiplication_exercise_model.dart';

abstract class ArithmeticLocalDataSource {
  final Random random;

  ArithmeticLocalDataSource({required this.random});
  Future<MultiplicationExerciseModel> generateMultiplicationExercise(
      List<int> multiplicands);
}

class ArithmeticLocalDataSourceImpl implements ArithmeticLocalDataSource {
  @override
  final Random random;

  ArithmeticLocalDataSourceImpl({required this.random});
  final int _maxMultiplier = 10;
  @override
  Future<MultiplicationExerciseModel> generateMultiplicationExercise(
      List<int> multiplicands) async {
    final multiplicand = multiplicands.length == 1
        ? multiplicands[0]
        : multiplicands[random.nextInt(multiplicands.length)];
    final multiplier = random.nextInt(_maxMultiplier);
    final product = multiplicand * multiplier;

    return MultiplicationExerciseModel(
        multiplicand: multiplicand, multiplier: multiplier, product: product);
  }
}
