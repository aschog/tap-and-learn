import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tap_and_learn/features/arithmetic/data/models/exercise_model.dart';

abstract class ArithmeticLocalDataSource {
  final Random random;

  ArithmeticLocalDataSource({required this.random});
  Future<ExerciseModel> generateExercise(List<int> operands1);
  Future<List<int>> getSelectedOperands1();
  Future<void> saveSelectedOperands1(List<int> operands1);
}

const cachedOperandsKey = 'CACHED_OPERANDS';

class ArithmeticLocalDataSourceImpl implements ArithmeticLocalDataSource {
  @override
  final Random random;
  final SharedPreferences sharedPreferences;

  ArithmeticLocalDataSourceImpl({
    required this.random,
    required this.sharedPreferences,
  });
  final int _maxOperand2 = 10;
  @override
  Future<ExerciseModel> generateExercise(List<int> operands1) async {
    final operand1 = operands1.length == 1
        ? operands1[0]
        : operands1[random.nextInt(operands1.length)];
    final operands2 = random.nextInt(_maxOperand2);
    final result = operand1 * operands2;

    return ExerciseModel(
        operand1: operand1, operand2: operands2, result: result);
  }

  @override
  Future<List<int>> getSelectedOperands1() {
    final jsonString = sharedPreferences.getStringList(cachedOperandsKey);
    if (jsonString != null) {
      return Future.value(jsonString.map((e) => int.parse(e)).toList());
    } else {
      return Future.value([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
    }
  }

  @override
  Future<void> saveSelectedOperands1(List<int> operands1) {
    final List<String> stringList = operands1.map((e) => e.toString()).toList();
    return sharedPreferences.setStringList(cachedOperandsKey, stringList);
  }
}
