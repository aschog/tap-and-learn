import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tap_and_learn/core/usecases/usecase.dart';
import 'package:tap_and_learn/features/arithmetic/domain/usecases/get_selected_operands1.dart';
import 'package:tap_and_learn/features/arithmetic/domain/usecases/save_selected_operands1.dart';
import 'package:tap_and_learn/features/arithmetic/presentation/widgets/operand_selector/cubit/operand_config_cubit.dart';

import 'operand_config_cubit_test.mocks.dart';

@GenerateMocks([GetSelectedOperands1, SaveSelectedOperands1])
void main() {
  late OperandConfigCubit cubit;
  late MockGetSelectedOperands1 mockGetSelectedOperands1;
  late MockSaveSelectedOperands1 mockSaveSelectedOperands1;

  setUp(() {
    mockGetSelectedOperands1 = MockGetSelectedOperands1();
    mockSaveSelectedOperands1 = MockSaveSelectedOperands1();
    // Default stub for loadOperands
    when(mockGetSelectedOperands1(any))
        .thenAnswer((_) async => const Right([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]));
    when(mockSaveSelectedOperands1(any))
        .thenAnswer((_) async => const Right(null));
  });

  group('OperandConfigCubit', () {
    test('initial state is correct', () {
      cubit = OperandConfigCubit(
        getSelectedOperands1: mockGetSelectedOperands1,
        saveSelectedOperands1: mockSaveSelectedOperands1,
      );
      expect(
          cubit.state,
          const OperandConfigState(
              selectedOperands1: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]));
    });

    blocTest<OperandConfigCubit, OperandConfigState>(
      'emits loaded operands when initialized',
      build: () {
        when(mockGetSelectedOperands1(any))
            .thenAnswer((_) async => const Right([1, 2, 3]));
        return OperandConfigCubit(
          getSelectedOperands1: mockGetSelectedOperands1,
          saveSelectedOperands1: mockSaveSelectedOperands1,
        );
      },
      expect: () => [
        const OperandConfigState(selectedOperands1: [1, 2, 3]),
      ],
      verify: (_) {
        verify(mockGetSelectedOperands1(NoParams())).called(1);
      },
    );

    blocTest<OperandConfigCubit, OperandConfigState>(
      'toggleOperand adds operand if not present and saves',
      build: () => OperandConfigCubit(
        getSelectedOperands1: mockGetSelectedOperands1,
        saveSelectedOperands1: mockSaveSelectedOperands1,
      ),
      act: (cubit) async {
        await Future.delayed(Duration.zero);
        await cubit.toggleOperand(10);
      },
      skip: 1,
      expect: () => [
        const OperandConfigState(
            selectedOperands1: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]),
      ],
      verify: (_) {
        verify(mockSaveSelectedOperands1(
                const Params(operands1: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10])))
            .called(1);
      },
    );

    blocTest<OperandConfigCubit, OperandConfigState>(
      'toggleOperand removes operand if present and saves',
      build: () {
        // Initial load will happen, we just want to test toggle after that
        return OperandConfigCubit(
          getSelectedOperands1: mockGetSelectedOperands1,
          saveSelectedOperands1: mockSaveSelectedOperands1,
        );
      },
      act: (cubit) async {
        await Future.delayed(Duration.zero);
        await cubit.toggleOperand(0);
      },
      skip: 1,
      expect: () => [
        const OperandConfigState(
            selectedOperands1: [1, 2, 3, 4, 5, 6, 7, 8, 9]),
      ],
      verify: (_) {
        verify(mockSaveSelectedOperands1(
            const Params(operands1: [1, 2, 3, 4, 5, 6, 7, 8, 9]))).called(1);
      },
    );

    blocTest<OperandConfigCubit, OperandConfigState>(
      'updateOperands1 updates list and saves',
      build: () => OperandConfigCubit(
        getSelectedOperands1: mockGetSelectedOperands1,
        saveSelectedOperands1: mockSaveSelectedOperands1,
      ),
      act: (cubit) async {
        await Future.delayed(Duration.zero);
        await cubit.updateOperands1([1, 2]);
      },
      skip: 1,
      expect: () => [
        const OperandConfigState(selectedOperands1: [1, 2]),
      ],
      verify: (_) {
        verify(mockSaveSelectedOperands1(const Params(operands1: [1, 2])))
            .called(1);
      },
    );
  });
}
