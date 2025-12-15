import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tap_and_learn/features/arithmetic/domain/repositories/arithmetic_repository.dart';
import 'package:tap_and_learn/features/arithmetic/domain/usecases/save_selected_operands1.dart';

import 'save_selected_operands1_test.mocks.dart';

@GenerateMocks([ArithmeticRepository])
void main() {
  late SaveSelectedOperands1 usecase;
  late MockArithmeticRepository mockRepository;

  setUp(() {
    mockRepository = MockArithmeticRepository();
    usecase = SaveSelectedOperands1(mockRepository);
  });

  final tOperands = [1, 2, 3];

  test('should save list of operands to the repository', () async {
    // arrange
    when(mockRepository.saveSelectedOperands1(any))
        .thenAnswer((_) async => const Right(null));
    // act
    final result = await usecase(Params(operands1: tOperands));
    // assert
    expect(result, const Right(null));
    verify(mockRepository.saveSelectedOperands1(tOperands));
    verifyNoMoreInteractions(mockRepository);
  });
}
