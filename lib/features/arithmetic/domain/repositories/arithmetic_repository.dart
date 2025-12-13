import 'package:tap_and_learn/core/error/faiures.dart';
import 'package:tap_and_learn/features/arithmetic/domain/entities/multiplication_exercise.dart';
import 'package:dartz/dartz.dart';

abstract class ArithmeticRepository {
  Future<Either<Failure, MultiplicationExercise>>
      generateMultiplicationExercise(List<int> multiplicands);
}
