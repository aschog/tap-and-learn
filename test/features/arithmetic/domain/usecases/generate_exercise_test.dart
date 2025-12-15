import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tap_and_learn/features/arithmetic/domain/entities/exercise.dart';
import 'package:tap_and_learn/features/arithmetic/domain/repositories/arithmetic_repository.dart';
import 'package:tap_and_learn/features/arithmetic/domain/usecases/generate_exercise.dart';

import 'generate_exercise_test.mocks.dart';

@GenerateMocks([ArithmeticRepository])
void main() {
  late GenerateExercise generateExercise;
  late MockArithmeticRepository mockPracticeRepository;

  setUp(() {
    mockPracticeRepository = MockArithmeticRepository();
    generateExercise = GenerateExercise(mockPracticeRepository);
  });

  const tExercise = Exercise(operand1: 2, operand2: 3, result: 6);
  final operands = [2];
  test('should calculate correct answer', () async {
    when(
      mockPracticeRepository.generateExercise(any),
    ).thenAnswer((_) async => const Right(tExercise));
    final result = await generateExercise(Params(operands1: operands));
    expect(result, const Right(tExercise));
    verify(mockPracticeRepository.generateExercise(any));
    verifyNoMoreInteractions(mockPracticeRepository);
  });
}
