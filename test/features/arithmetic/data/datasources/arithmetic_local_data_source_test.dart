import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tap_and_learn/features/arithmetic/data/datasources/arithmetic_local_data_source.dart';

import 'arithmetic_local_data_source_test.mocks.dart';

@GenerateMocks([Random, SharedPreferences])
void main() {
  late MockRandom mockRandom;
  late MockSharedPreferences mockSharedPreferences;
  late ArithmeticLocalDataSourceImpl dataSource;

  // Setup runs before each test
  setUp(() {
    mockRandom = MockRandom();
    mockSharedPreferences = MockSharedPreferences();
    dataSource = ArithmeticLocalDataSourceImpl(
      random: mockRandom,
      sharedPreferences: mockSharedPreferences,
    );
  });

  const List<int> testOperands = [2, 4, 6, 8, 10];

  group('generateExercise', () {
    test(
        'should generate exercise with correct calculation based on mock calls',
        () async {
      // ARRANGE
      const int listLength = 5; // max for operand index: 5
      const int maxMultiplier = 10; // max for multiplier value: 10

      const int selectedIndex = 3; // We force the index to be 3 (value 8)
      const int expectedOperand = 8;
      const int expectedMultiplier = 7; // We force the multiplier to be 7
      const int expectedProduct = 56;

      // Stub 1st call: random.nextInt(5) -> 3 (to select 8)
      when(mockRandom.nextInt(listLength)).thenReturn(selectedIndex);

      // Stub 2nd call: random.nextInt(10) -> 7 (to select 7)
      when(mockRandom.nextInt(maxMultiplier)).thenReturn(expectedMultiplier);

      // ACT
      final result = await dataSource.generateExercise(testOperands);

      // ASSERT
      expect(result.operand1, equals(expectedOperand));
      expect(result.operand2, equals(expectedMultiplier));
      expect(result.result, equals(expectedProduct));

      // VERIFY: Check that the exact calls were made
      verify(mockRandom.nextInt(listLength)).called(1);
      verify(mockRandom.nextInt(maxMultiplier)).called(1);
      verifyNoMoreInteractions(mockRandom);
    });

    test('should correctly handle edge case where multiplier is zero',
        () async {
      // ARRANGE
      const int listLength = 5;
      const int maxMultiplier = 10;

      const int selectedIndex = 0; // Selects 2
      const int expectedOperand = 2;
      const int expectedMultiplier = 0; // Forced minimum value
      const int expectedProduct = 0;

      // Stub calls
      when(mockRandom.nextInt(listLength)).thenReturn(selectedIndex);
      when(mockRandom.nextInt(maxMultiplier)).thenReturn(expectedMultiplier);

      // ACT
      final result = await dataSource.generateExercise(testOperands);

      // ASSERT
      expect(result.result, equals(expectedProduct));
      expect(result.operand1, equals(expectedOperand));

      // VERIFY
      verify(mockRandom.nextInt(listLength)).called(1);
      verify(mockRandom.nextInt(maxMultiplier)).called(1);
      verifyNoMoreInteractions(mockRandom);
    });

    test('should correctly handle edge case of single operand', () async {
      // ARRANGE
      const List<int> singleOperand = [99]; // Length 1
      const int maxMultiplier = 10;

      const int expectedOperand = 99;
      const int expectedMultiplier = 4;
      const int expectedProduct = 396;

      // Stub calls
      // Note: nextInt for operand selection is skipped when length is 1
      when(mockRandom.nextInt(maxMultiplier)).thenReturn(expectedMultiplier);

      // ACT
      final result = await dataSource.generateExercise(singleOperand);

      // ASSERT
      expect(result.operand1, equals(expectedOperand));
      expect(result.operand2, equals(expectedMultiplier));
      expect(result.result, equals(expectedProduct));

      // VERIFY
      verify(mockRandom.nextInt(maxMultiplier)).called(1);
      verifyNoMoreInteractions(mockRandom);
    });
  });

  group('getSelectedOperands1', () {
    test('should return cached operands when available', () async {
      // ARRANGE
      final List<String> cachedList = ['1', '2', '3'];
      final List<int> expectedList = [1, 2, 3];
      when(mockSharedPreferences.getStringList(cachedOperandsKey))
          .thenReturn(cachedList);

      // ACT
      final result = await dataSource.getSelectedOperands1();

      // ASSERT
      expect(result, equals(expectedList));
      verify(mockSharedPreferences.getStringList(cachedOperandsKey)).called(1);
    });

    test('should return default operands when not available', () async {
      // ARRANGE
      when(mockSharedPreferences.getStringList(cachedOperandsKey))
          .thenReturn(null);
      final List<int> expectedList = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

      // ACT
      final result = await dataSource.getSelectedOperands1();

      // ASSERT
      expect(result, equals(expectedList));
      verify(mockSharedPreferences.getStringList(cachedOperandsKey)).called(1);
    });
  });

  group('saveSelectedOperands1', () {
    test('should call setStringList with correct values', () async {
      // ARRANGE
      final List<int> operands = [1, 2, 3];
      final List<String> expectedStringList = ['1', '2', '3'];
      when(mockSharedPreferences.setStringList(any, any))
          .thenAnswer((_) async => true);

      // ACT
      await dataSource.saveSelectedOperands1(operands);

      // ASSERT
      verify(mockSharedPreferences.setStringList(
              cachedOperandsKey, expectedStringList))
          .called(1);
    });
  });
}
