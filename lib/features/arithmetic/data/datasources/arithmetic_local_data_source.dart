import 'package:multiplication_trainer/features/arithmetic/data/models/multiplication_exercise_model.dart';

abstract class ArithmeticLocalDataSource {
  /// Throws a [GeneralException] for all error codes.
  Future<MultiplicationExerciseModel> generateMultiplicationExercise();
}
