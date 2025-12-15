import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tap_and_learn/core/usecases/usecase.dart';
import 'package:tap_and_learn/features/arithmetic/domain/usecases/get_selected_operands1.dart';
import 'package:tap_and_learn/features/arithmetic/domain/usecases/save_selected_operands1.dart';

class OperandConfigState extends Equatable {
  final List<int> selectedOperands1;

  const OperandConfigState({required this.selectedOperands1});

  factory OperandConfigState.initial() {
    return const OperandConfigState(
      selectedOperands1: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    );
  }

  OperandConfigState copyWith({List<int>? selectedOperands1}) {
    return OperandConfigState(
      selectedOperands1: selectedOperands1 ?? this.selectedOperands1,
    );
  }

  @override
  List<Object> get props => [selectedOperands1];
}

class OperandConfigCubit extends Cubit<OperandConfigState> {
  final GetSelectedOperands1 getSelectedOperands1;
  final SaveSelectedOperands1 saveSelectedOperands1;

  OperandConfigCubit({
    required this.getSelectedOperands1,
    required this.saveSelectedOperands1,
  }) : super(OperandConfigState.initial()) {
    _loadOperands1();
  }

  Future<void> _loadOperands1() async {
    final result = await getSelectedOperands1(NoParams());
    result.fold(
      (failure) => null, // Keep initial state on failure
      (operands1) => emit(state.copyWith(selectedOperands1: operands1)),
    );
  }

  Future<void> toggleOperand(int operand) async {
    final currentSelection = List<int>.from(state.selectedOperands1);
    if (currentSelection.contains(operand)) {
      if (currentSelection.length > 1) {
        currentSelection.remove(operand);
      }
    } else {
      currentSelection.add(operand);
    }
    currentSelection.sort();
    emit(state.copyWith(selectedOperands1: currentSelection));
    await saveSelectedOperands1(Params(operands1: currentSelection));
  }

  Future<void> updateOperands1(List<int> newOperands) async {
    final sorted = List<int>.from(newOperands)..sort();
    emit(state.copyWith(selectedOperands1: sorted));
    await saveSelectedOperands1(Params(operands1: sorted));
  }
}
