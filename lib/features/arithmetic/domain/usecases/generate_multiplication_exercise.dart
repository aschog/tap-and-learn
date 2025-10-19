import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:multiplication_trainer/core/error/faiures.dart';
import 'package:multiplication_trainer/core/usecases/usecase.dart';
import 'package:multiplication_trainer/features/arithmetic/domain/entities/multiplication_exercise.dart';
import 'package:multiplication_trainer/features/arithmetic/domain/repositories/arithmetic_repository.dart';

class GenerateMultiplicationExercise
    extends UseCase<MultiplicationExercise, Params> {
  final ArithmeticRepository repository;

  GenerateMultiplicationExercise(this.repository);
  @override
  Future<Either<Failure, MultiplicationExercise>> call(Params params) async {
    return await repository
        .generateMultiplicationExercise(params.multiplicands);
  }
}

class Params extends Equatable {
  final List<int> multiplicands;

  const Params({required this.multiplicands});

  @override
  List<Object?> get props => [multiplicands];
}
