import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tap_and_learn/features/arithmetic/data/datasources/arithmetic_local_data_source.dart';
import 'package:tap_and_learn/features/arithmetic/data/models/multiplication_exercise_model.dart';
import 'package:tap_and_learn/features/arithmetic/data/repositories/arithmetic_repository_impl.dart';
import 'package:tap_and_learn/features/arithmetic/domain/entities/multiplication_exercise.dart';
import 'arithmetic_repository_impl_test.mocks.dart';

@GenerateMocks([ArithmeticLocalDataSource])
void main() {
  late ArithmeticRepositoryImpl repository;
  late MockArithmeticLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockArithmeticLocalDataSource();
    repository = ArithmeticRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  const tMultiplicationExerciseModel =
      MultiplicationExerciseModel(multiplicand: 2, multiplier: 3, product: 6);
  const MultiplicationExercise tMultiplicationExercise =
      tMultiplicationExerciseModel;
  final multiplicands = [2];
  test(
    'should return local data when the call to local data source is successful',
    () async {
      // arrange
      when(
        mockLocalDataSource.generateMultiplicationExercise(any),
      ).thenAnswer((_) async => tMultiplicationExerciseModel);
      // act
      final result =
          await repository.generateMultiplicationExercise(multiplicands);
      // assert
      verify(mockLocalDataSource.generateMultiplicationExercise(multiplicands));
      expect(result, equals(const Right(tMultiplicationExercise)));
    },
  );
}
