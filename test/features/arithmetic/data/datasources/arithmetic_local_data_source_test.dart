import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tap_and_learn/features/arithmetic/data/datasources/arithmetic_local_data_source.dart';
import 'package:tap_and_learn/features/arithmetic/data/models/multiplication_exercise_model.dart';

import 'arithmetic_local_data_source_test.mocks.dart';

@GenerateMocks([Random])
void main() {
  late MockRandom mockRandom;
  late ArithmeticLocalDataSourceImpl dataSource;

  // Setup runs before each test
  setUp(() {
    mockRandom = MockRandom();
    dataSource = ArithmeticLocalDataSourceImpl(random: mockRandom);
  });

  const List<int> testMultiplicands = [2, 4, 6, 8, 10];

  test('should generate exercise with correct calculation based on mock calls',
      () async {
    // ARRANGE
    const int listLength = 5; // max for multiplicand index: 5
    const int maxMultiplier = 10; // max for multiplier value: 10

    const int selectedIndex = 3; // We force the index to be 3 (value 8)
    const int expectedMultiplicand = 8;
    const int expectedMultiplier = 7; // We force the multiplier to be 7
    const int expectedProduct = 56;

    // Stub 1st call: random.nextInt(5) -> 3 (to select 8)
    when(mockRandom.nextInt(listLength)).thenReturn(selectedIndex);

    // Stub 2nd call: random.nextInt(10) -> 7 (to select 7)
    when(mockRandom.nextInt(maxMultiplier)).thenReturn(expectedMultiplier);

    // ACT
    final result =
        await dataSource.generateMultiplicationExercise(testMultiplicands);

    // ASSERT
    expect(result.multiplicand, equals(expectedMultiplicand));
    expect(result.multiplier, equals(expectedMultiplier));
    expect(result.product, equals(expectedProduct));

    // VERIFY: Check that the exact calls were made
    verify(mockRandom.nextInt(listLength)).called(1);
    verify(mockRandom.nextInt(maxMultiplier)).called(1);
    verifyNoMoreInteractions(mockRandom);
  });

  test('should correctly handle edge case where multiplier is zero', () async {
    // ARRANGE
    const int listLength = 5;
    const int maxMultiplier = 10;

    const int selectedIndex = 0; // Selects 2
    const int expectedMultiplicand = 2;
    const int expectedMultiplier = 0; // Forced minimum value
    const int expectedProduct = 0;

    // Stub calls
    when(mockRandom.nextInt(listLength)).thenReturn(selectedIndex);
    when(mockRandom.nextInt(maxMultiplier)).thenReturn(expectedMultiplier);

    // ACT
    final result =
        await dataSource.generateMultiplicationExercise(testMultiplicands);

    // ASSERT
    expect(result.product, equals(expectedProduct));
    expect(result.multiplicand, equals(expectedMultiplicand));

    // VERIFY
    verify(mockRandom.nextInt(listLength)).called(1);
    verify(mockRandom.nextInt(maxMultiplier)).called(1);
    verifyNoMoreInteractions(mockRandom);
  });

  test('should correctly handle edge case of single multiplicand', () async {
    // ARRANGE
    const List<int> singleMultiplicand = [99]; // Length 1
    const int maxMultiplier = 10;

    const int expectedMultiplicand = 99;
    const int expectedMultiplier = 4;
    const int expectedProduct = 396;

    // Stub calls
    // Note: nextInt for multiplicand selection is skipped when length is 1
    when(mockRandom.nextInt(maxMultiplier)).thenReturn(expectedMultiplier);

    // ACT
    final result =
        await dataSource.generateMultiplicationExercise(singleMultiplicand);

    // ASSERT
    expect(result.multiplicand, equals(expectedMultiplicand));
    expect(result.multiplier, equals(expectedMultiplier));
    expect(result.product, equals(expectedProduct));

    // VERIFY
    verify(mockRandom.nextInt(maxMultiplier)).called(1);
    verifyNoMoreInteractions(mockRandom);
  });
}
