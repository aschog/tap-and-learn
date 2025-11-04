import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:multiplication_trainer/features/arithmetic/domain/entities/multiplication_exercise.dart';
import 'package:multiplication_trainer/features/arithmetic/domain/usecases/generate_multiplication_exercise.dart';

part 'multiplication_exercise_event.dart';
part 'multiplication_exercise_state.dart';

class MultiplicationExerciseBloc
    extends Bloc<MultiplicationExerciseEvent, MultiplicationExerciseState> {
  final GenerateMultiplicationExercise generateMultiplicationExercise;
  String _userInput = '';
  bool _isShowingExercise = true;

  MultiplicationExerciseBloc({
    required this.generateMultiplicationExercise,
  }) : super(const MultiplicationExerciseState(
            displayOutput: '0', status: AnswerStatus.initial)) {
    on<ExerciseRequested>(_onExerciseRequested);
    on<ButtonPressed>(_onButtonPressed);

    add(ExerciseRequested());
  }

  Future<void> _onExerciseRequested(
    ExerciseRequested event,
    Emitter<MultiplicationExerciseState> emit,
  ) async {
    _userInput = '';
    _isShowingExercise = true;
    final failureOrExercise = await generateMultiplicationExercise(
        const Params(multiplicands: [5, 6, 7, 8, 9]));
    failureOrExercise.fold(
      (failure) => emit(
          state.copyWith(displayOutput: 'Error', status: AnswerStatus.error)),
      (exercise) {
        final display = '${exercise.multiplicand} × ${exercise.multiplier}';
        emit(state.copyWith(
            exercise: exercise,
            displayOutput: display,
            status: AnswerStatus.initial));
      },
    );
  }

  Future<void> _onButtonPressed(
      ButtonPressed event, Emitter<MultiplicationExerciseState> emit) async {
    final buttonText = event.buttonText;
    final exercise = state.exercise;

    if (int.tryParse(buttonText) != null) {
      // Handle number presses
      if (_isShowingExercise) {
        _userInput = '';
        _isShowingExercise = false;
      }
      _userInput += buttonText;
      emit(state.copyWith(
          displayOutput: _userInput, status: AnswerStatus.entering));

      final product = (exercise!.multiplicand * exercise.multiplier).toString();

      if (_userInput.length == product.length) {
        if (_userInput == product) {
          // Correct answer
          emit(state.copyWith(
              displayOutput: product, status: AnswerStatus.correct));
          await Future.delayed(const Duration(seconds: 1)); // Wait for 1 second
          add(ExerciseRequested());
        } else {
          // Incorrect answer
          emit(state.copyWith(
              displayOutput:
                  '${exercise.multiplicand} × ${exercise.multiplier}',
              status: AnswerStatus.incorrect));
          await Future.delayed(const Duration(seconds: 1)); // Wait for 1 second
          _userInput = '';
          final display = '${exercise.multiplicand} × ${exercise.multiplier}';
          _isShowingExercise = true;
          emit(state.copyWith(
              displayOutput: display, status: AnswerStatus.initial));
        }
      }
    } else if (buttonText == 'AC') {
      // Handle 'AC' (All Clear) button, which requests a new exercise
      add(ExerciseRequested());
    }
    // Other buttons like '+', '-', etc. are ignored for now.
  }
}
