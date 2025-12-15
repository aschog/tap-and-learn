import 'package:tap_and_learn/core/error/faiures.dart';
import 'package:tap_and_learn/features/arithmetic/domain/entities/exercise.dart';
import 'package:dartz/dartz.dart';

abstract class ArithmeticRepository {
  Future<Either<Failure, Exercise>> generateExercise(List<int> operands1);
  Future<Either<Failure, List<int>>> getSelectedOperands1();
  Future<Either<Failure, void>> saveSelectedOperands1(List<int> operands1);
}
