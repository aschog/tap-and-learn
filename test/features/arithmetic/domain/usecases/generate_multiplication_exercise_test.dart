import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:multiplication_trainer/core/usecases/usecase.dart';
import 'package:multiplication_trainer/features/arithmetic/domain/entities/multiplication_exercise.dart';
import 'package:multiplication_trainer/features/arithmetic/domain/repositories/arithmetic_repository.dart';
import 'package:multiplication_trainer/features/arithmetic/domain/usecases/generate_multiplication_exercise.dart';
import 'generate_multiplication_exercise_test.mocks.dart';

@GenerateMocks([ArithmeticRepository])
void main() {
  late GenerateMultiplicationExercise usecase;
  late MockArithmeticRepository mockPracticeRepository;

  setUp(() {
    mockPracticeRepository = MockArithmeticRepository();
    usecase = GenerateMultiplicationExercise(mockPracticeRepository);
  });

  final tMultiplicationExercise = MultiplicationExercise(
    multiplicand: 2,
    multiplier: 3,
  );

  test('should calculate correct answer', () async {
    when(
      mockPracticeRepository.generateMultiplicationExercise(),
    ).thenAnswer((_) async => Right(tMultiplicationExercise));
    final result = await usecase(NoParams());
    expect(result, Right(tMultiplicationExercise));
    verify(mockPracticeRepository.generateMultiplicationExercise());
    verifyNoMoreInteractions(mockPracticeRepository);
  });
}
