import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tap_and_learn/core/error/faiures.dart';
import 'package:tap_and_learn/features/arithmetic/data/datasources/arithmetic_local_data_source.dart';
import 'package:tap_and_learn/features/arithmetic/data/models/exercise_model.dart';
import 'package:tap_and_learn/features/arithmetic/data/repositories/arithmetic_repository_impl.dart';
import 'package:tap_and_learn/features/arithmetic/domain/entities/exercise.dart';
import 'arithmetic_repository_impl_test.mocks.dart';

@GenerateMocks([ArithmeticLocalDataSource])
void main() {
  late ArithmeticRepositoryImpl repository;
  late MockArithmeticLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockArithmeticLocalDataSource();
    repository = ArithmeticRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  const tExerciseModel =
      ExerciseModel(operand1: 2, operand2: 3, result: 6);
  const Exercise tExercise = tExerciseModel;
  final operands = [2];

  group('generateExercise', () {
    test(
      'should return local data when the call to local data source is successful',
      () async {
        // arrange
        when(
          mockLocalDataSource.generateExercise(any),
        ).thenAnswer((_) async => tExerciseModel);
        // act
        final result = await repository.generateExercise(operands);
        // assert
        verify(mockLocalDataSource.generateExercise(operands));
        expect(result, equals(const Right(tExercise)));
      },
    );
  });

  group('getSelectedOperands1', () {
    final tOperands = [1, 2, 3];

    test(
        'should return list of ints when call to local data source is successful',
        () async {
      // arrange
      when(mockLocalDataSource.getSelectedOperands1())
          .thenAnswer((_) async => tOperands);
      // act
      final result = await repository.getSelectedOperands1();
      // assert
      verify(mockLocalDataSource.getSelectedOperands1());
      expect(result, equals(Right(tOperands)));
    });

    test('should return CacheFailure when call to local data source fails',
        () async {
      // arrange
      when(mockLocalDataSource.getSelectedOperands1()).thenThrow(Exception());
      // act
      final result = await repository.getSelectedOperands1();
      // assert
      verify(mockLocalDataSource.getSelectedOperands1());
      expect(result, equals(Left(CacheFailure())));
    });
  });

  group('saveSelectedOperands1', () {
    final tOperands = [1, 2, 3];

    test('should call local data source to save data', () async {
      // arrange
      when(mockLocalDataSource.saveSelectedOperands1(any))
          .thenAnswer((_) async => Future.value());
      // act
      final result = await repository.saveSelectedOperands1(tOperands);
      // assert
      verify(mockLocalDataSource.saveSelectedOperands1(tOperands));
      expect(result, equals(const Right(null)));
    });

    test('should return CacheFailure when call to local data source fails',
        () async {
      // arrange
      when(mockLocalDataSource.saveSelectedOperands1(any))
          .thenThrow(Exception());
      // act
      final result = await repository.saveSelectedOperands1(tOperands);
      // assert
      verify(mockLocalDataSource.saveSelectedOperands1(tOperands));
      expect(result, equals(Left(CacheFailure())));
    });
  });
}
