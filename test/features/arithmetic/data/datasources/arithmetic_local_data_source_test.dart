import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:multiplication_trainer/features/arithmetic/data/datasources/arithmetic_local_data_source.dart';
import 'package:multiplication_trainer/features/arithmetic/data/models/multiplication_exercise_model.dart';

import 'arithmetic_local_data_source_test.mocks.dart';

@GenerateMocks([Random])
void main() {
  late MockRandom mockRandom;
  late ArithmeticLocalDataSource dataSource;

  setUp(() {
    mockRandom = MockRandom();
    dataSource = ArithmeticLocalDataSourceIml(random: mockRandom);
  });

  group('generetaMultiplicationExercise', () {
    final tMultiplicationExerciseModel = MultiplicationExerciseModel(
      multiplicand: 2,
      multiplier: 3,
    );
    test('should return MultiplicationExercise', () async {
      when(mockRandom.nextInt(any)).thenReturnInOrder([2, 3]);
      final result = await dataSource.generateMultiplicationExercise();
      expect(result, tMultiplicationExerciseModel);
      verify(mockRandom.nextInt(any)).called(2);
      verifyNoMoreInteractions(mockRandom);
    });
  });
}
