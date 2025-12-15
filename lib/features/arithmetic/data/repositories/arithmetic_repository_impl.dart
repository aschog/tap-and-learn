import 'package:dartz/dartz.dart';
import 'package:tap_and_learn/core/error/faiures.dart';
import 'package:tap_and_learn/features/arithmetic/data/datasources/arithmetic_local_data_source.dart';
import 'package:tap_and_learn/features/arithmetic/domain/entities/exercise.dart';
import 'package:tap_and_learn/features/arithmetic/domain/repositories/arithmetic_repository.dart';

class ArithmeticRepositoryImpl implements ArithmeticRepository {
  final ArithmeticLocalDataSource localDataSource;

  ArithmeticRepositoryImpl({required this.localDataSource});
  @override
  Future<Either<Failure, Exercise>> generateExercise(
      List<int> operands1) async {
    final exerciseModel = await localDataSource.generateExercise(operands1);
    return Right(exerciseModel);
  }

  @override
  Future<Either<Failure, List<int>>> getSelectedOperands1() async {
    try {
      final result = await localDataSource.getSelectedOperands1();
      return Right(result);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveSelectedOperands1(
      List<int> operands1) async {
    try {
      await localDataSource.saveSelectedOperands1(operands1);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
