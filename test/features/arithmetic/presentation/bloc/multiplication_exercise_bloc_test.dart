import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tap_and_learn/features/arithmetic/domain/entities/multiplication_exercise.dart';
import 'package:tap_and_learn/features/arithmetic/domain/usecases/generate_multiplication_exercise.dart';
import 'package:tap_and_learn/features/arithmetic/presentation/bloc/multiplication_execise_bloc.dart';
import 'package:tap_and_learn/features/arithmetic/presentation/widgets/multiplicand_selector/cubit/multiplicand_config_cubit.dart';

import 'multiplication_exercise_bloc_test.mocks.dart';

@GenerateMocks([GenerateMultiplicationExercise, MultiplicandConfigCubit])
void main() {
  late MockGenerateMultiplicationExercise mockGenerateMultiplicationExercise;
  late MockMultiplicandConfigCubit mockMultiplicandConfigCubit;

  setUp(() {
    mockGenerateMultiplicationExercise = MockGenerateMultiplicationExercise();
    mockMultiplicandConfigCubit = MockMultiplicandConfigCubit();
    when(mockMultiplicandConfigCubit.state).thenReturn(
        const MultiplicandConfigState(selectedMultiplicands: [1, 2, 3]));
  });

  // product is technically not in the constructor of MultiplicationExercise in some versions,
  // but let's check the code if I can.
  // The error said "Required named parameter 'product' must be provided." so I added it.
  const tExercise =
      MultiplicationExercise(multiplicand: 7, multiplier: 8, product: 56);

  // Note: tInitialState is not really used in seed unless we explicitly start with it.
  const tExerciseLoadedState = MultiplicationExerciseState(
      exercise: tExercise,
      displayOutput: '7 × 8',
      status: AnswerStatus.initial);

  blocTest<MultiplicationExerciseBloc, MultiplicationExerciseState>(
    'emits [exercise, initial] when created',
    build: () {
      when(mockGenerateMultiplicationExercise(any))
          .thenAnswer((_) async => const Right(tExercise));
      return MultiplicationExerciseBloc(
        generateMultiplicationExercise: mockGenerateMultiplicationExercise,
        multiplicandConfigCubit: mockMultiplicandConfigCubit,
      );
    },
    expect: () => [tExerciseLoadedState],
  );

  group('ButtonPressed', () {
    blocTest<MultiplicationExerciseBloc, MultiplicationExerciseState>(
      'emits [entering, correct] and requests new exercise for correct answer',
      build: () {
        when(mockGenerateMultiplicationExercise(any))
            .thenAnswer((_) async => const Right(tExercise));
        return MultiplicationExerciseBloc(
          generateMultiplicationExercise: mockGenerateMultiplicationExercise,
          multiplicandConfigCubit: mockMultiplicandConfigCubit,
        );
      },
      seed: () => tExerciseLoadedState,
      act: (bloc) async {
        bloc.add(const ButtonPressed('5'));
        bloc.add(const ButtonPressed('6'));
        // Wait for the delay inside the bloc to complete
        await Future.delayed(const Duration(milliseconds: 1100));
      },
      expect: () => <MultiplicationExerciseState>[
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

    blocTest<MultiplicationExerciseBloc, MultiplicationExerciseState>(
      'emits [entering, incorrect] and resets for incorrect answer',
      build: () {
        when(mockGenerateMultiplicationExercise(any))
            .thenAnswer((_) async => const Right(tExercise));
        return MultiplicationExerciseBloc(
          generateMultiplicationExercise: mockGenerateMultiplicationExercise,
          multiplicandConfigCubit: mockMultiplicandConfigCubit,
        );
      },
      seed: () => tExerciseLoadedState,
      act: (bloc) async {
        bloc.add(const ButtonPressed('1'));
        bloc.add(const ButtonPressed('2'));
        // Wait for the delay inside the bloc to complete
        await Future.delayed(const Duration(milliseconds: 1100));
      },
      expect: () => <MultiplicationExerciseState>[
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

    blocTest<MultiplicationExerciseBloc, MultiplicationExerciseState>(
      'requests a new exercise when "AC" is pressed',
      build: () {
        when(mockGenerateMultiplicationExercise(any))
            .thenAnswer((_) async => const Right(tExercise));
        return MultiplicationExerciseBloc(
          generateMultiplicationExercise: mockGenerateMultiplicationExercise,
          multiplicandConfigCubit: mockMultiplicandConfigCubit,
        );
      },
      seed: () => tExerciseLoadedState.copyWith(displayOutput: '999'),
      act: (bloc) => bloc.add(const ButtonPressed('AC')),
      expect: () => <MultiplicationExerciseState>[
        tExerciseLoadedState,
      ],
      verify: (_) {
        verify(mockGenerateMultiplicationExercise(any)).called(2);
      },
    );

    blocTest<MultiplicationExerciseBloc, MultiplicationExerciseState>(
      'does not allow input beyond product length',
      build: () {
        when(mockGenerateMultiplicationExercise(any))
            .thenAnswer((_) async => const Right(tExercise)); // Product is 56 (length 2)
        return MultiplicationExerciseBloc(
          generateMultiplicationExercise: mockGenerateMultiplicationExercise,
          multiplicandConfigCubit: mockMultiplicandConfigCubit,
        );
      },
      act: (bloc) async {
        bloc.add(const ButtonPressed('5'));
        bloc.add(const ButtonPressed('6')); // This makes _userInput "56"
        bloc.add(const ButtonPressed('7')); // This input should be ignored
      },
      expect: () => <MultiplicationExerciseState>[
        tExerciseLoadedState,
        tExerciseLoadedState.copyWith(displayOutput: '5', status: AnswerStatus.entering),
        tExerciseLoadedState.copyWith(displayOutput: '56', status: AnswerStatus.entering),
        tExerciseLoadedState.copyWith(displayOutput: '56', status: AnswerStatus.correct),
        // No state change is expected after pressing '7' because it's beyond the product length (2)
      ],
      verify: (_) {
        verify(mockGenerateMultiplicationExercise(any)).called(1); // Called during bloc init
      }
    );
  });

  group('BackspacePressed', () {
    const tExerciseLarge =
        MultiplicationExercise(multiplicand: 10, multiplier: 10, product: 100);
    const tExerciseLargeLoadedState = MultiplicationExerciseState(
        exercise: tExerciseLarge,
        displayOutput: '10 × 10',
        status: AnswerStatus.initial);

    blocTest<MultiplicationExerciseBloc, MultiplicationExerciseState>(
      'removes last character from input',
      build: () {
        when(mockGenerateMultiplicationExercise(any))
            .thenAnswer((_) async => const Right(tExerciseLarge));
        return MultiplicationExerciseBloc(
          generateMultiplicationExercise: mockGenerateMultiplicationExercise,
          multiplicandConfigCubit: mockMultiplicandConfigCubit,
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

    blocTest<MultiplicationExerciseBloc, MultiplicationExerciseState>(
      'resets to question when input becomes empty',
      build: () {
        when(mockGenerateMultiplicationExercise(any))
            .thenAnswer((_) async => const Right(tExercise));
        return MultiplicationExerciseBloc(
          generateMultiplicationExercise: mockGenerateMultiplicationExercise,
          multiplicandConfigCubit: mockMultiplicandConfigCubit,
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
}
