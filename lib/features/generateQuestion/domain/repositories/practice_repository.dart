import 'package:multiply_fast/core/error/faiures.dart';
import 'package:multiply_fast/features/generateQuestion/domain/entities/question.dart';
import 'package:dartz/dartz.dart';

abstract class PracticeRepository {
  Future<Either<Failure, Question>> getQuestion();
}
