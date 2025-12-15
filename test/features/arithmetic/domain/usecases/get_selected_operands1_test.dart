import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tap_and_learn/core/usecases/usecase.dart';
import 'package:tap_and_learn/features/arithmetic/domain/repositories/arithmetic_repository.dart';
import 'package:tap_and_learn/features/arithmetic/domain/usecases/get_selected_operands1.dart';

import 'get_selected_operands1_test.mocks.dart';

@GenerateMocks([ArithmeticRepository])
void main() {
  late GetSelectedOperands1 usecase;
  late MockArithmeticRepository mockRepository;

  setUp(() {
    mockRepository = MockArithmeticRepository();
    usecase = GetSelectedOperands1(mockRepository);
  });

  final tOperands = [1, 2, 3];

  test('should get list of operands from the repository', () async {
    // arrange
    when(mockRepository.getSelectedOperands1())
        .thenAnswer((_) async => Right(tOperands));
    // act
    final result = await usecase(NoParams());
    // assert
    expect(result, Right(tOperands));
    verify(mockRepository.getSelectedOperands1());
    verifyNoMoreInteractions(mockRepository);
  });
}
