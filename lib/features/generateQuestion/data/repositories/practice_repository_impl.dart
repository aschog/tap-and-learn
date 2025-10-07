import 'package:dartz/dartz.dart';
import 'package:multiply_fast/core/error/faiures.dart';
import 'package:multiply_fast/features/generateQuestion/domain/entities/question.dart';
import 'package:multiply_fast/features/generateQuestion/domain/repositories/practice_repository.dart';

class PracticeRepositoryImpl implements PracticeRepository {
  @override
  Future<Either<Failure, Question>> getQuestion() {
    // TODO: implement getQuestion
    throw UnimplementedError();
  }
}
