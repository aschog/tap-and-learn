import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:multiplication_trainer/features/arithmetic/data/datasources/arithmetic_local_data_source.dart';
import 'package:multiplication_trainer/features/arithmetic/data/models/multiplication_exercise_model.dart';
import 'package:multiplication_trainer/features/arithmetic/data/repositories/arithmetic_repository_impl.dart';
import 'package:multiplication_trainer/features/arithmetic/domain/entities/multiplication_exercise.dart';
import 'arithmetic_repository_impl_test.mocks.dart';

@GenerateMocks([ArithmeticLocalDataSource])
void main() {
  late ArithmeticRepositoryImpl repository;
  late MockArithmeticLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockArithmeticLocalDataSource();
    repository = ArithmeticRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  final tMultiplicationExerciseModel = MultiplicationExerciseModel(
    multiplicand: 2,
    multiplier: 3,
  );
  final MultiplicationExercise tMultiplicationExercise =
      tMultiplicationExerciseModel;
  test(
    'should return lacal data when the call to local data source is successful',
    () async {
      // arrange
      when(
        mockLocalDataSource.generateMultiplicationExercise(),
      ).thenAnswer((_) async => tMultiplicationExerciseModel);
      // act
      final result = await repository.generateMultiplicationExercise();
      // assert
      verify(mockLocalDataSource.generateMultiplicationExercise());
      expect(result, equals(Right(tMultiplicationExercise)));
    },
  );
}
