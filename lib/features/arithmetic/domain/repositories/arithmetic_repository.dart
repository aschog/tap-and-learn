import 'package:multiplication_trainer/core/error/faiures.dart';
import 'package:multiplication_trainer/features/arithmetic/domain/entities/multiplication_exercise.dart';
import 'package:dartz/dartz.dart';

abstract class ArithmeticRepository {
  Future<Either<Failure, MultiplicationExercise>>
      generateMultiplicationExercise(List<int> multiplicands);
}
