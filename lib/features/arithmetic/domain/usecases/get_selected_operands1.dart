import 'package:dartz/dartz.dart';
import 'package:tap_and_learn/core/error/faiures.dart';
import 'package:tap_and_learn/core/usecases/usecase.dart';
import 'package:tap_and_learn/features/arithmetic/domain/repositories/arithmetic_repository.dart';

class GetSelectedOperands1 implements UseCase<List<int>, NoParams> {
  final ArithmeticRepository repository;

  GetSelectedOperands1(this.repository);

  @override
  Future<Either<Failure, List<int>>> call(NoParams params) async {
    return await repository.getSelectedOperands1();
  }
}
