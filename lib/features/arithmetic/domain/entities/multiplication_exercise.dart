import 'package:equatable/equatable.dart';

class MultiplicationExercise extends Equatable {
  final int multiplicand;
  final int multiplier;
  MultiplicationExercise({
    required this.multiplicand,
    required this.multiplier,
  });

  @override
  List<Object> get props => [multiplicand, multiplier];
}
