import 'package:dartz/dartz.dart';
import 'package:multiply_fast/core/error/faiures.dart';
import 'package:multiply_fast/core/usecases/usecase.dart';
import 'package:multiply_fast/features/generateQuestion/domain/entities/question.dart';
import 'package:multiply_fast/features/generateQuestion/domain/repositories/practice_repository.dart';

class GenerateQuestion extends UseCase<Question, NoParams> {
  final PracticeRepository repository;

  GenerateQuestion(this.repository);
  @override
  Future<Either<Failure, Question>> call(NoParams params) async {
    return await repository.getQuestion();
  }
}
