import 'package:dartz/dartz.dart';
import 'package:multiplication_trainer/core/error/faiures.dart';
import 'package:multiplication_trainer/features/arithmetic/data/datasources/arithmetic_local_data_source.dart';
import 'package:multiplication_trainer/features/arithmetic/domain/entities/multiplication_exercise.dart';
import 'package:multiplication_trainer/features/arithmetic/domain/repositories/arithmetic_repository.dart';

class ArithmeticRepositoryImpl implements ArithmeticRepository {
  final ArithmeticLocalDataSource localDataSource;

  ArithmeticRepositoryImpl({required this.localDataSource});
  @override
  Future<Either<Failure, MultiplicationExercise>>
  generateMultiplicationExercise() async {
    final exerciseModel = await localDataSource
        .generateMultiplicationExercise();
    return Right(exerciseModel);
  }
}
