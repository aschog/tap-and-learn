import 'package:dartz/dartz.dart';
import 'package:multiplication_trainer/core/error/faiures.dart';
// Removed incorrect import
import 'package:multiplication_trainer/features/arithmetic/domain/entities/multiplication_exercise.dart';
import 'package:multiplication_trainer/features/arithmetic/domain/repositories/arithmetic_repository.dart';

class ArithmeticRepositoryImpl implements ArithmeticRepository {
  @override
  Future<Either<Failure, MultiplicationExercise>>
  generateMultiplicationExercise() {
    // TODO: implement getQuestion
    throw UnimplementedError();
  }
}
