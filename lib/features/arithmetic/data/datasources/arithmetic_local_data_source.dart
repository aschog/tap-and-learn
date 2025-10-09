import 'dart:math';

import 'package:multiplication_trainer/features/arithmetic/data/models/multiplication_exercise_model.dart';

abstract class ArithmeticLocalDataSource {
  final Random random;

  ArithmeticLocalDataSource({required this.random});
  Future<MultiplicationExerciseModel> generateMultiplicationExercise();
}

class ArithmeticLocalDataSourceIml implements ArithmeticLocalDataSource {
  @override
  final Random random;

  ArithmeticLocalDataSourceIml({required this.random});
  final int _max = 10;
  @override
  Future<MultiplicationExerciseModel> generateMultiplicationExercise() async {
    final multiplicand = random.nextInt(_max);
    final multiplier = random.nextInt(_max);

    return MultiplicationExerciseModel(
      multiplicand: multiplicand,
      multiplier: multiplier,
    );
  }
}
