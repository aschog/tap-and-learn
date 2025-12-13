import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tap_and_learn/core/error/faiures.dart';
import 'package:tap_and_learn/core/usecases/usecase.dart';
import 'package:tap_and_learn/features/arithmetic/domain/entities/multiplication_exercise.dart';
import 'package:tap_and_learn/features/arithmetic/domain/repositories/arithmetic_repository.dart';

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
