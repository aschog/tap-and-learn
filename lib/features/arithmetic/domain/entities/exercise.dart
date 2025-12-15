import 'package:equatable/equatable.dart';

class Exercise extends Equatable {
  final int operand1;
  final int operand2;
  final int result;
  const Exercise(
      {required this.operand1, required this.operand2, required this.result});

  @override
  List<Object> get props => [operand1, operand2, result];
}
