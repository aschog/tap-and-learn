import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:tap_and_learn/features/arithmetic/domain/entities/multiplication_exercise.dart';
import 'package:tap_and_learn/features/arithmetic/domain/usecases/generate_multiplication_exercise.dart';
import 'package:tap_and_learn/features/arithmetic/presentation/widgets/multiplicand_selector/cubit/multiplicand_config_cubit.dart';

part 'multiplication_exercise_event.dart';
part 'multiplication_exercise_state.dart';

class MultiplicationExerciseBloc
    extends Bloc<MultiplicationExerciseEvent, MultiplicationExerciseState> {
  final GenerateMultiplicationExercise generateMultiplicationExercise;
  final MultiplicandConfigCubit multiplicandConfigCubit;
  String _userInput = '';
  bool _isShowingExercise = true;

  MultiplicationExerciseBloc({
    required this.generateMultiplicationExercise,
    required this.multiplicandConfigCubit,
  }) : super(const MultiplicationExerciseState(
            displayOutput: '0', status: AnswerStatus.initial)) {
    on<ExerciseRequested>(_onExerciseRequested);
    on<ButtonPressed>(_onButtonPressed);
    on<BackspacePressed>(_onBackspacePressed);

    add(ExerciseRequested());
  }

  Future<void> _onExerciseRequested(
    ExerciseRequested event,
    Emitter<MultiplicationExerciseState> emit,
  ) async {
    _userInput = '';
    _isShowingExercise = true;
    final failureOrExercise = await generateMultiplicationExercise(Params(
        multiplicands: multiplicandConfigCubit.state.selectedMultiplicands));
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

    // Do not accept number input if an answer is already being processed
    if (state.status == AnswerStatus.correct ||
        state.status == AnswerStatus.incorrect) {
      return;
    }

    if (int.tryParse(buttonText) != null) {
      final product = (exercise!.multiplicand * exercise.multiplier).toString();

      // Prevent typing more digits than the product length
      if (_userInput.length >= product.length) {
        return;
      }

      if (_isShowingExercise) {
        _userInput = '';
        _isShowingExercise = false;
      }
      _userInput += buttonText;
      emit(state.copyWith(
          displayOutput: _userInput, status: AnswerStatus.entering));

      if (_userInput.length == product.length) {
        if (_userInput == product) {
          emit(state.copyWith(
              displayOutput: product, status: AnswerStatus.correct));
          await Future.delayed(const Duration(seconds: 1)); // Wait for 1 second
          add(ExerciseRequested());
        } else {
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
      add(ExerciseRequested());
    }
  }

  void _onBackspacePressed(
      BackspacePressed event, Emitter<MultiplicationExerciseState> emit) {
    if (state.status == AnswerStatus.correct ||
        state.status == AnswerStatus.incorrect) {
      return;
    }

    if (_userInput.isNotEmpty) {
      _userInput = _userInput.substring(0, _userInput.length - 1);
      if (_userInput.isEmpty) {
        _isShowingExercise = true;
        final display =
            '${state.exercise!.multiplicand} × ${state.exercise!.multiplier}';
        emit(state.copyWith(
            displayOutput: display, status: AnswerStatus.initial));
      } else {
        emit(state.copyWith(
            displayOutput: _userInput, status: AnswerStatus.entering));
      }
    }
  }
}
