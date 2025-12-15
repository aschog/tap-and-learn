import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tap_and_learn/features/arithmetic/domain/entities/exercise.dart';
import 'package:tap_and_learn/features/arithmetic/domain/logic/arithmetic_strategy.dart';
import 'package:tap_and_learn/features/arithmetic/domain/usecases/generate_exercise.dart';
import 'package:tap_and_learn/features/arithmetic/presentation/bloc/exercise_bloc.dart';
import 'package:tap_and_learn/features/arithmetic/presentation/widgets/operand_selector/cubit/operand_config_cubit.dart';

import 'exercise_bloc_test.mocks.dart';

@GenerateMocks([GenerateExercise, OperandConfigCubit, ArithmeticStrategy])
void main() {
  late MockGenerateExercise mockGenerateMultiplicationExercise;
  late MockOperandConfigCubit mockOperandConfigCubit;
  late MockArithmeticStrategy mockStrategy;
  late StreamController<OperandConfigState> operandConfigStreamController;

  setUp(() {
    mockGenerateMultiplicationExercise = MockGenerateExercise();
    mockOperandConfigCubit = MockOperandConfigCubit();
    mockStrategy = MockArithmeticStrategy();
    operandConfigStreamController = StreamController<OperandConfigState>();

    when(mockOperandConfigCubit.state)
        .thenReturn(const OperandConfigState(selectedOperands1: [1, 2, 3]));
    when(mockOperandConfigCubit.stream)
        .thenAnswer((_) => operandConfigStreamController.stream);
    when(mockStrategy.symbol).thenReturn('×');
  });

  tearDown(() {
    operandConfigStreamController.close();
  });

  // product is technically not in the constructor of MultiplicationExercise in some versions,
  // but let's check the code if I can.
  // The error said "Required named parameter 'product' must be provided." so I added it.
  const tExercise = Exercise(operand1: 7, operand2: 8, result: 56);

  // Note: tInitialState is not really used in seed unless we explicitly start with it.
  const tExerciseLoadedState = ExerciseState(
      exercise: tExercise,
      displayOutput: '7 × 8',
      status: AnswerStatus.initial);

  blocTest<ExerciseBloc, ExerciseState>(
    'emits [exercise, initial] when created',
    build: () {
      when(mockGenerateMultiplicationExercise(any))
          .thenAnswer((_) async => const Right(tExercise));
      return ExerciseBloc(
        generateExercise: mockGenerateMultiplicationExercise,
        operandConfigCubit: mockOperandConfigCubit,
        strategy: mockStrategy,
      );
    },
    expect: () => [tExerciseLoadedState],
  );

  group('ButtonPressed', () {
    blocTest<ExerciseBloc, ExerciseState>(
      'emits [entering, correct] and requests new exercise for correct answer',
      build: () {
        when(mockGenerateMultiplicationExercise(any))
            .thenAnswer((_) async => const Right(tExercise));
        return ExerciseBloc(
          generateExercise: mockGenerateMultiplicationExercise,
          operandConfigCubit: mockOperandConfigCubit,
          strategy: mockStrategy,
        );
      },
      seed: () => tExerciseLoadedState,
      act: (bloc) async {
        bloc.add(const ButtonPressed('5'));
        bloc.add(const ButtonPressed('6'));
        // Wait for the delay inside the bloc to complete
        await Future.delayed(const Duration(milliseconds: 1100));
      },
      expect: () => <ExerciseState>[
        tExerciseLoadedState.copyWith(
            displayOutput: '5', status: AnswerStatus.entering),
        tExerciseLoadedState.copyWith(
            displayOutput: '56', status: AnswerStatus.entering),
        tExerciseLoadedState.copyWith(
            displayOutput: '56', status: AnswerStatus.correct),
        // This is the state after the new exercise is requested
        tExerciseLoadedState.copyWith(
            displayOutput: '7 × 8', status: AnswerStatus.initial),
      ],
      verify: (_) {
        // The use case should be called twice: once for the initial load,
        // and once after the correct answer.
        verify(mockGenerateMultiplicationExercise(any)).called(2);
      },
    );

    blocTest<ExerciseBloc, ExerciseState>(
      'emits [entering, incorrect] and resets for incorrect answer',
      build: () {
        when(mockGenerateMultiplicationExercise(any))
            .thenAnswer((_) async => const Right(tExercise));
        return ExerciseBloc(
          generateExercise: mockGenerateMultiplicationExercise,
          operandConfigCubit: mockOperandConfigCubit,
          strategy: mockStrategy,
        );
      },
      seed: () => tExerciseLoadedState,
      act: (bloc) async {
        bloc.add(const ButtonPressed('1'));
        bloc.add(const ButtonPressed('2'));
        // Wait for the delay inside the bloc to complete
        await Future.delayed(const Duration(milliseconds: 1100));
      },
      expect: () => <ExerciseState>[
        tExerciseLoadedState.copyWith(
            displayOutput: '1', status: AnswerStatus.entering),
        tExerciseLoadedState.copyWith(
            displayOutput: '12', status: AnswerStatus.entering),
        // The bloc updates display output to equation on error
        tExerciseLoadedState.copyWith(
            displayOutput: '7 × 8', status: AnswerStatus.incorrect),
        // This is the state after resetting to the original exercise
        tExerciseLoadedState.copyWith(
            displayOutput: '7 × 8', status: AnswerStatus.initial),
      ],
    );

    blocTest<ExerciseBloc, ExerciseState>(
      'requests a new exercise when "AC" is pressed',
      build: () {
        when(mockGenerateMultiplicationExercise(any))
            .thenAnswer((_) async => const Right(tExercise));
        return ExerciseBloc(
          generateExercise: mockGenerateMultiplicationExercise,
          operandConfigCubit: mockOperandConfigCubit,
          strategy: mockStrategy,
        );
      },
      seed: () => tExerciseLoadedState.copyWith(displayOutput: '999'),
      act: (bloc) => bloc.add(const ButtonPressed('AC')),
      expect: () => <ExerciseState>[
        tExerciseLoadedState,
      ],
      verify: (_) {
        verify(mockGenerateMultiplicationExercise(any)).called(2);
      },
    );

    blocTest<ExerciseBloc, ExerciseState>(
        'does not allow input beyond product length',
        build: () {
          when(mockGenerateMultiplicationExercise(any)).thenAnswer(
              (_) async => const Right(tExercise)); // Product is 56 (length 2)
          return ExerciseBloc(
            generateExercise: mockGenerateMultiplicationExercise,
            operandConfigCubit: mockOperandConfigCubit,
            strategy: mockStrategy,
          );
        },
        act: (bloc) async {
          bloc.add(const ButtonPressed('5'));
          bloc.add(const ButtonPressed('6')); // This makes _userInput "56"
          bloc.add(const ButtonPressed('7')); // This input should be ignored
        },
        expect: () => <ExerciseState>[
              tExerciseLoadedState,
              tExerciseLoadedState.copyWith(
                  displayOutput: '5', status: AnswerStatus.entering),
              tExerciseLoadedState.copyWith(
                  displayOutput: '56', status: AnswerStatus.entering),
              tExerciseLoadedState.copyWith(
                  displayOutput: '56', status: AnswerStatus.correct),
              // No state change is expected after pressing '7' because it's beyond the product length (2)
            ],
        verify: (_) {
          verify(mockGenerateMultiplicationExercise(any))
              .called(1); // Called during bloc init
        });
  });

  group('BackspacePressed', () {
    const tExerciseLarge = Exercise(operand1: 10, operand2: 10, result: 100);
    const tExerciseLargeLoadedState = ExerciseState(
        exercise: tExerciseLarge,
        displayOutput: '10 × 10',
        status: AnswerStatus.initial);

    blocTest<ExerciseBloc, ExerciseState>(
      'removes last character from input',
      build: () {
        when(mockGenerateMultiplicationExercise(any))
            .thenAnswer((_) async => const Right(tExerciseLarge));
        return ExerciseBloc(
          generateExercise: mockGenerateMultiplicationExercise,
          operandConfigCubit: mockOperandConfigCubit,
          strategy: mockStrategy,
        );
      },
      act: (bloc) async {
        bloc.add(const ButtonPressed('1'));
        bloc.add(const ButtonPressed('0'));
        bloc.add(BackspacePressed());
      },
      expect: () => [
        tExerciseLargeLoadedState,
        tExerciseLargeLoadedState.copyWith(
            displayOutput: '1', status: AnswerStatus.entering),
        tExerciseLargeLoadedState.copyWith(
            displayOutput: '10', status: AnswerStatus.entering),
        tExerciseLargeLoadedState.copyWith(
            displayOutput: '1', status: AnswerStatus.entering),
      ],
    );

    blocTest<ExerciseBloc, ExerciseState>(
      'resets to question when input becomes empty',
      build: () {
        when(mockGenerateMultiplicationExercise(any))
            .thenAnswer((_) async => const Right(tExercise));
        return ExerciseBloc(
          generateExercise: mockGenerateMultiplicationExercise,
          operandConfigCubit: mockOperandConfigCubit,
          strategy: mockStrategy,
        );
      },
      act: (bloc) async {
        bloc.add(const ButtonPressed('5'));
        bloc.add(BackspacePressed());
      },
      expect: () => [
        tExerciseLoadedState,
        tExerciseLoadedState.copyWith(
            displayOutput: '5', status: AnswerStatus.entering),
        tExerciseLoadedState.copyWith(
            displayOutput: '7 × 8', status: AnswerStatus.initial),
      ],
    );
  });

  group('OperandConfigChanged', () {
    blocTest<ExerciseBloc, ExerciseState>(
      'requests new exercise when configuration changes',
      build: () {
        var callCount = 0;
        when(mockGenerateMultiplicationExercise(any)).thenAnswer((_) async {
          callCount++;
          if (callCount == 1) {
            return const Right(tExercise);
          }
          return const Right(Exercise(operand1: 2, operand2: 3, result: 6));
        });
        return ExerciseBloc(
          generateExercise: mockGenerateMultiplicationExercise,
          operandConfigCubit: mockOperandConfigCubit,
          strategy: mockStrategy,
        );
      },
      act: (bloc) {
        operandConfigStreamController
            .add(const OperandConfigState(selectedOperands1: [1, 2]));
      },
      expect: () => [
        tExerciseLoadedState, // Initial load
        tExerciseLoadedState.copyWith(
            exercise: const Exercise(operand1: 2, operand2: 3, result: 6),
            displayOutput: '2 × 3',
            status: AnswerStatus.initial), // Reload after config change
      ],
      verify: (_) {
        verify(mockGenerateMultiplicationExercise(any)).called(2);
      },
    );
  });
}
