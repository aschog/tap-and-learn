import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tap_and_learn/core/error/faiures.dart';
import 'package:tap_and_learn/core/usecases/usecase.dart';
import 'package:tap_and_learn/features/arithmetic/domain/repositories/arithmetic_repository.dart';

class SaveSelectedOperands1 implements UseCase<void, Params> {
  final ArithmeticRepository repository;

  SaveSelectedOperands1(this.repository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await repository.saveSelectedOperands1(params.operands1);
  }
}

class Params extends Equatable {
  final List<int> operands1;

  const Params({required this.operands1});

  @override
  List<Object?> get props => [operands1];
}
