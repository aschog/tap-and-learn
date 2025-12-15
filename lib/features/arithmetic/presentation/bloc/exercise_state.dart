part of 'exercise_bloc.dart';

enum AnswerStatus { initial, entering, correct, incorrect, error }

class ExerciseState extends Equatable {
  final Exercise? exercise;
  final String displayOutput;
  final AnswerStatus status;

  @override
  List<Object?> get props => [exercise, displayOutput, status];

  const ExerciseState({
    this.exercise,
    required this.displayOutput,
    this.status = AnswerStatus.initial,
  });

  ExerciseState copyWith({
    Exercise? exercise,
    String? displayOutput,
    AnswerStatus? status,
  }) {
    return ExerciseState(
      exercise: exercise ?? this.exercise,
      displayOutput: displayOutput ?? this.displayOutput,
      status: status ?? this.status,
    );
  }
}
