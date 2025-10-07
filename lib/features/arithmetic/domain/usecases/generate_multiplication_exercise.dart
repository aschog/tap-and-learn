import 'package:dartz/dartz.dart';
import 'package:multiplication_trainer/core/error/faiures.dart';
import 'package:multiplication_trainer/core/usecases/usecase.dart';
import 'package:multiplication_trainer/features/arithmetic/domain/entities/multiplication_exercise.dart';
import 'package:multiplication_trainer/features/arithmetic/domain/repositories/arithmetic_repository.dart';

class GenerateMultiplicationExercise
    extends UseCase<MultiplicationExercise, NoParams> {
  final ArithmeticRepository repository;

  GenerateMultiplicationExercise(this.repository);
  @override
  Future<Either<Failure, MultiplicationExercise>> call(NoParams params) async {
    return await repository.generateMultiplicationExercise();
  }
}
