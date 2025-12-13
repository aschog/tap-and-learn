import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tap_and_learn/features/arithmetic/domain/entities/multiplication_exercise.dart';
import 'package:tap_and_learn/features/arithmetic/domain/repositories/arithmetic_repository.dart';
import 'package:tap_and_learn/features/arithmetic/domain/usecases/generate_multiplication_exercise.dart';

import 'generate_multiplication_exercise_test.mocks.dart';

@GenerateMocks([ArithmeticRepository])
void main() {
  late GenerateMultiplicationExercise generateExercise;
  late MockArithmeticRepository mockPracticeRepository;

  setUp(() {
    mockPracticeRepository = MockArithmeticRepository();
    generateExercise = GenerateMultiplicationExercise(mockPracticeRepository);
  });

  const tMultiplicationExercise =
      MultiplicationExercise(multiplicand: 2, multiplier: 3, product: 6);
  final multiplicands = [2];
  test('should calculate correct answer', () async {
    when(
      mockPracticeRepository.generateMultiplicationExercise(any),
    ).thenAnswer((_) async => const Right(tMultiplicationExercise));
    final result = await generateExercise(Params(multiplicands: multiplicands));
    expect(result, const Right(tMultiplicationExercise));
    verify(mockPracticeRepository.generateMultiplicationExercise(any));
    verifyNoMoreInteractions(mockPracticeRepository);
  });
}
