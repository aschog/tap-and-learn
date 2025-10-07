import 'package:multiply_fast/features/generateQuestion/data/models/question_model.dart';

abstract class QuestionDataSource {
  /// Throws a [GeneralException] for all error codes.
  Future<QuestionModel> generateQuestion();
}
