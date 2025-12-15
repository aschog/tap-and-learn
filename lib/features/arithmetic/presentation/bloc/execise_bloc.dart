import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:tap_and_learn/features/arithmetic/domain/entities/exercise.dart';
import 'package:tap_and_learn/features/arithmetic/domain/usecases/generate_exercise.dart';
import 'package:tap_and_learn/features/arithmetic/presentation/widgets/operand_selector/cubit/operand_config_cubit.dart';

part 'exercise_event.dart';
part 'exercise_state.dart';

class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  final GenerateExercise generateExercise;
  final OperandConfigCubit operandConfigCubit;
  late StreamSubscription _operandSubscription;
  String _userInput = '';
  bool _isShowingExercise = true;

  ExerciseBloc({
    required this.generateExercise,
    required this.operandConfigCubit,
  }) : super(const ExerciseState(
            displayOutput: '0', status: AnswerStatus.initial)) {
    on<ExerciseRequested>(_onExerciseRequested);
    on<ButtonPressed>(_onButtonPressed);
    on<BackspacePressed>(_onBackspacePressed);

    _operandSubscription = operandConfigCubit.stream.listen((state) {
      add(ExerciseRequested());
    });

    add(ExerciseRequested());
  }

  @override
  Future<void> close() {
    _operandSubscription.cancel();
    return super.close();
  }

  Future<void> _onExerciseRequested(
    ExerciseRequested event,
    Emitter<ExerciseState> emit,
  ) async {
    _userInput = '';
    _isShowingExercise = true;
    final failureOrExercise = await generateExercise(
        Params(operands1: operandConfigCubit.state.selectedOperands1));
    failureOrExercise.fold(
      (failure) => emit(
          state.copyWith(displayOutput: 'Error', status: AnswerStatus.error)),
      (exercise) {
        final display = '${exercise.operand1} × ${exercise.operand2}';
        emit(state.copyWith(
            exercise: exercise,
            displayOutput: display,
            status: AnswerStatus.initial));
      },
    );
  }

  Future<void> _onButtonPressed(
      ButtonPressed event, Emitter<ExerciseState> emit) async {
    final buttonText = event.buttonText;
    final exercise = state.exercise;

    // Do not accept number input if an answer is already being processed
    if (state.status == AnswerStatus.correct ||
        state.status == AnswerStatus.incorrect) {
      return;
    }

    if (int.tryParse(buttonText) != null) {
      final product = (exercise!.operand1 * exercise.operand2).toString();

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
          if (!isClosed) {
            add(ExerciseRequested());
          }
        } else {
          emit(state.copyWith(
              displayOutput: '${exercise.operand1} × ${exercise.operand2}',
              status: AnswerStatus.incorrect));
          await Future.delayed(const Duration(seconds: 1)); // Wait for 1 second
          _userInput = '';
          final display = '${exercise.operand1} × ${exercise.operand2}';
          _isShowingExercise = true;
          if (!isClosed) {
            emit(state.copyWith(
                displayOutput: display, status: AnswerStatus.initial));
          }
        }
      }
    } else if (buttonText == 'AC') {
      add(ExerciseRequested());
    }
  }

  void _onBackspacePressed(
      BackspacePressed event, Emitter<ExerciseState> emit) {
    if (state.status == AnswerStatus.correct ||
        state.status == AnswerStatus.incorrect) {
      return;
    }

    if (_userInput.isNotEmpty) {
      _userInput = _userInput.substring(0, _userInput.length - 1);
      if (_userInput.isEmpty) {
        _isShowingExercise = true;
        final display =
            '${state.exercise!.operand1} × ${state.exercise!.operand2}';
        emit(state.copyWith(
            displayOutput: display, status: AnswerStatus.initial));
      } else {
        emit(state.copyWith(
            displayOutput: _userInput, status: AnswerStatus.entering));
      }
    }
  }
}
